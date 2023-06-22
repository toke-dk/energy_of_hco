import 'package:energy_of_hco/helpers/app_theme_helper.dart';
import 'package:energy_of_hco/models/item_categories.dart';
import 'package:energy_of_hco/models/product.dart';
import 'package:energy_of_hco/models/user.dart';
import 'package:energy_of_hco/widgets/my_paper.dart';
import 'package:energy_of_hco/widgets/total_orders.dart';
import 'package:flutter/material.dart';

class AddItems extends StatefulWidget {
  const AddItems({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<AddItems> createState() => _AddItemsState();
}

class _AddItemsState extends State<AddItems> {
  final Categories chosenCategory = Categories.bestSelling;

  final List<Product> allProducts = [
    Product(
        categories: [Categories.bold, Categories.favourites],
        name: "Bold Iced Espresso",
        image: Image.network(
            "https://shop14539.sfstatic.io/upload_dir/shop/_thumbs/Bold_Iced_Espresso.w610.h610.fill.png"),
        priceInDKK: 19.9,
        sizeInCL: 25),
    Product(
        categories: [Categories.monster, Categories.bestSelling],
        name: "Monster Energy",
        image: Image.network(
            "https://www.pngplay.com/wp-content/uploads/9/Monster-Energy-Transparent-PNG.png"),
        priceInDKK: 12.5,
        sizeInCL: 25),
    Product(
        categories: [Categories.monster, Categories.bestSelling],
        name: "Monster Energy Ireland",
        image: Image.network(
            "https://cdn.shopify.com/s/files/1/0080/7282/2839/products/ultraparadise.png?v=1664660445"),
        priceInDKK: 18.2,
        sizeInCL: 25),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add items"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_basket),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Categories",
                style: getAppTextTheme(context).headline5,
              ),
              Placeholder(),
              Text(
                chosenCategory.displayName,
                style: getAppTextTheme(context).headline5,
              ),
              ProductsGridView(products: allProducts)
            ],
          ),
        ),
      ),
    );
  }
}

class ProductsGridView extends StatelessWidget {
  const ProductsGridView({Key? key, required this.products}) : super(key: key);

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      crossAxisCount: 2,
      children: List.generate(
          products.length,
          (index) => Padding(
              padding: EdgeInsets.all(10),
              child: ShowProductDetails(
                  subTitle: products[index].sizeInCL.toString(),
                  productPrice: products[index].priceInDKK.toString(),
                  optionIcon: Icons.add_shopping_cart_outlined,
                  title: products[index].name,
                  productImage: products[index].image,
                  favouriteIcon: true))),
    );
  }
}
