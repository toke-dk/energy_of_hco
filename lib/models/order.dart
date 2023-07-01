import 'dart:collection';
import 'dart:math';

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

enum OrderProcesses { pendingOrder, brought, paid, delivered }

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
    _shoppingList = [];
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

  ShopListItem _getItemFromShoppingList(ShopListItem item) {
    return _shoppingList.firstWhere((element) => element == item);
  }

  /// Pending + Brought Orders
  late final List<Order> _pendingOrders = _ordersForCurrentDate
      .where((order) => order.orderProcess == OrderProcesses.pendingOrder)
      .toList();

  List<Order> get getPendingOrdersForDay {
    return UnmodifiableListView(_ordersForCurrentDate
        .where((order) => order.orderProcess == OrderProcesses.pendingOrder));
  }

  late final List<Order> _broughtOrders = _ordersForCurrentDate
      .where((element) => element.orderProcess == OrderProcesses.brought)
      .toList();

  List<Order> get getBroughtOrders => UnmodifiableListView(_ordersForCurrentDate
      .where((order) => order.orderProcess == OrderProcesses.brought));

  /// Shopping List Management
  late final List<ShopListItem> _shoppingList;

  List<ShopListItem> get getShoppingList {
    return List.unmodifiable(_shoppingList);
  }

  void _sortShoppingList() {
    _shoppingList.sort((a, b) => a.item.product.brand.displayName
        .compareTo(b.item.product.brand.displayName));
  }

  void changeShopListItemPurchase(ShopListItem item, int newAmount) {
    _getItemFromShoppingList(item).changePurchasedAmount(newAmount);
    notifyListeners();
  }
}
