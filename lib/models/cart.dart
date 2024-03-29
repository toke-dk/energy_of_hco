import 'dart:collection';

import 'package:energy_of_hco/helpers/math.dart';
import 'package:energy_of_hco/models/order.dart';
import 'package:energy_of_hco/models/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:collection/collection.dart'; // You have to add this manually, for some reason it cannot be added automatically

class ShopListItem {
  CartItem item;
  int amountBrought;

  ShopListItem({required this.item, required this.amountBrought});

  void changePurchasedAmount(int newAmount) {
    amountBrought += newAmount;
  }
}

extension ShopListExtension on List<ShopListItem> {
  ///TODO: make some more metohds in here
  ///example[addOrderToItem] and [addItemOrIncrementAmountToCartItems]
  void addItemsFromOrder(Order order) {
    if (isEmpty) {
      addAll(order.cart.map((cart) => ShopListItem(item: cart, amountBrought: 0)));
    } else {
      for (var itemInOrder in order.cart) {
        CartItem? itemFromCart = map((e) => e.item).toList().getItemByProduct(itemInOrder.product);
        if (itemFromCart == null) {
          add(ShopListItem(item: itemInOrder, amountBrought: 0));
        } else {
          itemFromCart.changeAmount(itemInOrder.amount);
        }
      }
    }
  }
}

class CartItem {
  int amount;
  Product product;

  CartItem({
    required this.amount,
    required this.product,
  });

  get totalPriceForItem =>
      myDoubleCorrector(amount * product.priceExclDepositDKK);

  void changeAmount(int newAmount) {
    amount += newAmount;
  }
}

/// Next day we are going to make a difference between the model and the actual
/// thingy
extension CartItemListExtension on List<CartItem> {

  double get productsPrice => isNotEmpty
      ? myDoubleCorrector(map((item) => item.amount * item.product.priceExclDepositDKK)
          .reduce((value, element) => value + element))
      : 0;

  int get amountOfProductsInItems => isNotEmpty
      ? map((e) => e.amount)
          .reduce((value, element) => value + element)
      : 0;

  List<Product> get getProductsInCart => map((e) => e.product).toList();

  int getAmountByProduct(Product product) {
    return firstWhere((element) => element.product == product).amount;
  }

  void addItem(CartItem item) {
    add(item);
  }

  void removeItem(CartItem item) {
    remove(item);
  }

  void removeItemByProduct(Product product) {
    removeWhere((item) => item.product == product);
  }

  void changeItemAmount(CartItem item, int newAmount) {
    item.changeAmount(newAmount);
  }

  CartItem? getItemByProduct(Product product){
    return firstWhereOrNull(
            (element) => element.product == product);
  }
}