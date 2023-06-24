import 'package:energy_of_hco/helpers/app_theme_helper.dart';
import 'package:energy_of_hco/models/item_categories.dart';
import 'package:energy_of_hco/models/product.dart';
import 'package:energy_of_hco/models/user.dart';
import 'package:energy_of_hco/widgets/my_paper.dart';
import 'package:energy_of_hco/widgets/showProductDetail.dart';
import 'package:energy_of_hco/widgets/total_orders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddItems extends StatefulWidget {
  const AddItems({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  State<AddItems> createState() => _AddItemsState();
}

class _AddItemsState extends State<AddItems> {
  TopCategories chosenTopCategory = TopCategories.all;

  List<Brands> _onBrandsClickChange(Brands clickedBrand) {
    List<Brands> newChosenBrands = chosenBrands;
    newChosenBrands.contains(clickedBrand)
        ? newChosenBrands.remove(clickedBrand)
        : newChosenBrands.add(clickedBrand);
    return newChosenBrands;
  }

  List<Product> _getProductsToShow(TopCategories topCategoryChosen,
      List<Brands> brandsChosen, BuildContext context) {
    List<Product> topCategoryProductListFiltered;
    switch (topCategoryChosen) {
      case TopCategories.all:
        topCategoryProductListFiltered = allProducts;
        break;
      case TopCategories.favourite:
        topCategoryProductListFiltered =
            Provider.of<FavouriteProductsNotifier>(context)
                .getFavouriteProducts;
        break;
      case TopCategories.bestSelling:
        topCategoryProductListFiltered =
            allProducts.where((e) => e.isBestSelling == true).toList();
        break;
    }
    if (brandsChosen.isEmpty) return topCategoryProductListFiltered;
    return topCategoryProductListFiltered
        .where((product) => brandsChosen.contains(product.brand))
        .toList();
  }

  List<Brands> chosenBrands = [];

  final List<Product> allProducts = [
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

  @override
  Widget build(BuildContext context) {
    List<Product> favouriteItems =
        Provider.of<FavouriteProductsNotifier>(context).getFavouriteProducts;

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
                style: getAppTextTheme(context).headline6,
              ),
              MyHorizontalListView(
                onChange: (newCategory) {
                  setState(() {
                    chosenTopCategory = newCategory;
                  });
                },
                chosenItems: [chosenTopCategory],
                allItems: TopCategories.values,
                allTitles:
                    TopCategories.values.map((e) => e.displayName).toList(),
                scaleFactor: 1.2,
              ),
              MyHorizontalListView(
                onChange: (newBrand) {
                  setState(() {
                    chosenBrands = _onBrandsClickChange(newBrand);
                  });
                },
                showCheckMark: true,
                chosenItems: chosenBrands,
                allItems: Brands.values,
                allTitles: Brands.values.map((e) => e.displayName).toList(),
              ),
              Text(
                chosenTopCategory.displayName,
                style: getAppTextTheme(context).headline5,
              ),
              _ProductsGridView(
                products: _getProductsToShow(chosenTopCategory, chosenBrands, context),
                onFavouriteChange: (Product product, bool value) {
                  if (!value) {
                    setState(() {
                      Provider.of<FavouriteProductsNotifier>(context,
                              listen: false)
                          .addFavouriteProduct(product);
                    });
                  } else {
                    setState(() {
                      Provider.of<FavouriteProductsNotifier>(context,
                              listen: false)
                          .removeFavouriteProduct(product);
                    });
                  }
                },
                favouriteProducts: favouriteItems,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MyHorizontalListView extends StatelessWidget {
  const MyHorizontalListView(
      {Key? key,
      required this.chosenItems,
      required this.onChange,
      required this.allItems,
      required this.allTitles,
      this.scaleFactor,
      this.showCheckMark})
      : super(key: key);
  final List<dynamic> chosenItems;
  final List<dynamic> allItems;
  final Function(dynamic) onChange;
  final List<String> allTitles;
  final double? scaleFactor;
  final bool? showCheckMark;

  List<Color> _getButtonColors(dynamic currentIndexCategories, context) {
    // the first item is the background
    // the second is the textcolor
    if (chosenItems.contains(currentIndexCategories)) {
      return [
        getAppColorScheme(context).primary,
        getAppColorScheme(context).onPrimary
      ];
    }
    return [
      getAppColorScheme(context).onPrimary,
      getAppTextTheme(context).bodyText2!.color!
    ];
  }

  Icon getIconFromCheckState(bool isChecked, Color color) {
    return isChecked
        ? Icon(
            Icons.check_circle,
            color: color,
          )
        : Icon(
            Icons.check_circle_outline,
            color: color,
          );
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      alignment: Alignment.centerLeft,
      scale: scaleFactor ?? 1,
      child: SizedBox(
        height: 50,
        child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              dynamic currentIndexItem = allItems[index];
              return GestureDetector(
                onTap: () => onChange(currentIndexItem),
                child: Container(
                  padding: EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17),
                    color: _getButtonColors(currentIndexItem, context)[0],
                  ),
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Row(
                      children: [
                        showCheckMark == true
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: getIconFromCheckState(
                                    chosenItems.contains(currentIndexItem),
                                    _getButtonColors(
                                        currentIndexItem, context)[1]),
                              )
                            : SizedBox(),
                        Text(
                          allTitles[index],
                          style: TextStyle(
                              color: _getButtonColors(
                                  currentIndexItem, context)[1]),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => SizedBox(
                  width: 8,
                ),
            itemCount: allItems.length),
      ),
    );
  }
}

class _ProductsGridView extends StatelessWidget {
  const _ProductsGridView(
      {Key? key,
      required this.products,
      required this.onFavouriteChange,
      required this.favouriteProducts})
      : super(key: key);

  final List<Product> products;
  final Function(Product product, bool value) onFavouriteChange;
  final List<Product> favouriteProducts;

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
                  onFavouriteChange: (value) =>
                      onFavouriteChange(products[index], value),
                  isFavourite: favouriteProducts.contains(products[index]),
                  subTitle: products[index].sizeInCL.toString(),
                  productPrice: products[index].priceInDKK.toString(),
                  optionIcon: Icons.add_shopping_cart_outlined,
                  title: products[index].name,
                  productImage: products[index].image,
                  favouriteIcon: true))),
    );
  }
}
