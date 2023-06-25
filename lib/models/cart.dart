import 'dart:collection';

import 'package:energy_of_hco/models/product.dart';
import 'package:flutter/cupertino.dart';

class CartItem {
  int amount;
  Product product;

  CartItem({
    required this.amount,
    required this.product,
  });
}

class Cart extends ChangeNotifier {
  List<CartItem> cartItems;

  Cart({
    required this.cartItems,
  });
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _cartItems = <CartItem>[];
  static const double _serviceFeesInDKK = 8.25;

  List<CartItem> get getItems => UnmodifiableListView(_cartItems);

  int get length => _cartItems.length;

  double? get getTotalItemsCost => _cartItems.isNotEmpty ? _cartItems
      .map((item) => item.product.priceInDKK * item.amount)
      .reduce((a, b) => a + b) : null;

  double get serviceFeesInDkk => _serviceFeesInDKK;

  void addItem(CartItem item) {
    _cartItems.add(item);
    notifyListeners();
  }

  void removeItem(CartItem item) {
    _cartItems.remove(item);
  }

  void removeItemByProduct(Product product) {
    _cartItems.removeWhere((CartItem item) => item.product == product);
    notifyListeners();
  }
}
