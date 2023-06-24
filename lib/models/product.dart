import 'dart:collection';

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

class ProductsNotifier extends ChangeNotifier {
  final List<Product> _allProducts =
  [
    Product(
        name: "Monster top rank",
        image: Image.network(
            "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg"),
        priceInDKK: 12.5,
        brand: Brands.monster,
        sizeInCL: 25),
    Product(
        name: "Bold super duper ultra omega",
        image: Image.network(
            "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg"),
        priceInDKK: 12.5,
        brand: Brands.bold,
        sizeInCL: 26),
    Product(
        brand: Brands.bold,
        name: "Bold Iced Espresso",
        image: Image.network(
            "https://shop14539.sfstatic.io/upload_dir/shop/_thumbs/Bold_Iced_Espresso.w610.h610.fill.png"),
        priceInDKK: 19.9,
        sizeInCL: 25),
    Product(
        brand: Brands.monster,
        name: "Monster Energy",
        image: Image.network(
            "https://www.pngplay.com/wp-content/uploads/9/Monster-Energy-Transparent-PNG.png"),
        priceInDKK: 12.5,
        sizeInCL: 25),
    Product(
        brand: Brands.monster,
        name: "Monster Energy Ireland",
        image: Image.network(
            "https://cdn.shopify.com/s/files/1/0080/7282/2839/products/ultraparadise.png?v=1664660445"),
        priceInDKK: 18.2,
        sizeInCL: 25),
  ];

  List<Product> get geAllProducts => UnmodifiableListView(_allProducts);
}