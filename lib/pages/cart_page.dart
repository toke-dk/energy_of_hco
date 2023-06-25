import 'package:energy_of_hco/helpers/app_theme_helper.dart';
import 'package:energy_of_hco/models/cart.dart';
import 'package:energy_of_hco/widgets/my_paper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  void editItemAmount(context, CartItem item, int amount) {
    return Provider.of<CartProvider>(context, listen: false)
        .editItemAmount(item, amount);
  }

  void removeCartItem(context, CartItem item) {
    return Provider.of<CartProvider>(context, listen: false)
        .removeCartItem(item);
  }

  List<CartItem> getAllItems(context) {
    return Provider.of<CartProvider>(context, listen: true).getItems;
  }

  int getItemsLength(context) {
    return Provider.of<CartProvider>(context, listen: true).itemsLength;
  }

  double fees(context) {
    return Provider.of<CartProvider>(context, listen: true).serviceFeesInDkk;
  }

  double subtotalPrice(context) {
    return Provider.of<CartProvider>(context, listen: true).getTotalItemsCost!;
  }

  double totalPrice(context) {
    return fees(context) + subtotalPrice(context);
  }

  void handleItemDeletion(context, item) {
    _deletionAlertDialog(context, handleRemove: () {
      removeCartItem(context, item);
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
      ),
      body: SizedBox(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 20, bottom: 65),
                child: getAllItems(context).isNotEmpty
                    ? Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Items",
                                style: getAppTextTheme(context).headline5,
                              ),
                              Text(
                                "${getItemsLength(context).toString()} item${getItemsLength(context) > 1 ? 's' : ''}",
                                style: getAppTextTheme(context).subtitle1,
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          MyPaper(
                            child: ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  CartItem currentIndexItem =
                                      getAllItems(context)[index];
                                  return ShowCartItem(
                                    cartItem: currentIndexItem,
                                    onItemAmountChange: (int changeAmount) {
                                      editItemAmount(context, currentIndexItem,
                                          changeAmount);
                                    },
                                    handleCartItemRemove: () =>
                                        handleItemDeletion(
                                            context, currentIndexItem),
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 30),
                                      child: Divider(),
                                    ),
                                itemCount: getAllItems(context).length),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Row(
                                children: const [
                                  Icon(Icons.add),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text("Add more"),
                                ],
                              ),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      getAppColorScheme(context).onPrimary),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)))),
                            ),
                          ),
                          const Divider(
                            height: 15,
                            thickness: 1,
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: ShowOrderPrices(
                                rowsAndColumns: [
                                  [
                                    "Subtotal",
                                    subtotalPrice(context).toString() + " kr."
                                  ],
                                  [
                                    "Service fee",
                                    fees(context).toString() + " kr."
                                  ],
                                  [
                                    "Total",
                                    totalPrice(context).toString() + " kr."
                                  ]
                                ],
                              )),
                        ],
                      )
                    : const SizedBox(),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 60,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Icon(Icons.local_fire_department),
                      Text(
                        "Place order!",
                        style: TextStyle(fontSize: 24),
                      ),
                      Icon(Icons.local_fire_department)
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: getAppColorScheme(context).primary,
                      onPrimary: getAppColorScheme(context).onPrimary,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(17),
                            topRight: const Radius.circular(17)),
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<dynamic> _deletionAlertDialog(context,
        {required Function() handleRemove}) =>
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Heads up!"),
              content: const Text(
                  "You are about to remove this item. Are you sure you want to remove it?"),
              actions: [
                TextButton(
                  onPressed: () => handleRemove(),
                  child: const Text("Yes"),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("No"))
              ],
            ));

class ShowOrderPrices extends StatelessWidget {
  const ShowOrderPrices({Key? key, required this.rowsAndColumns})
      : super(key: key);

  final List<List<String>> rowsAndColumns;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
          rowsAndColumns.length,
          (columnIndex) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                    2,
                    (rowIndex) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Text(
                            rowsAndColumns[columnIndex][rowIndex],
                            style: TextStyle(
                                fontWeight:
                                    columnIndex == rowsAndColumns.length - 1
                                        ? FontWeight.bold
                                        : null),
                          ),
                        )),
              )),
    );
  }
}

class ShowCartItem extends StatelessWidget {
  const ShowCartItem(
      {Key? key,
      required this.cartItem,
      required this.onItemAmountChange,
      required this.handleCartItemRemove})
      : super(key: key);

  final CartItem cartItem;
  final Function() handleCartItemRemove;
  final Function(int changeAmount) onItemAmountChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      width: double.infinity,
      height: 110,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AspectRatio(aspectRatio: 1, child: cartItem.product.image),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    cartItem.product.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: getAppTextTheme(context)
                        .headline6!
                        .copyWith(fontSize: 16),
                  ),
                  Text(
                    "${cartItem.product.priceInDKK.toString()} kr.",
                  )
                ],
              ),
            ),
          ),
          AspectRatio(
            aspectRatio: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  child: const Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 16,
                  ),
                  onTap: () => handleCartItemRemove(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _MyRoundedButton(
                      icon: Icons.add,
                      onTap: () => onItemAmountChange(1),
                    ),
                    Text(cartItem.amount.toString()),
                    _MyRoundedButton(
                      icon: Icons.remove,
                      onTap: () => cartItem.amount - 1 <= 0
                          ? handleCartItemRemove()
                          : onItemAmountChange(-1),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MyRoundedButton extends StatelessWidget {
  const _MyRoundedButton({Key? key, required this.icon, required this.onTap})
      : super(key: key);

  final IconData icon;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: getAppColorScheme(context).primary),
        child: InkWell(
          onTap: onTap,
          child: Icon(
            icon,
            color: getAppColorScheme(context).onPrimary,
            size: 20,
          ),
        ));
  }
}
