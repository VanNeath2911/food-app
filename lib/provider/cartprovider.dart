import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String name;
  final String category;
  final String size;
  final double price;
  final String imagePath;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.category,
    required this.size,
    required this.price,
    required this.imagePath,
    this.quantity = 1,
  });
}

class CartProvider extends ChangeNotifier {
  static final CartProvider _instance = CartProvider._internal();
  factory CartProvider() => _instance;
  CartProvider._internal();

  final List<CartItem> _items = [];
  List<CartItem> get items => _items;

  double get totalAmount => _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));

  void addItem(CartItem newItem) {
    int index = _items.indexWhere((i) => i.id == newItem.id);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(newItem);
    }
    notifyListeners();
  }

  void incrementItem(String id) {
    int index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decrementItem(String id) {
    int index = _items.indexWhere((item) => item.id == id);
    if (index >= 0 && _items[index].quantity > 1) {
      _items[index].quantity--;
      notifyListeners();
    }
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
