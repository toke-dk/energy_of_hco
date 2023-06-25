import 'package:energy_of_hco/helpers/app_theme_helper.dart';
import 'package:energy_of_hco/models/cart.dart';
import 'package:energy_of_hco/models/item_categories.dart';
import 'package:energy_of_hco/models/product.dart';
import 'package:energy_of_hco/models/user.dart';
import 'package:energy_of_hco/pages/cart_page.dart';
import 'package:energy_of_hco/widgets/my_horizontal_listview.dart';
import 'package:energy_of_hco/widgets/show_product_detail.dart';
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

  @override
  void initState() {
    allProducts =
        Provider.of<ProductsNotifier>(context, listen: false).geAllProducts;
    super.initState();
  }

  List<CartItem> getCartItemsAddedToCart(context, {required bool listen}) {
    return Provider.of<CartProvider>(context, listen: listen).getItems;
  }

  int getCartLength(context) {
    return Provider.of<CartProvider>(context, listen: true).length;
  }

  void addItemToCart(context, CartItem item) {
    Provider.of<CartProvider>(context, listen: false).addItem(item);
  }

  void removeFromCartByProduct(context, Product product) {
    Provider.of<CartProvider>(context, listen: false)
        .removeItemByProduct(product);
  }

  void addFavouriteProduct(context, Product product) {
    Provider.of<FavouriteProductsProvider>(context, listen: false)
        .addFavouriteProduct(product);
  }

  void removeFavouriteProduct(context, Product product) {
    Provider.of<FavouriteProductsProvider>(context, listen: false)
        .removeFavouriteProduct(product);
  }

  List<Product> getFavouriteProducts(context, bool listen) {
    return Provider.of<FavouriteProductsProvider>(context, listen: listen)
        .getFavouriteProducts;
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
            Provider.of<FavouriteProductsProvider>(context, listen: true)
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
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CartPage()));
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  constraints: const BoxConstraints(
                    maxHeight: 15,
                    maxWidth: 15,
                    minHeight: 15,
                    minWidth: 15,
                  ),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.red),
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
                    addFavouriteProduct(context, product);
                  } else {
                    removeFavouriteProduct(context, product);
                  }
                },

                ///TODO get this mess to look a bit nicer
                favouriteProducts: getFavouriteProducts(context, true),
                onProductCartStateChange: (Product product, bool newValue) {
                  if (newValue) {
                    addItemToCart(
                        context, CartItem(amount: 1, product: product));
                  } else {
                    removeFromCartByProduct(context, product);
                  }
                },
                cartItemsInCart: getCartItemsAddedToCart(context, listen: true),
              )
            ],
          ),
        ),
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
      required this.onProductCartStateChange,
      required this.cartItemsInCart})
      : super(key: key);

  final List<Product> products;
  final Function(Product product, bool value) onFavouriteChange;
  final List<Product> favouriteProducts;
  final Function(Product product, bool newValue) onProductCartStateChange;
  final List<CartItem> cartItemsInCart;

  bool _isItemInCart(Product item) {
    return cartItemsInCart.map((e) => e.product).contains(item);
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      crossAxisCount: 2,
      children: List.generate(products.length, (index) {
        Product currentIndexProduct = products[index];
        return Padding(
            padding: const EdgeInsets.all(10),
            child: ShowProductDetails(
                onOptionIconTap: () => onProductCartStateChange(
                    currentIndexProduct, !_isItemInCart(currentIndexProduct)),
                onFavouriteChange: (value) =>
                    onFavouriteChange(currentIndexProduct, value),
                isFavourite: favouriteProducts.contains(currentIndexProduct),
                subTitle: currentIndexProduct.sizeInCL.toString(),
                productPrice: currentIndexProduct.priceInDKK.toString(),
                optionIcon: _isItemInCart(currentIndexProduct)
                    ? Icons.check
                    : Icons.add_shopping_cart_outlined,
                title: currentIndexProduct.name,
                productImage: currentIndexProduct.image,
                favouriteIcon: true));
      }),
    );
  }
}
