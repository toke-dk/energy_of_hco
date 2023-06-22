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
    this.borderRadius,
  }) : super(key: key);

  final Widget? child;
  final double? width;
  final double? height;
  final bool hasShadow;
  final GestureTapCallback? onTap;
  final EdgeInsets? padding;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 19),
          color: getAppColorScheme(context).onPrimary,
          boxShadow: hasShadow
              ? [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 6,
                    blurRadius: 5,
                  ),
                ]
              : null,
        ),
        child: child,
        width: width,
        height: height,
      ),
    );
  }
}
