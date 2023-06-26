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