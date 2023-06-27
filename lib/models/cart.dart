import 'dart:collection';

import 'package:energy_of_hco/helpers/math.dart';
import 'package:energy_of_hco/models/order.dart';
import 'package:energy_of_hco/models/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:collection/collection.dart'; // You have to add this manually, for some reason it cannot be added automatically

class CartItem {
  int amount;
  int? amountPurchased;
  Product product;

  CartItem({
    this.amountPurchased,
    required this.amount,
    required this.product,
  });

  get totalPriceForItem =>
      myDoubleCorrector(amount * product.priceExclDepositDKK);

  void changeAmount(int newAmount) {
    amount += newAmount;
  }

  void changePurchasedAmount(int newAmount) {
    amountPurchased =
        amountPurchased == null ? newAmount : amountPurchased! + newAmount;
  }
}

/// Next day we are going to make a difference between the model and the actual
/// thingy
class CartModel extends ChangeNotifier {
  List<CartItem> cartItems;

  CartModel({
    required this.cartItems,
  });

  double get productsPrice => cartItems.isNotEmpty
      ? myDoubleCorrector(cartItems
          .map((item) => item.amount * item.product.priceExclDepositDKK)
          .reduce((value, element) => value + element))
      : 0;

  int get allProducts => cartItems.isNotEmpty
      ? cartItems
          .map((e) => e.amount)
          .reduce((value, element) => value + element)
      : 0;

  int getAmountByProduct(Product product) {
    return cartItems.firstWhere((element) => element.product == product).amount;
  }

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

  void addItemsFromOrder(Order order) {
    if (cartItems.isEmpty) {
      cartItems.addAll(order.cart.cartItems.map((e) => e));
    } else {
      for (var itemInOrder in order.cart.cartItems) {
        CartItem? first = cartItems.firstWhereOrNull(
            (element) => element.product == itemInOrder.product);
        if (first == null) {
          cartItems.add(itemInOrder);
        } else {
          first.changeAmount(itemInOrder.amount);
        }
      }
    }
  }
}
