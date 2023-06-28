import 'dart:collection';

import 'package:energy_of_hco/models/cart.dart';
import 'package:energy_of_hco/models/item_categories.dart';
import 'package:energy_of_hco/models/product.dart';
import 'package:energy_of_hco/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:energy_of_hco/widgets/days_scroll.dart';

class Order {
  final User user;
  final List<CartItem> cart;
  final double totalPrice;
  final DateTime date;
  OrderProcesses orderProcess;

  Order({
    required this.orderProcess,
    required this.totalPrice,
    required this.user,
    required this.cart,
    required this.date,
  });

  void changeOrderProcess(OrderProcesses newProcess) {
    orderProcess = newProcess;
  }

  int get amountOfProductsInOrder => cart.amountOfProductsInItems;
}

enum OrderProcesses { ordered, bought, paid, delivered }

extension on List<Order> {
  List<Product> get getProductsInOrder => map((order) => order.cart)
      .expand((cartItem) => cartItem)
      .toList()
      .getProductsInCart;
}

class OrdersProvider extends ChangeNotifier {
  /// Initialisation
  void ordersProviderInit() {
    _currentDay = DateTime.now();
    _createShoppingFromOrdersForDay();
    _sortShoppingList();
  }

  /// Date of orders
  late DateTime _currentDay;

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
    _shoppingList.addItemsFromOrder(order);
    _sortShoppingList();
    notifyListeners();
  }

  void removeOrderForCurDay(Order order) {
    _ordersForCurrentDate.remove(order);
    notifyListeners();
  }

  Order _getOrderFromCurrentDayOrders(Order order) {
    return _ordersForCurrentDate.firstWhere((element) => element == order);
  }

  CartItem _getItemFromShoppingList(CartItem item) {
    return _shoppingList.firstWhere((element) => element == item);
  }

  /// Shopping List Management
  late List<CartItem> _shoppingList;

  List<CartItem> get getShoppingList {
    return _shoppingList;
  }

  void _createShoppingFromOrdersForDay() {
    _shoppingList = _ordersForCurrentDate.getProductsInOrder
            .toSet()
            .toList()
            .map((product) => CartItem(
                product: product,
                amount: _ordersForCurrentDate
                    .map((order) => order.cart
                            .map((f) => f.product)
                            .contains(product)
                        ? order.cart.getAmountByProduct(product)
                        : 0)
                    .reduce((a, b) => a + b)))
            .toList();
  }

  void _sortShoppingList() {
    _shoppingList.sort((a, b) =>
        a.product.brand.displayName.compareTo(b.product.brand.displayName));
  }

  void changeOrderProcess(Order order, OrderProcesses newProcess) {
    _getOrderFromCurrentDayOrders(order).changeOrderProcess(newProcess);
    notifyListeners();
  }

  void changeShopListItemPurchase(CartItem item, int newAmount) {
    _getItemFromShoppingList(item).changePurchasedAmount(newAmount);
    notifyListeners();
  }
}
