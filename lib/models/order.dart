import 'dart:collection';

import 'package:energy_of_hco/models/cart.dart';
import 'package:energy_of_hco/models/user.dart';
import 'package:flutter/cupertino.dart';

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

class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get getOrders => UnmodifiableListView(_orders);

  void addOrder(Order order){
    _orders.add(order);
    notifyListeners();
  }

  void removeOrder(Order order){
    _orders.remove(order);
    notifyListeners();
  }


}