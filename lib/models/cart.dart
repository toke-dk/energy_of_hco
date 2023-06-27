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

  get totalPriceForItem => myDoubleCorrector(amount * product.priceExclDepositDKK);

  void changeAmount(int newAmount) {
    amount += newAmount;
  }
}

class CartModel extends ChangeNotifier {
  List<CartItem> cartItems;

  CartModel({
    required this.cartItems,
  });

  double get productsPrice =>
      cartItems.isNotEmpty
          ? myDoubleCorrector(cartItems
          .map((item) => item.amount * item.product.priceExclDepositDKK)
          .reduce((value, element) => value + element))
          : 0;

  int get allProducts =>
      cartItems.isNotEmpty
          ? cartItems
          .map((e) => e.amount)
          .reduce((value, element) => value + element)
          : 0;

  void addItem(CartItem item) {
    cartItems.add(item);
  }

  void removeItem(CartItem item) {
    cartItems.remove(item);
  }

  void removeItemByProduct(Product product) {
    cartItems.removeWhere((item) => item.product == product);
  }

  void changeItemAmount(CartItem item, int newAmount) {
    item.changeAmount(newAmount);
  }
}
