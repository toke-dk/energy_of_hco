import 'package:energy_of_hco/helpers/app_theme_helper.dart';
import 'package:flutter/material.dart';

class MyPaper extends StatelessWidget {
  const MyPaper({
    Key? key,
    this.child,
    this.width,
    this.height,
    this.hasShadow = false,
    this.onTap,
    this.padding,
  }) : super(key: key);

  final Widget? child;
  final double? width;
  final double? height;
  final bool hasShadow;
  final GestureTapCallback? onTap;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        color: getAppColorScheme(context).onPrimary,
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 6,
                  blurRadius: 4,
                  offset: const Offset(0, 3), // changes position of shadow
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
