import 'dart:collection';

import 'package:energy_of_hco/models/item_categories.dart';
import 'package:flutter/material.dart';

class Product {
  final String name;
  final Brands brand;
  final Image image;
  final double priceExclDepositDKK;
  final double depositDKK;
  final double sizeInCL;
  final bool? isBestSelling;

  Product({
    this.isBestSelling,
    required this.sizeInCL,
    required this.depositDKK,
    required this.brand,
    required this.name,
    required this.image,
    required this.priceExclDepositDKK,
  });
}

class ProductsNotifier {
  final List<Product> _allProducts = [
    Product(
        name: "Monster Energy",
        image: Image.network(
            "https://imageproxy.wolt.com/menu/menu-images/646214ac66710ed18620d748/20914326-013f-11ee-82fc-3af572684bbc_5060337502900.jpg?w=600"),
        priceExclDepositDKK: 17.95,
        brand: Brands.monster,
        sizeInCL: 50,
        depositDKK: 1.00),
    Product(
        name: "Monster Absolutely Zero",
        image: Image.network(
            "https://imageproxy.wolt.com/menu/menu-images/646214ac66710ed18620d748/20a9dcd8-013f-11ee-bfb5-aa917d15911e_5060337503099.jpg?w=600"),
        priceExclDepositDKK: 17.95,
        brand: Brands.monster,
        sizeInCL: 50,
        depositDKK: 1),
    Product(
        brand: Brands.cult,
        name: "Cult Energy",
        image: Image.network(
            "https://imageproxy.wolt.com/menu/menu-images/61f7a1ce409057c754f24fef/bef4e3ac-84da-11ec-b79c-b675424eac31_5710176001835_p.jpeg?w=600"),
        priceExclDepositDKK: 16.95,
        sizeInCL: 50,
        depositDKK: 1.00),
    Product(
        brand: Brands.monster,
        name: "Monster Khaotic",
        image: Image.network(
            "https://imageproxy.wolt.com/menu/menu-images/633d976e530e0ee4487ca261/d6321708-4fcb-11ed-b8b9-cafd35cdd37a_5060896624945.jpeg?w=600"),
        priceExclDepositDKK: 17.95,
        sizeInCL: 25,
        depositDKK: 1.00),
    Product(
        brand: Brands.redBull,
        name: "Redbull",
        image: Image.network(
            "https://imageproxy.wolt.com/menu/menu-images/633d976e530e0ee4487ca261/80a2219c-4fcc-11ed-b7d6-6af60db30491_9002490216023.jpeg?w=600"),
        priceExclDepositDKK: 14.95,
        sizeInCL: 25,
        depositDKK: 1.00),
    Product(
        sizeInCL: 25,
        brand: Brands.bold,
        name: "Iced Espresso, Bold",
        image: Image.network(
            "https://imageproxy.wolt.com/menu/menu-images/633d976e530e0ee4487ca261/f96c40c2-4fcb-11ed-a8d8-c2f696e31a58_5700002140012.jpeg?w=600"),
        priceExclDepositDKK: 19.95,
        depositDKK: 1.00),
    Product(
        sizeInCL: 50,
        brand: Brands.faxeKondi,
        name: "Faxe Kondi Booster",
        image: Image.network(
            "https://imageproxy.wolt.com/menu/menu-images/616832c6f080a3bd5e00e221/06d9834a-4614-11ec-a0ee-ca06028445b2_05741000134894_c1n1__1_.jpeg?w=600"),
        priceExclDepositDKK: 17.95,
        depositDKK: 1.00),
    Product(
        sizeInCL: 50,
        brand: Brands.faxeKondi,
        name: "Faxe Kondi Booster Free",
        image: Image.network(
            "https://imageproxy.wolt.com/menu/menu-images/616832c6f080a3bd5e00e221/0d90feca-4614-11ec-b750-469daf7925aa_05741000142899_c1n1__1_.jpeg?w=600"),
        priceExclDepositDKK: 17.95,
        depositDKK: 1.00),
    Product(
        sizeInCL: 500,
        brand: Brands.faxeKondi,
        name: "Faxe Kondi Booster Twisted Ice",
        image: Image.network(
            "https://imageproxy.wolt.com/menu/menu-images/633d976e530e0ee4487ca261/02103888-4fcb-11ed-a526-7e2523385900_5741000220184.jpeg?w=600"),
        priceExclDepositDKK: 17.95,
        depositDKK: 1.00),
    Product(
        sizeInCL: 50,
        depositDKK: 1,
        brand: Brands.rock,
        name: "Star Energy No Sugar, Rock",
        image: Image.network(
            "https://imageproxy.wolt.com/menu/menu-images/633d976e530e0ee4487ca261/03c601b2-4fcb-11ed-98cb-820935229e22_5741000221617.jpeg?w=600"),
        priceExclDepositDKK: 19.95),
    Product(
        sizeInCL: 50,
        depositDKK: 1,
        brand: Brands.rock,
        name: "Rock star Energy Original",
        image: Image.network(
            "https://imageproxy.wolt.com/menu/menu-images/63285a55106b68a63b1f93ca/4ecb567e-40c3-11ed-84b8-4ec7a45830c0_5741000221600.jpeg?w=600"),
        priceExclDepositDKK: 15.95),
  ];

  List<Product> get geAllProducts => UnmodifiableListView(_allProducts);
}
