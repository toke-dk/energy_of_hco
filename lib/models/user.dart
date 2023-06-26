import 'dart:collection';

import 'package:energy_of_hco/models/product.dart';
import 'package:flutter/cupertino.dart';

class UsersProvider extends ChangeNotifier {
  final List<User> _users = <User>[];

  List<User> get getUsers => UnmodifiableListView(_users);

  void addUser(User user) {
    _users.add(user);
  }
}

class UserProvider extends ChangeNotifier {
  
  /// User
  static User? _currentUser;
  User? get getCurrentUser => _currentUser;
  
  void setCurrentUser(User newUser){
    _currentUser=newUser;
    notifyListeners();
  }
  
  /// Favourite Products
  List<Product> get getFavouriteProducts => UnmodifiableListView(_currentUser!.getFavouriteProducts);

  void addFavouriteProduct(Product product) {
    _currentUser?.addFavouriteProduct(product);
    notifyListeners();
  }

  void removeFavouriteProduct(Product product) {
    _currentUser?.removeFavouriteProduct(product);
    notifyListeners();
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
  
  List<Product> get getFavouriteProducts => favouriteProducts;
  
  void addFavouriteProduct(Product product) {
    favouriteProducts.add(product);
  }
  
  void removeFavouriteProduct(Product product) {
    favouriteProducts.remove(product);
  }
}
