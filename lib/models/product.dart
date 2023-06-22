import 'package:flutter/material.dart';

class Product {
  final String name;
  final Brands brand;
  final Image image;
  final double price;

  Product({
    required this.brand,
    required this.name,
    required this.image,
    required this.price,
  });
}

enum Brands {monster, bold, cult, faxeKondi, redBull}
