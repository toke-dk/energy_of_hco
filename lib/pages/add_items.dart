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
  const AddItems({Key? key}) : super(key: key);

  @override
  State<AddItems> createState() => _AddItemsState();
}

class _AddItemsState extends State<AddItems> {
  CartModel cart = CartModel(cartItems: []);

  List<Product> getAllProducts(context) {
    return Provider.of<ProductsNotifier>(context, listen: false).geAllProducts;
  }

  void addFavouriteProduct(context, Product product) {
    Provider.of<UserProvider>(context, listen: false)
        .addFavouriteProduct(product);
  }

  void removeFavouriteProduct(context, Product product) {
    Provider.of<UserProvider>(context, listen: false)
        .removeFavouriteProduct(product);
  }

  List<Product> getFavouriteProducts(context) {
    return Provider.of<UserProvider>(context, listen: true)
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
        topCategoryProductListFiltered = getAllProducts(context);
        break;
      case TopCategories.favourite:
        topCategoryProductListFiltered = getFavouriteProducts(context);
        break;
      case TopCategories.bestSelling:
        topCategoryProductListFiltered = getAllProducts(context)
            .where((e) => e.isBestSelling == true)
            .toList();
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
    return WillPopScope(
      onWillPop: () async {
        bool? wantToLeave = await alertLeavingDialog(context);
        if (wantToLeave == true) {
          return true;
        }
        return false;
      },
      child: Scaffold(
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
                            builder: (context) => CartPage(
                                  cart: cart,
                                  onCartItemsChange:
                                      (CartModel newCartItems) {
                                    setState(() {
                                      cart = newCartItems;
                                    });
                                  },
                                )));
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
                          cart.allProducts.toString(),
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
                  favouriteProducts: getFavouriteProducts(context),
                  onProductCartStateChange: (Product product, bool newValue) {
                    if (newValue) {
                      setState(() {
                        cart.addItem(CartItem(amount: 1, product: product));
                      });
                    } else {
                      setState(() {
                        cart.removeItemByProduct(product);
                      });
                    }
                  },
                  cartItemsInCart: cart.cartItems,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<dynamic> alertLeavingDialog(context) {
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Alert!"),
            content: const Text(
                "You are about to leave. When you first leave your cart you can not get it back. Are you sure you want to leave?"),
            actions: [
              IconButton(
                  onPressed: () => Navigator.pop(context, true),
                  icon: const Text("Yes")),
              IconButton(
                  onPressed: () => Navigator.pop(context, false),
                  icon: const Text("No"))
            ],
          ));
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
