import 'package:energy_of_hco/models/item_categories.dart';
import 'package:flutter/material.dart';

class Product {
  final String name;
  final List<Categories> categories;
  final Image image;
  final double price;

  Product({
    required this.categories,
    required this.name,
    required this.image,
    required this.price,
  });
}
