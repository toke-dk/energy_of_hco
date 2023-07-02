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

  List<ShopListItem> getShoppingList() {
    return Provider.of<OrdersProvider>(context, listen: true).getShoppingList;
  }

  List<Order> getPendingOrdersForDay(context) {
    return Provider.of<OrdersProvider>(context).getPendingOrdersForDay;
  }

  List<Order> getBroughtOrdersForDay(context) {
    return Provider.of<OrdersProvider>(context).getBroughtOrders;
  }

  void changeCurrentDate(DateTime newDate) {
    return Provider.of<OrdersProvider>(context, listen: false)
        .changeDay(newDate);
  }

  void changeShopListItemPurchase(ShopListItem item, int newAmount) {
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
                  "Pending Orders",
                  style: getAppTextTheme(context).headlineSmall,
                )),
            TotalOrders(
              orders: getPendingOrdersForDay(context),
            ),
            Padding(
              padding: EdgeInsets.all(kAppWidthPadding),
              child: Text(
                "Brought",
                style: getAppTextTheme(context).headlineSmall,
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
                      onItemAmountChange:
                          (ShopListItem item, int changedAmount) {
                        changeShopListItemPurchase(item, changedAmount);
                      },
                    ))
                : TotalOrders(
                    orders: getBroughtOrdersForDay(context),
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

  final List<ShopListItem> items;

  final Function(ShopListItem item, int changedAmount) onItemAmountChange;

  @override
  Widget build(BuildContext context) {
    return MyPaper(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Pending",
            style: getAppTextTheme(context).bodyLarge,
          ),
          Column(
              children: List.generate(items.length, (index) {
            ShopListItem currentIndexItem = items[index];
            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: _MyListItem(
                shopList: currentIndexItem,
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
            style: getAppTextTheme(context).bodyLarge,
          ),
          const SizedBox(
            height: 8,
          ),

          /// TODO this does not take fees into account
          /// I should give a total cost for the [Order] method
          Center(
            child: Text(
                items.map((e) => e.item).toList().productsPrice.toString()),
          )
        ],
      ),
    );
  }
}

class _MyListItem extends StatelessWidget {
  const _MyListItem(
      {Key? key, required this.shopList, required this.onPurchasedAmountChange})
      : super(key: key);
  final ShopListItem shopList;
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
            child: shopList.item.product.image,
          ),
        ),
        Expanded(
          flex: 7,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shopList.item.product.name,
                      ),
                      Text(
                        "${shopList.item.product.brand.displayName}, ${shopList.item.product.sizeInCL}cL",
                        style: getAppTextTheme(context).bodySmall,
                      )
                    ],
                  ),
                  Text(
                    " (${shopList.item.amount.toString()})",
                    style: getAppTextTheme(context).bodySmall,
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
            intAmount: shopList.amountBrought,
            maxVal: shopList.item.amount,
            minVal: 0,
          ),
        )
      ],
    );
  }
}
