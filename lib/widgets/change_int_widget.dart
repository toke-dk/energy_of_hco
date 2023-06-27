import 'package:energy_of_hco/helpers/app_theme_helper.dart';
import 'package:flutter/material.dart';

class ChangeIntTile extends StatelessWidget {
  const ChangeIntTile(
      {Key? key,
      required this.onValueChange,
      required this.intAmount,
      this.maxVal,
      this.minVal})
      : super(key: key);
  final Function(int changedValue)? onValueChange;
  final int intAmount;
  final int? maxVal;
  final int? minVal;

  Color? getIconColor(context, int? value) {
    return value != null && value == intAmount
        ? Theme.of(context).disabledColor
        : getAppColorScheme(context).primary;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _MyRoundedButton(
          icon: Icons.add,
          color: getIconColor(context, maxVal),
          onTap: () => onValueChange != null ? onValueChange!(1) : null,
        ),
        maxVal != null ? Row(
          children: [
            Text(intAmount.toString()),
            Text("/ " + maxVal.toString(),style: TextStyle(color: Theme.of(context).unselectedWidgetColor, fontSize: 10),),
          ],
        ) : Text(intAmount.toString()),

        _MyRoundedButton(
          color: getIconColor(context, minVal),
          icon: Icons.remove,
          onTap: () => onValueChange != null ? onValueChange!(-1) : null,
        ),
      ],
    );
  }
}

class _MyRoundedButton extends StatelessWidget {
  const _MyRoundedButton({Key? key, required this.icon, required this.onTap, this.color})
      : super(key: key);

  final IconData icon;
  final Function() onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color ?? getAppColorScheme(context).primary),
        child: InkWell(
          onTap: onTap,
          child: Icon(
            icon,
            color: getAppColorScheme(context).onPrimary,
            size: 20,
          ),
        ));
  }
}