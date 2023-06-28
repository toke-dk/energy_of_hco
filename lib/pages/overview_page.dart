import 'package:energy_of_hco/constants/fees.dart';
import 'package:energy_of_hco/helpers/app_theme_helper.dart';
import 'package:energy_of_hco/models/cart.dart';
import 'package:energy_of_hco/models/item_categories.dart';
import 'package:energy_of_hco/models/order.dart';
import 'package:energy_of_hco/pages/choose_user.dart';
import 'package:energy_of_hco/widgets/change_int_widget.dart';
import 'package:energy_of_hco/widgets/days_scroll.dart';
import 'package:energy_of_hco/widgets/my_horizontal_listview.dart';
import 'package:energy_of_hco/widgets/my_paper.dart';
import 'package:energy_of_hco/widgets/total_orders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OverView extends StatefulWidget {
  const OverView({Key? key}) : super(key: key);

  @override
  State<OverView> createState() => _OverViewState();
}

class _OverViewState extends State<OverView> {
  List<String> items = ["Card-view", "List-view"];
  String currentItem = "Card-view";

  void handleChange(String newString) {
    setState(() {
      currentItem = newString;
    });
  }

  DateTime getDateForOrders() {
    return Provider.of<OrdersProvider>(context).getCurrentDay;
  }

  List<CartItem> getShoppingList() {
    return Provider.of<OrdersProvider>(context, listen: true).getShoppingList;
  }

  List<Order> getOrdersForDay(context) {
    return Provider.of<OrdersProvider>(context).getOrdersForDay;
  }

  void changeCurrentDate(DateTime newDate) {
    return Provider.of<OrdersProvider>(context, listen: false)
        .changeDay(newDate);
  }

  void changeOrderProcess(Order order, OrderProcesses newProcess) {
    Provider.of<OrdersProvider>(context, listen: false)
        .changeOrderProcess(order, newProcess);
  }

  void changeShopListItemPurchase(CartItem item, int newAmount) {
    Provider.of<OrdersProvider>(context, listen: false)
        .changeShopListItemPurchase(item, newAmount);
  }

  @override
  void initState() {
    Provider.of<OrdersProvider>(context, listen: false).ordersProviderInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// maybe take this on:     getShoppingList();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Overview",
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChooseUser(
                      dateChosen: getDateForOrders(),
                    ))),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DaysScroll(
              initialDate: getDateForOrders(),
              onDateChange: (DateTime newDate) => changeCurrentDate(newDate),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: kAppWidthPadding),
                child: Text(
                  "Total orders",
                  style: getAppTextTheme(context).headline5,
                )),
            TotalOrders(
              orders: getOrdersForDay(context),
            ),
            Padding(
              padding: EdgeInsets.all(kAppWidthPadding),
              child: Text(
                "Pending and complete",
                style: getAppTextTheme(context).headline5,
              ),
            ),
            Center(
              child: MyHorizontalListView(
                  chosenItems: [currentItem],
                  onChange: (val) => handleChange(val),
                  allItems: items,
                  allTitles: items),
            ),
            currentItem == "List-view"
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.center,
                    child: _OrdersAsListView(
                      items: getShoppingList(),
                      onItemAmountChange: (CartItem item, int changedAmount) {
                        changeShopListItemPurchase(item, changedAmount);
                      },
                    ))
                : TotalOrders(
                    orders: getOrdersForDay(context),
                  ),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }
}

class _OrdersAsListView extends StatelessWidget {
  const _OrdersAsListView(
      {Key? key, required this.items, required this.onItemAmountChange})
      : super(key: key);

  final List<CartItem> items;

  final Function(CartItem item, int changedAmount) onItemAmountChange;

  @override
  Widget build(BuildContext context) {
    return MyPaper(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Pending",
            style: getAppTextTheme(context).headline6,
          ),
          Column(
              children: List.generate(items.length, (index) {
            CartItem currentIndexItem = items[index];
            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: _MyListItem(
                item: currentIndexItem,
                onPurchasedAmountChange: (int newAmount) =>
                    onItemAmountChange(currentIndexItem, newAmount),
              ),
            );
          })),
          const SizedBox(
            height: 8,
          ),
          Text(
            "Price",
            style: getAppTextTheme(context).headline6,
          ),
          const SizedBox(
            height: 8,
          ),
          /// TODO this does not take fees into account
          /// I should give a total cost for the [Order] method
          Center(
            child: Text(items.productsPrice.toString()),
          )
        ],
      ),
    );
  }
}

class _MyListItem extends StatelessWidget {
  const _MyListItem(
      {Key? key, required this.item, required this.onPurchasedAmountChange})
      : super(key: key);
  final CartItem item;
  final Function(int newAmount) onPurchasedAmountChange;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: item.product.image,
          ),
        ),
        Expanded(
          flex: 7,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: EdgeInsets.only(right: 5),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.product.name,
                      ),
                      Text(
                        "${item.product.brand.displayName}, ${item.product.sizeInCL}cL",
                        style: getAppTextTheme(context).caption,
                      )
                    ],
                  ),
                  Text(
                    " (${item.amount.toString()})",
                    style: getAppTextTheme(context).subtitle1,
                  )
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: ChangeIntTile(
            onValueChange: (changeInt) => onPurchasedAmountChange(changeInt),
            intAmount: item.amountPurchased ?? 0,
            maxVal: item.amount,
            minVal: 0,
          ),
        )
      ],
    );
  }
}
