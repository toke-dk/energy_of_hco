import 'package:flutter/material.dart';

class Palette {
  static const MaterialColor kPrimaryMaterialColor = MaterialColor(
    0xff990969, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xff8a085f),//10%
      100: Color(0x000f1ef9),//20%
      200: Color(0xff7a0754),//30%
      300: Color(0xff6b064a),//40%
      400: Color(0xff5c053f),//50%
      500: Color(0xff4d0535),//60%
      600: Color(0xff3d042a),//70%
      700: Color(0xff2e031f),//80%
      800: Color(0xff1f0215),//90%
      900: Color(0xff0f010a),//100%
    },
  );
}