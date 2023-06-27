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
}

enum OrderProcesses { ordered, bought, paid, delivered }

class OrdersProvider extends ChangeNotifier {
  /// Initialisation
  void ordersProviderInit(){
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
    return _shoppingList.cartItems.firstWhere((element) => element == item);
  }

  /// Shopping List Management
  late CartModel _shoppingList;

  CartModel get getShoppingList {return _shoppingList;}

  void _createShoppingFromOrdersForDay() {
    _shoppingList = CartModel(
        cartItems: _ordersForCurrentDate
            .map((order) => order.cart.cartItems.map((item) => item.product))
            .expand((hype) => hype)
            .toSet()
            .toList()
            .map((product) => CartItem(
                product: product,
                amount: _ordersForCurrentDate
                    .map((order) => order.cart.cartItems
                            .map((f) => f.product)
                            .contains(product)
                        ? order.cart.getAmountByProduct(product)
                        : 0)
                    .reduce((a, b) => a + b)))
            .toList());
  }

  void _sortShoppingList() {
    _shoppingList.cartItems.sort((a, b) =>
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
