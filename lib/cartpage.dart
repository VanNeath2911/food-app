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

  // ១. មុខងារបង្ហាញ Success Dialog ដូចក្នុងរូបភាព
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // ការពារកុំឱ្យចុចបិទដោយខ្លួនឯង
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // រូបរង្វង់ Checkmark ដូចក្នុងរូបថត Screenshot
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: const Icon(Icons.check, size: 50, color: Colors.black),
                ),
                const SizedBox(height: 25),
                const Text(
                  "Payment success",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
                ),
              ],
            ),
          ),
        );
      },
    );

    // បិទ Dialog វិញដោយស្វ័យប្រវត្តិបន្ទាប់ពី ៣ វិនាទី
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  // ២. មុខងាររក្សាទុកទិន្នន័យទៅ Firebase
  Future<void> confirmBooking() async {
    if (cart.items.isEmpty) return;

    setState(() => isProcessing = true);

    try {
      List<Map<String, dynamic>> orderItems = cart.items
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

      // រក្សាទុកក្នុង Firebase collection_credential
      await FirebaseFirestore.instance.collection("collection_credential").doc(widget.userId).set({
        "username": widget.userId,
        "password": widget.password,
        "orders": FieldValue.arrayUnion([
          {
            "order_id": DateTime.now().millisecondsSinceEpoch.toString(),
            "items": orderItems,
            "total_bill": cart.totalAmount,
            "status": "Paid",
            "timestamp": Timestamp.now(),
          },
        ]),
      }, SetOptions(merge: true));

      if (mounted) {
        // បង្ហាញ Dialog ជោគជ័យ
        _showSuccessDialog();

        // សម្អាត Cart បន្ទាប់ពីទិញរួច
        cart.clearCart();
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
      appBar: AppBar(title: const Text("Order Cart"), backgroundColor: const Color(0xFF66B2C3), centerTitle: true),
      body: ListenableBuilder(
        listenable: cart,
        builder: (context, child) {
          if (cart.items.isEmpty) {
            return const Center(
              child: Text("Your cart is empty", style: TextStyle(fontSize: 18, color: Colors.grey)),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        leading: Image.asset(item.imagePath, width: 45),
                        title: Text("${item.name} (${item.size})", style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("\$${item.price.toStringAsFixed(2)} x ${item.quantity}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline, color: Colors.orange),
                              onPressed: () => cart.decrementItem(item.id),
                            ),
                            Text("${item.quantity}", style: const TextStyle(fontSize: 16)),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                              onPressed: () => cart.incrementItem(item.id),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => cart.removeItem(item.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total Bill:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text(
                          "\$${cart.totalAmount.toStringAsFixed(2)}",
                          style: const TextStyle(fontSize: 22, color: Colors.green, fontWeight: FontWeight.bold),
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
