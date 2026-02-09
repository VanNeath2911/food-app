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
  // បង្កើត Singleton Pattern ដើម្បីប្រើប្រាស់ Cart តែមួយទូទាំង App
  static final CartProvider _instance = CartProvider._internal();
  factory CartProvider() => _instance;
  CartProvider._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  // គណនាតម្លៃសរុបក្នុងកន្ត្រក
  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  // បន្ថែមទំនិញចូលកន្ត្រក (បើមានហើយ វានឹងថែមចំនួន quantity)
  void addItem(CartItem newItem) {
    int index = _items.indexWhere((i) => i.id == newItem.id);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(newItem);
    }
    notifyListeners();
  }

  // មុខងារបន្ថែមចំនួន (ប៊ូតុង Plus ក្នុង CartPage)
  void incrementItem(String id) {
    int index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  // មុខងារបន្ថយចំនួន (ប៊ូតុង Minus ក្នុង CartPage)
  // បើថយដល់ ០ វានឹងលុបទំនិញនោះចេញពីកន្ត្រកដោយស្វ័យប្រវត្តិ
  void decrementItem(String id) {
    int index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  // លុបទំនិញចេញពីកន្ត្រក
  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}
