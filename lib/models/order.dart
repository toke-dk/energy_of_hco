import 'dart:collection';

import 'package:energy_of_hco/models/cart.dart';
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

  List<Order> get getOrdersForDay =>
      UnmodifiableListView(_ordersForCurrentDate.where((element) =>
          element.date.isSameDate(_currentDay)));

  void addOrderForCurDay(Order order) {
    _ordersForCurrentDate.add(order);
    notifyListeners();
  }

  void removeOrderForCurDay(Order order) {
    _ordersForCurrentDate.remove(order);
    notifyListeners();
  }
}