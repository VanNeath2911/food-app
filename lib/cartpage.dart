import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_app/cartprovider.dart';

class CartPage extends StatefulWidget {
  final String userId;
  final String password;

  const CartPage({super.key, required this.userId, required this.password});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isProcessing = false;
  final cart = CartProvider();

  Future<void> confirmBooking() async {
    if (cart.items.isEmpty) return;

    setState(() => isProcessing = true);

    try {
      // ១. រៀបចំទិន្នន័យកុម្ម៉ង់
      List<Map<String, dynamic>> currentOrderItems = cart.items
          .map(
            (item) => {
              "name": item.name,
              "size": item.size,
              "price": item.price,
              "quantity": item.quantity,
              "total": item.price * item.quantity,
            },
          )
          .toList();

      // ២. រក្សាទុកទៅ Firebase (Status: Paid)
      // collection_credential -> username -> orders
      await FirebaseFirestore.instance.collection("collection_credential").doc(widget.userId).set({
        "username": widget.userId,
        "password": widget.password,
        "last_order_at": FieldValue.serverTimestamp(),
        "orders": FieldValue.arrayUnion([
          {
            "order_id": DateTime.now().millisecondsSinceEpoch.toString(),
            "items": currentOrderItems,
            "total_bill": cart.totalAmount,
            "status": "Paid", // ប្តូរស្ថានភាពទៅជា Paid ក្នុង Database
            "timestamp": DateTime.now(),
          },
        ]),
      }, SetOptions(merge: true));

      // ៣. លុបទិន្នន័យក្នុងកន្ត្រក (UI នឹងបង្ហាញ "Your cart is empty" ភ្លាមៗ)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Payment Successful! Order status: Paid"), backgroundColor: Colors.green),
        );
        // មិនប្រើ Navigator.pop ទេ ដើម្បីឱ្យវានៅទំព័រដដែល
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order Cart"), backgroundColor: const Color(0xFF66B2C3)),
      body: ListenableBuilder(
        listenable: cart,
        builder: (context, child) {
          return Column(
            children: [
              Expanded(
                child: cart.items.isEmpty
                    ? const Center(
                        child: Text(
                          "Your cart is empty", // UI បង្ហាញនៅពេល Paid រួច
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: cart.items.length,
                        itemBuilder: (context, index) {
                          final item = cart.items[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: ListTile(
                              leading: Image.asset(item.imagePath, width: 45),
                              title: Text("${item.name} (${item.size})"),
                              subtitle: Text("\$${(item.price * item.quantity).toStringAsFixed(2)}"),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline, color: Colors.orange),
                                    onPressed: () {
                                      setState(() {
                                        if (item.quantity > 1) {
                                          item.quantity--;
                                        } else {
                                          cart.removeItem(item.id);
                                        }
                                      });
                                    },
                                  ),
                                  Text("${item.quantity}", style: const TextStyle(fontWeight: FontWeight.bold)),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                                    onPressed: () {
                                      setState(() {
                                        item.quantity++;
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => setState(() => cart.removeItem(item.id)),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              if (cart.items.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Total Bill:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          Text(
                            "\$${cart.totalAmount.toStringAsFixed(2)}",
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: isProcessing ? null : confirmBooking,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF66B2C3),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          child: isProcessing
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  "Confirm Payment",
                                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
