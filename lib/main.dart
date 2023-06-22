import 'package:energy_of_hco/models/item_categories.dart';
import 'package:energy_of_hco/models/product.dart';
import 'package:energy_of_hco/models/user.dart';
import 'package:energy_of_hco/pages/choose_user.dart';
import 'package:energy_of_hco/pages/overview_page.dart';
import 'package:energy_of_hco/palette.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  final Color headlineColor = Colors.black;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Energy of HCØ',
      theme: ThemeData(
          textTheme: TextTheme(
              headline1:
                  TextStyle(fontWeight: FontWeight.bold, color: headlineColor),
              headline2:
                  TextStyle(fontWeight: FontWeight.bold, color: headlineColor),
              headline3:
                  TextStyle(fontWeight: FontWeight.bold, color: headlineColor),
              headline4:
                  TextStyle(fontWeight: FontWeight.bold, color: headlineColor),
              headline5:
                  TextStyle(fontWeight: FontWeight.bold, color: headlineColor),
              headline6:
                  TextStyle(fontWeight: FontWeight.bold, color: headlineColor),
              bodyText1: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black),
              bodyText2: const TextStyle(color: Colors.black),
              subtitle1: TextStyle(fontSize: 13, color: Colors.grey[600])),
          scaffoldBackgroundColor: const Color(0xffFAFAFA),
          fontFamily: "Jura",
          primarySwatch: Palette.kPrimaryMaterialColor),
      home: const MyHomePage(title: 'Overview'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // TODO these should come from the db of course
  final List<User> users = [
    User(
        firstName: "John",
        lastName: "Doe",
        energyPoints: 103,
        favouriteProducts: [
          Product(
              name: "Monster",
              image: Image.network(
                  "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg"),
              priceInDKK: 12.5,
              categories: [Categories.monster],
              sizeInCL: 25)
        ]),
    User(
        firstName: "Flappy",
        lastName: "Bird",
        energyPoints: 243,
        favouriteProducts: [
          Product(
              name: "Bold super duper",
              image: Image.network(
                  "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg"),
              priceInDKK: 12.5,
              categories: [Categories.bold],
              sizeInCL: 26)
        ])
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChooseUser(allUsers: users))),
      ),
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
      ),
      body: const SingleChildScrollView(
        child: OverView(),
      ),
    );
  }
}
