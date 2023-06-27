import 'package:energy_of_hco/constants/fees.dart';
import 'package:energy_of_hco/helpers/app_theme_helper.dart';
import 'package:energy_of_hco/models/cart.dart';
import 'package:energy_of_hco/models/order.dart';
import 'package:energy_of_hco/pages/choose_user.dart';
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
  
  void changeCurrentDate(DateTime newDate){
    return Provider.of<OrdersProvider>(context, listen: false).changeDay(newDate);
  }

  @override
  Widget build(BuildContext context) {
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
              onDateChange: (DateTime newDate) =>
                  changeCurrentDate(newDate),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: kAppWidthPadding),
                child: Text(
                  "Total orders",
                  style: getAppTextTheme(context).headline5,
                )),
            TotalOrders(
              date: getDateForOrders(),
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
                    child: const _OrdersAsListView(orders: [],)
                  )
                : TotalOrders(date: getDateForOrders()),
          ],
        ),
      ),
    );
  }
}

class _OrdersAsListView extends StatelessWidget {
  const _OrdersAsListView({Key? key, required this.orders}) : super(key: key);

  final List<Order> orders;

  @override
  Widget build(BuildContext context) {
    return MyPaper(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Pending",
            style: getAppTextTheme(context).headline6,
          ),
          _MyListItem(item: null, amountBought: 1,)
        ],
      ),
    );
  }
}

class _MyListItem extends StatelessWidget {
  const _MyListItem({Key? key, required this.item, required this.amountBought}) : super(key: key);
  final CartItem? item;
  final int amountBought;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.check_circle_outline,color: getAppColorScheme(context).primary,),
      ],
    );
  }
}
