import 'package:flutter/material.dart';

class AddItems extends StatelessWidget {
  const AddItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add items"),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_basket),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
