import 'package:energy_of_hco/helpers/app_theme_helper.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Body text1",
                style: getAppTextTheme(context).bodyText1,
              ),
              Text(
                "Body text2",
                style: getAppTextTheme(context).bodyText2,
              ),
              Text(
                "subtitle 1",
                style: getAppTextTheme(context).subtitle1,
              ),
              Text(
                "subtitle 2",
                style: getAppTextTheme(context).subtitle1,
              ),
              Text(
                "Headline 1",
                style: getAppTextTheme(context).headline1,
              ),
              Text(
                "Headline 2",
                style: getAppTextTheme(context).headline2,
              ),
              Text(
                "Headline 3",
                style: Theme.of(context).textTheme.headline3,
              ),
              Text(
                "Headline 4",
                style: Theme.of(context).textTheme.headline4,
              ),
              Text(
                "Headline 5",
                style: Theme.of(context).textTheme.headline5,
              ),
              Text(
                "Headline 6",
                style: Theme.of(context).textTheme.headline6,
              ),
              const Text(
                'You have pushed the button this many times:',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
