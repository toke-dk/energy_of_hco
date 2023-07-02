import 'package:energy_of_hco/models/order.dart';
import 'package:energy_of_hco/models/product.dart';
import 'package:energy_of_hco/models/user.dart';
import 'package:energy_of_hco/pages/overview_page.dart';
import 'package:energy_of_hco/palette.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  final Color headlineColor = Colors.black;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (BuildContext context) => ProductsNotifier()),
        ChangeNotifierProvider(
            create: (BuildContext context) => UsersProvider()),
        ChangeNotifierProvider(
          create: (context) => OrdersProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Energy of HCØ',
        theme: ThemeData(
          primarySwatch: Palette.kPrimaryMaterialColor,
          outlinedButtonTheme: OutlinedButtonThemeData(
              style: ButtonStyle(
                  side: MaterialStateProperty.all(
                      BorderSide(color: Palette.kPrimaryMaterialColor[200]!)))),
          scaffoldBackgroundColor: const Color(0xffFAFAFA),
        ),
        home: const MyHomePage(title: 'Overview'),
      ),
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
  @override
  Widget build(BuildContext context) {
    return const OverView();
  }
}
