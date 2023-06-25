import 'package:flutter/material.dart';

// this page https://maketintsandshades.com/
class Palette {
  static const MaterialColor kPrimaryMaterialColor = MaterialColor(
    0xff96216f, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xffc584af),//10%
      100: Color(0xffb96b9f),//20%
      200: Color(0xffad528f),//30%
      300: Color(0xffa1397f),//40%
      400: Color(0xff96216f),//50%
      500: Color(0xff8a085f),//60%
      600: Color(0xff7c0756),//70%
      700: Color(0xff6e064c),//80%
      800: Color(0xff610643),//90%
      900: Color(0xff530539),//100%
    },
  );
}