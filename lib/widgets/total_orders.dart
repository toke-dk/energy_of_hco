import 'package:energy_of_hco/helpers/app_theme_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TotalOrders extends StatelessWidget {
  const TotalOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Container(
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 7),
                    child: ShowProductDetails()),
              ],
            );
          },
          separatorBuilder: (context, idex) => const SizedBox(
                width: 19,
              ),
          itemCount: 10),
    );
  }
}

class ShowProductDetails extends StatelessWidget {
  const ShowProductDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: 184,
        minHeight: 184,
        maxWidth: 184,
        maxHeight: 184,
      ),
      child: MyPaper(
        hasShadow: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 90,
              child: Stack(
                children: [
                  Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                      child: Placeholder()),
                  Positioned(
                      right: 0,
                      child: IconButton(
                          onPressed: () {}, icon: Icon(Icons.favorite_border, color: getAppColorScheme(context).primary,)))
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 13, right: 13, bottom: 11),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Title",
                      style: TextStyle(
                        fontSize: 16
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Subtitle",
                          style: getAppTextTheme(context).subtitle1,
                        ),
                        Text(
                          "Trailing",
                          style: getAppTextTheme(context).subtitle1,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("xy,zz kr.", style: TextStyle(color: getAppColorScheme(context).primary, fontWeight: FontWeight.bold),),
                        GestureDetector(
                          child: Icon(
                            Icons.visibility,
                            size: 20,
                            color: getAppColorScheme(context).primary,
                          ),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        onTap: () {},
      ),
    );
  }
}

class MyPaper extends StatelessWidget {
  const MyPaper({
    Key? key,
    this.child,
    this.width,
    this.height,
    this.hasShadow = false,
    this.onTap,
  }) : super(key: key);

  final Widget? child;
  final double? width;
  final double? height;
  final bool hasShadow;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        color: getAppColorScheme(context).onPrimary,
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 6,
                  blurRadius: 4,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ]
            : null,
      ),
      child: GestureDetector(onTap: onTap, child: child),
      width: width,
      height: height,
    );
  }
}
