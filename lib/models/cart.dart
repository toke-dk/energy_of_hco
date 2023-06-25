import 'dart:collection';

import 'package:energy_of_hco/helpers/math.dart';
import 'package:energy_of_hco/models/product.dart';
import 'package:flutter/cupertino.dart';

class CartItem {
  int amount;
  Product product;

  CartItem({
    required this.amount,
    required this.product,
  });

  get totalPriceForItem => myDoubleCorrector(amount * product.priceInDKK);

  void changeAmount(int newAmount) => amount += newAmount;
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

  int get productsLength => _cartItems.isNotEmpty
      ? _cartItems.map((item) => item.amount).reduce((a, b) => a + b)
      : 0;

  int get itemsLength => _cartItems.length;

  double? get getTotalItemsCost => _cartItems.isNotEmpty
      ? myDoubleCorrector(_cartItems
          .map((item) => item.totalPriceForItem)
          .reduce((a, b) => a + b))
      : null;

  double get serviceFeesInDkk => _serviceFeesInDKK;

  void addItem(CartItem item) {
    _cartItems.add(item);
    notifyListeners();
  }

  void removeCartItem(CartItem item) {
    _cartItems.remove(item);
    notifyListeners();
  }

  void removeItemByProduct(Product product) {
    _cartItems.removeWhere((CartItem item) => item.product == product);
    notifyListeners();
  }

  void editItemAmount(CartItem item, int amount) {
    CartItem itemToChange =
        _cartItems.firstWhere((indexItem) => item == indexItem);
    itemToChange.amount + amount >= 0
        ? itemToChange.changeAmount(amount)
        : null;
    notifyListeners();
  }
}
