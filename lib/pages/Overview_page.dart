import 'package:energy_of_hco/widgets/days_scroll.dart';
import 'package:flutter/material.dart';

class OverView extends StatelessWidget {
  const OverView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          DaysScroll(initialDate: DateTime(2023,1,3),)
        ],
      ),
    );
  }
}
