import 'dart:async';

import 'package:animated_check/animated_check.dart';
import 'package:energy_of_hco/constants/fees.dart';
import 'package:energy_of_hco/helpers/app_theme_helper.dart';
import 'package:energy_of_hco/helpers/math.dart';
import 'package:energy_of_hco/models/cart.dart';
import 'package:energy_of_hco/models/order.dart';
import 'package:energy_of_hco/models/user.dart';
import 'package:energy_of_hco/widgets/change_int_widget.dart';
import 'package:energy_of_hco/widgets/my_paper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage(
      {Key? key,
      required this.cart,
      required this.onCartItemsChange,
      required this.dateForOrder})
      : super(key: key);
  final List<CartItem> cart;
  final DateTime dateForOrder;

  // tells the parent to change
  final ValueChanged<List<CartItem>> onCartItemsChange;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void dispose() {
    super.dispose();
  }

  void editItemAmount(context, CartItem item, int amount) {
    widget.cart.changeItemAmount(item, amount);
    widget.onCartItemsChange(widget.cart);
  }

  void removeCartItem(context, CartItem item) {
    widget.cart.removeItem(item);
    widget.onCartItemsChange(widget.cart);
  }

  double fees(context) {
    return kServiceFees;
  }

  double subtotalPrice(context) {
    return widget.cart.productsPrice;
  }

  double totalPrice(context) {
    return myDoubleCorrector(fees(context) + subtotalPrice(context));
  }

  void handleItemDeletion(context, item) {
    _deletionAlertDialog(context, handleRemove: () {
      setState(() {
        removeCartItem(context, item);
      });
      Navigator.pop(context);
    });
  }

  void placeOrder(context, Order order) {
    Provider.of<OrdersProvider>(context, listen: false)
        .addOrderForCurDay(order);
  }

  User getCurrentUser(context) =>
      Provider.of<UsersProvider>(context, listen: false).getCurrentUser!;

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
                child: widget.cart.isNotEmpty
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
                                "${widget.cart.length} item${widget.cart.length > 1 ? 's' : ''}",
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
                                      widget.cart[index];
                                  return ShowCartItem(
                                    cartItem: currentIndexItem,
                                    onItemAmountChange: (int changeAmount) {
                                      setState(() {
                                        editItemAmount(context,
                                            currentIndexItem, changeAmount);
                                      });
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
                                itemCount: widget.cart.length),
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
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) =>
                            _PlaceOrderDialog(actionOnComplete: () {
                              placeOrder(
                                  context,
                                  Order(
                                      totalPrice: totalPrice(context),
                                      user: getCurrentUser(context),
                                      cart: widget.cart,
                                      date: widget.dateForOrder,
                                      orderProcess: OrderProcesses.pendingOrder));
                              return Navigator.popUntil(
                                  context, (route) => route.isFirst);
                            }));
                  },
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
                            topLeft: Radius.circular(17),
                            topRight: Radius.circular(17)),
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

class _PlaceOrderDialog extends StatefulWidget {
  const _PlaceOrderDialog({Key? key, required this.actionOnComplete})
      : super(key: key);
  final Function() actionOnComplete;

  @override
  _PlaceOrderDialogState createState() => _PlaceOrderDialogState();
}

class _PlaceOrderDialogState extends State<_PlaceOrderDialog>
    with TickerProviderStateMixin {
  bool _loading = true;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    /// todo make this add to the database and then quit
    Timer(const Duration(seconds: 1), () {
      setState(() {
        _loading = false;
        _animationController.forward();
        Timer(const Duration(milliseconds: 1500), () {
          widget.actionOnComplete();
        });
      });
    });

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeInOutCirc));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _loading ? 'Placing order...' : "ORDER CONFIRMED!",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _loading
                ? const CircularProgressIndicator()
                : AnimatedCheck(progress: _animation, size: 60),
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
                    "${cartItem.product.priceExclDepositDKK.toString()} kr.",
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
                ChangeIntTile(
                    onValueChange: (int changeVal) =>
                        cartItem.amount + changeVal <= 0
                            ? handleCartItemRemove()
                            : onItemAmountChange(changeVal),
                    intAmount: cartItem.amount)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
