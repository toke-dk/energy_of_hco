import 'dart:collection';

import 'package:energy_of_hco/models/product.dart';
import 'package:flutter/cupertino.dart';

class UsersNotifier extends ChangeNotifier {
  final List<User> _users = <User>[];

  List<User> get getUsers => UnmodifiableListView(_users);

  void addUser(User user) {
    _users.add(user);
  }
}

class User {
  final String firstName;
  final String lastName;
  final double energyPoints;
  final List<Product> favouriteProducts;

  User(
      {required this.firstName,
      required this.lastName,
      required this.energyPoints,
      required this.favouriteProducts});

  String get generateFullName => "$firstName $lastName";

  String get energyPointsAsString => energyPoints.toString();
}
