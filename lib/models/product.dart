import 'package:energy_of_hco/models/item_categories.dart';
import 'package:flutter/material.dart';

class Product {
  final String name;
  final Brands brand;
  final Image image;
  final double priceInDKK;
  final double sizeInCL;
  final bool? isBestSelling;

  Product({
    this.isBestSelling,
    required this.sizeInCL,
    required this.brand,
    required this.name,
    required this.image,
    required this.priceInDKK,
  });
}
