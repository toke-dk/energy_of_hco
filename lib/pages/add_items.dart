import 'package:energy_of_hco/helpers/app_theme_helper.dart';
import 'package:energy_of_hco/models/cart.dart';
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
  late List<Product> allProducts;
  late List<Product> favouriteProducts;

  @override
  void initState() {
    allProducts =
        Provider.of<ProductsNotifier>(context, listen: false).geAllProducts;
    favouriteProducts =
        Provider.of<FavouriteProductsNotifier>(context, listen: false)
            .getFavouriteProducts;
    super.initState();
  }

  List<CartItem> getCartItemsAddedToCart(context) {
    return Provider.of<CartProvider>(context, listen: true).getItems;
  }

  int getCartLength(context) {
    return Provider.of<CartProvider>(context, listen: true).length;
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add items"),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_basket),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: 15,
                    maxWidth: 15,
                    minHeight: 15,
                    minWidth: 15,
                  ),
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                  child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        getCartLength(context).toString(),
                      )),
                ),
              ),
            ],
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
                products: _getProductsToShow(
                    chosenTopCategory, chosenBrands, context),
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

                ///TODO get this mess to look a bit nicer
                favouriteProducts: favouriteProducts,
                onAddToCart: (Product product) {
                  if (!Provider.of<CartProvider>(context, listen: false)
                      .getItems
                      .map((e) => e.product)
                      .contains(product)) {
                    setState(() {
                      Provider.of<CartProvider>(context, listen: false)
                          .addItem(CartItem(amount: 1, product: product));
                    });
                  }
                },
                cartItemsAddedToCart: getCartItemsAddedToCart(context),
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
      required this.favouriteProducts,
      required this.onAddToCart,
      required this.cartItemsAddedToCart})
      : super(key: key);

  final List<Product> products;
  final Function(Product product, bool value) onFavouriteChange;
  final List<Product> favouriteProducts;
  final Function(Product) onAddToCart;
  final List<CartItem> cartItemsAddedToCart;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      crossAxisCount: 2,
      children: List.generate(products.length, (index) {
        Product currentIndexProduct = products[index];
        return Padding(
            padding: EdgeInsets.all(10),
            child: ShowProductDetails(
                onOptionIconTap: () => onAddToCart(currentIndexProduct),
                onFavouriteChange: (value) =>
                    onFavouriteChange(currentIndexProduct, value),
                isFavourite: favouriteProducts.contains(currentIndexProduct),
                subTitle: currentIndexProduct.sizeInCL.toString(),
                productPrice: currentIndexProduct.priceInDKK.toString(),
                optionIcon: cartItemsAddedToCart
                        .map((items) => items.product)
                        .contains(currentIndexProduct)
                    ? Icons.check
                    : Icons.add_shopping_cart_outlined,
                title: currentIndexProduct.name,
                productImage: currentIndexProduct.image,
                favouriteIcon: true));
      }),
    );
  }
}
