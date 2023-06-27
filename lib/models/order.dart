import 'dart:collection';

import 'package:energy_of_hco/models/cart.dart';
import 'package:energy_of_hco/models/item_categories.dart';
import 'package:energy_of_hco/models/product.dart';
import 'package:energy_of_hco/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:energy_of_hco/widgets/days_scroll.dart';

class Order {
  final User user;
  final CartModel cart;
  final double totalPrice;
  final DateTime date;

  Order({
    required this.totalPrice,
    required this.user,
    required this.cart,
    required this.date,
  });
}

class OrdersProvider extends ChangeNotifier {
  /// Date of orders
  DateTime _currentDay = DateTime.now();

  DateTime get getCurrentDay => _currentDay;

  void changeDay(DateTime newDate) {
    _currentDay = newDate;
    notifyListeners();
  }

  /// Orders for day
  final List<Order> _ordersForCurrentDate = [];

  List<Order> get getOrdersForDay => UnmodifiableListView(_ordersForCurrentDate
      .where((element) => element.date.isSameDate(_currentDay)));

  void addOrderForCurDay(Order order) {
    _ordersForCurrentDate.add(order);
    notifyListeners();
  }

  void removeOrderForCurDay(Order order) {
    _ordersForCurrentDate.remove(order);
    notifyListeners();
  }

  /// Shopping List Management
  CartModel? _shoppingList;

  CartModel get getShoppingList {
    _createShoppingListForDay();
    _sortShoppingList();
    return _shoppingList!;
  }

  void _createShoppingListForDay() {
    _shoppingList = CartModel(cartItems: _ordersForCurrentDate
        .map((order) => order.cart.cartItems.map((item) => item.product))
        .expand((hype) => hype)
        .toSet()
        .toList()
        .map((product) => CartItem(
            product: product,
            amount: _ordersForCurrentDate
                .map((order) =>
                    order.cart.cartItems.map((f) => f.product).contains(product)
                        ? order.cart.getAmountByProduct(product)
                        : 0)
                .reduce((a, b) => a + b)))
        .toList());
  }

  void _sortShoppingList(){
    _shoppingList!.cartItems.sort((a,b)=>a.product.brand.displayName.compareTo(b.product.brand.displayName));
  }
}
