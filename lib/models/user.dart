import 'package:energy_of_hco/models/product.dart';

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
