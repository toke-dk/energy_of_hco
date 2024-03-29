import 'package:energy_of_hco/helpers/app_theme_helper.dart';
import 'package:energy_of_hco/models/cart.dart';
import 'package:energy_of_hco/models/item_categories.dart';
import 'package:energy_of_hco/models/product.dart';
import 'package:energy_of_hco/models/user.dart';
import 'package:energy_of_hco/pages/cart_page.dart';
import 'package:energy_of_hco/widgets/change_int_widget.dart';
import 'package:energy_of_hco/widgets/my_horizontal_listview.dart';
import 'package:energy_of_hco/widgets/show_product_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

class AddItems extends StatefulWidget {
  const AddItems({Key? key, required this.dateToAddOrder}) : super(key: key);
  final DateTime dateToAddOrder;

  @override
  State<AddItems> createState() => _AddItemsState();
}

class _AddItemsState extends State<AddItems> {
  List<CartItem> cart = <CartItem>[];

  List<Product> getAllProducts(context) {
    return Provider.of<ProductsNotifier>(context, listen: false).geAllProducts;
  }

  void addFavouriteProduct(context, Product product) {
    Provider.of<UsersProvider>(context, listen: false)
        .addFavouriteProduct(product);
  }

  void changeCartItemValueByProduct(context, Product product, int newAmount) {
    setState(() {
      cart.firstWhere((element) => element.product == product).amount =
          newAmount;
    });
  }

  void removeFavouriteProduct(context, Product product) {
    Provider.of<UsersProvider>(context, listen: false)
        .removeFavouriteProduct(product);
  }

  List<Product> getFavouriteProducts(context) {
    return Provider.of<UsersProvider>(context, listen: true)
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
        if (cart.isNotEmpty) {
          bool? wantToLeave = await alertLeavingDialog(context);
          if (wantToLeave == true) {
            return true;
          }
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add items"),
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_basket),
                  onPressed: cart.isNotEmpty
                      ? () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CartPage(
                                        cart: cart,
                                        onCartItemsChange:
                                            (List<CartItem> newCartItems) {
                                          setState(() {
                                            cart = newCartItems;
                                          });
                                        },
                                        dateForOrder: widget.dateToAddOrder,
                                      )));
                        }
                      : null,
                ),
                cart.isNotEmpty
                    ? Positioned(
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
                                cart.amountOfProductsInItems.toString(),
                              )),
                        ),
                      )
                        .animate()
                        .scaleXY(end: 1.3, duration: 100.milliseconds)
                        .then(delay: 200.milliseconds)
                        .scaleXY(end: 1 / 1.3, duration: 100.milliseconds)
                    : const SizedBox(),
              ],
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: AnimationConfiguration.toStaggeredList(
                  childAnimationBuilder: (widget) => SlideAnimation(
                      duration: const Duration(milliseconds: 500),
                      horizontalOffset: 50.0,
                      child: widget),
                  children: [
                    Text(
                      "Categories",
                      style: getAppTextTheme(context).headlineSmall,
                    ),
                    MyHorizontalListView(
                      onChange: (newCategory) {
                        setState(() {
                          chosenTopCategory = newCategory;
                        });
                      },
                      chosenItems: [chosenTopCategory],
                      allItems: TopCategories.values,
                      allTitles: TopCategories.values
                          .map((e) => e.displayName)
                          .toList(),
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
                      allTitles:
                          Brands.values.map((e) => e.displayName).toList(),
                    ),
                    Text(
                      chosenTopCategory.displayName,
                      style: getAppTextTheme(context).headlineSmall,
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
                      onProductCartStateChange:
                          (Product product, bool newValue) {
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
                      cartItemsInCart: cart,
                      onItemAmountChange: (Product product, int newAmount) {
                        if (newAmount <= 0) {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: const Text("Delete product?"),
                                    content: const Text(
                                        "Are you sure you want to delete the product from your cart?"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            setState(() {
                                              cart.removeItemByProduct(product);
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Yes")),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("No"))
                                    ],
                                  ));
                        } else {
                          changeCartItemValueByProduct(
                              context, product, newAmount);
                        }
                      },
                    )
                  ],
                )),
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
      required this.cartItemsInCart,
      required this.onItemAmountChange})
      : super(key: key);

  final List<Product> products;
  final Function(Product product, bool value) onFavouriteChange;
  final List<Product> favouriteProducts;
  final Function(Product product, bool newValue) onProductCartStateChange;
  final List<CartItem> cartItemsInCart;
  final Function(Product item, int amount) onItemAmountChange;

  bool _isItemInCart(Product item) {
    return cartItemsInCart.map((e) => e.product).contains(item);
  }

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: GridView.count(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        crossAxisCount: 2,
        children: List.generate(products.length, (index) {
          Product currentIndexProduct = products[index];
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(seconds: 1),
            columnCount: 2,
            child: SlideAnimation(
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ShowProductDetails(
                      onFavouriteChange: (value) =>
                          onFavouriteChange(currentIndexProduct, value),
                      isFavourite:
                          favouriteProducts.contains(currentIndexProduct),
                      subTitle: currentIndexProduct.sizeInCL.toString(),
                      productPrice:
                          currentIndexProduct.priceExclDepositDKK.toString(),
                      optionChild: _isItemInCart(currentIndexProduct)
                          ? Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: ChangeIntTile(
                                      onValueChange: (int value) =>
                                          onItemAmountChange(
                                              currentIndexProduct,
                                              cartItemsInCart
                                                      .getAmountByProduct(
                                                          currentIndexProduct) +
                                                  value),
                                      intAmount:
                                          cartItemsInCart.getAmountByProduct(
                                              currentIndexProduct))
                                  .animate()
                                  .slideX(begin: -0.1)
                                  .fadeIn(),
                            )
                          : RepaintBoundary(
                              child: InkWell(
                                      onTap: () => onProductCartStateChange(
                                          currentIndexProduct,
                                          !_isItemInCart(currentIndexProduct)),
                                      child: Icon(
                                        Icons.add_shopping_cart_outlined,
                                        size: 20,
                                        color:
                                            getAppColorScheme(context).primary,
                                      ))
                                  .animate()
                                  .fade(duration: 600.milliseconds)
                                  .then()
                                  .animate(
                                      onPlay: (controller) =>
                                          controller.repeat())
                                  .shimmer(
                                      delay: 500.milliseconds,
                                      duration: 2.seconds)
                                  .then(duration: 4.seconds),
                            ),
                      title: currentIndexProduct.name,
                      productImage: currentIndexProduct.image,
                      favouriteIcon: true)),
            ),
          );
        }),
      ),
    );
  }
}
