import 'package:energy_of_hco/constants/fees.dart';
import 'package:energy_of_hco/helpers/app_theme_helper.dart';
import 'package:energy_of_hco/pages/choose_user.dart';
import 'package:energy_of_hco/widgets/days_scroll.dart';
import 'package:energy_of_hco/widgets/my_horizontal_listview.dart';
import 'package:energy_of_hco/widgets/total_orders.dart';
import 'package:flutter/material.dart';

class OverView extends StatefulWidget {
  const OverView({Key? key}) : super(key: key);

  @override
  State<OverView> createState() => _OverViewState();
}

class _OverViewState extends State<OverView> {
  DateTime selectedDay = DateTime.now();
  List<String> items = ["Card-view", "List-view"];
  String currentItem = "Card-view";

  void handleChange(String newString) {
    setState(() {
      currentItem = newString;
    });
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
                      dateChosen: selectedDay,
                    ))),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DaysScroll(
              initialDate: selectedDay,
              onDateChange: (DateTime newDate) =>
                  setState(() => selectedDay = newDate),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: kAppWidthPadding),
                child: Text(
                  "Total orders",
                  style: getAppTextTheme(context).headline5,
                )),
            TotalOrders(
              date: selectedDay,
            ),
            Padding(
              padding: EdgeInsets.all(kAppWidthPadding),
              child: Text(
                "Pending and complete",
                style: getAppTextTheme(context).headline5,
              ),
            ),
            MyHorizontalListView(
                chosenItems: [currentItem],
                onChange: (val) => handleChange(val),
                allItems: items,
                allTitles: items)
          ],
        ),
      ),
    );
  }
}
