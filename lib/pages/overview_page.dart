import 'package:energy_of_hco/helpers/app_theme_helper.dart';
import 'package:energy_of_hco/widgets/days_scroll.dart';
import 'package:energy_of_hco/widgets/total_orders.dart';
import 'package:flutter/material.dart';

class OverView extends StatelessWidget {
  const OverView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DaysScroll(
            initialDate: DateTime.now(),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                "Total orders",
                style: getAppTextTheme(context).headline5,
              )),
          TotalOrders()
        ],
      ),
    );
  }
}
