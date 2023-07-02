import 'package:energy_of_hco/helpers/app_theme_helper.dart';
import 'package:flutter/material.dart';

class MyHorizontalListView extends StatelessWidget {
  const MyHorizontalListView(
      {Key? key,
      required this.chosenItems,
      required this.onChange,
      required this.allItems,
      required this.allTitles,
      this.scaleFactor,
      this.showCheckMark})
      : super(key: key);
  final List<dynamic> chosenItems;
  final List<dynamic> allItems;
  final Function(dynamic) onChange;
  final List<String> allTitles;
  final double? scaleFactor;
  final bool? showCheckMark;

  List<Color> _getButtonColors(dynamic currentIndexCategories, context) {
    // the first item is the background
    // the second is the textcolor
    if (chosenItems.contains(currentIndexCategories)) {
      return [
        getAppColorScheme(context).primary,
        getAppColorScheme(context).onPrimary
      ];
    }
    return [
      getAppColorScheme(context).onPrimary,
      getAppTextTheme(context).bodyMedium!.color!
    ];
  }

  Icon getIconFromCheckState(bool isChecked, Color color) {
    return isChecked
        ? Icon(
            Icons.check_circle,
            color: color,
          )
        : Icon(
            Icons.check_circle_outline,
            color: color,
          );
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      alignment: Alignment.centerLeft,
      scale: scaleFactor ?? 1,
      child: SizedBox(
        height: 50,
        child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              dynamic currentIndexItem = allItems[index];
              return GestureDetector(
                onTap: () => onChange(currentIndexItem),
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17),
                    color: _getButtonColors(currentIndexItem, context)[0],
                  ),
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Row(
                      children: [
                        showCheckMark == true
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: getIconFromCheckState(
                                    chosenItems.contains(currentIndexItem),
                                    _getButtonColors(
                                        currentIndexItem, context)[1]),
                              )
                            : const SizedBox(),
                        Text(
                          allTitles[index],
                          style: getAppTextTheme(context).bodySmall!.copyWith(
                              color: _getButtonColors(
                                  currentIndexItem, context)[1]),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(
                  width: 8,
                ),
            itemCount: allItems.length),
      ),
    );
  }
}
