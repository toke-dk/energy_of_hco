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
  
  List<CartItem> get getItems => UnmodifiableListView(_cartItems);

  int get length => _cartItems.length;
  
  void addItem(CartItem item) {
    _cartItems.add(item);
    notifyListeners();
  }
  
  void removeItem(CartItem item) {
    _cartItems.remove(item);
  }


}
