import 'package:energy_of_hco/helpers/app_theme_helper.dart';
import 'package:energy_of_hco/models/item_categories.dart';
import 'package:flutter/material.dart';

class AddItems extends StatelessWidget {
  const AddItems({Key? key}) : super(key: key);

  final Categories chosenCategory = Categories.bestSelling;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add items"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_basket),
            onPressed: () {},
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
                style: getAppTextTheme(context).headline5,
              ),
              Placeholder(),
              Text(
                chosenCategory.displayName,
                style: getAppTextTheme(context).headline5,
              ),
              Placeholder(),
            ],
          ),
        ),
      ),
    );
  }
}
