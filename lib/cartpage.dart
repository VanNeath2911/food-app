import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// 1. DATA MODEL
class CartItem {
  final String id;
  final String name;
  final String category;
  final String size;
  final double price;
  int quantity;
  final String? imagePath;

  CartItem({
    required this.id,
    required this.name,
    required this.category,
    required this.size,
    required this.price,
    this.quantity = 1,
    this.imagePath,
  });

  double get totalPrice => price * quantity;
}

// 2. STATE MANAGER (Singleton)
class CartProvider extends ChangeNotifier {
  static final CartProvider _instance = CartProvider._internal();
  factory CartProvider() => _instance;
  CartProvider._internal();

  final List<CartItem> _items = [];
  List<CartItem> get items => _items;

  double get totalAmount => _items.fold(0, (sum, item) => sum + item.totalPrice);

  void addItem(CartItem newItem) {
    final index = _items.indexWhere((item) => item.id == newItem.id && item.size == newItem.size);
    if (index != -1) {
      _items[index].quantity += 1;
    } else {
      _items.add(newItem);
    }
    notifyListeners();
  }

  void removeItem(String id, String size) {
    final index = _items.indexWhere((item) => item.id == id && item.size == size);
    if (index != -1) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

// 3. UI PAGE
class CartPage extends StatefulWidget {
  const CartPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartProvider _cartProvider = CartProvider();
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _cartProvider.addListener(() => setState(() {}));
  }

  Future<void> _confirmBooking() async {
    if (_cartProvider.items.isEmpty) return;
    setState(() => _isProcessing = true);

    try {
      // This creates the collection "collection_credential" automatically
      final docRef = FirebaseFirestore.instance.collection('collection_credential').doc();

      await docRef.set({
        'orderId': docRef.id,
        'timestamp': FieldValue.serverTimestamp(),
        'totalPrice': _cartProvider.totalAmount,
        'items': _cartProvider.items
            .map(
              (item) => {
                'name': item.name,
                'size': item.size,
                'quantity': item.quantity,
                'price': item.price,
                'category': item.category,
              },
            )
            .toList(),
      });

      _cartProvider.clear();
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Success"),
          content: const Text("Booking confirmed and saved to Firebase!"),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("OK"))],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), backgroundColor: const Color(0xFF66B2C3)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _cartProvider.items.length,
              itemBuilder: (context, i) {
                final item = _cartProvider.items[i];
                return ListTile(
                  leading: Image.asset(item.imagePath!, width: 50),
                  title: Text(item.name),
                  subtitle: Text("Size: ${item.size} x ${item.quantity}"),
                  trailing: Text("\$${item.totalPrice.toStringAsFixed(2)}"),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: const Color(0xFF66B2C3),
              ),
              onPressed: _isProcessing ? null : _confirmBooking,
              child: _isProcessing
                  ? const CircularProgressIndicator()
                  : Text("Confirm Booking (\$${_cartProvider.totalAmount.toStringAsFixed(2)})"),
            ),
          ),
        ],
      ),
    );
  }
}
