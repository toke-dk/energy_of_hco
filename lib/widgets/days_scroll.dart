import 'package:energy_of_hco/helpers/app_theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class DaysScroll extends StatefulWidget {
  const DaysScroll({Key? key, required this.initialDate}) : super(key: key);
  final DateTime initialDate;

  @override
  _DaysScrollState createState() => _DaysScrollState();
}

class _DaysScrollState extends State<DaysScroll> {
  late final DateTime _initialDate;
  late DateTime _selectedDate;

  @override
  void initState() {
    _initialDate = widget.initialDate;

    _selectedDate = _initialDate;
    super.initState();
  }

  List<DateTime> _getWeekDates({required int year, required int weekNumber}) {
    final DateTime firstDayOfYear = _getFirstMondayOfYear(year);
    final int daysOffset = (weekNumber - 1) * 7;

    final DateTime firstDayOfTargetWeek =
        firstDayOfYear.add(Duration(days: daysOffset));
    final List<DateTime> weekDates = [];

    for (int i = 0; i < 7; i++) {
      final DateTime date = firstDayOfTargetWeek.add(Duration(days: i));
      weekDates.add(date);
    }

    return weekDates;
  }

  DateTime _getFirstMondayOfYear(int year) {
    DateTime date = DateTime(year, 1, 1);
    while (date.weekday != DateTime.monday) {
      date = date.add(Duration(days: 1));
    }
    return date;
  }

  int _getWeekNumberFromDate(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  /// TODO make this a smarter way for example via a class or just change the textcolor in texttheme
  Map<String, Color> _colorsFromDateDifference(
      DateTime firstDate, DateTime secondDate) {
    Color buttonColor = firstDate.isSameDate(secondDate)
        ? getAppColorScheme(context).primary
        : getAppColorScheme(context).onPrimary;
    Color textColor = firstDate.isSameDate(secondDate)
        ? getAppColorScheme(context).onPrimary
        : getAppTextTheme(context).bodyText1!.color!;
    return {"button": buttonColor, "text": textColor};
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 110,
        child: ScrollablePositionedList.builder(
          initialScrollIndex: _getWeekNumberFromDate(_initialDate),
          shrinkWrap: true,
          itemCount: 52,
          scrollDirection: Axis.horizontal,
          physics: const PageScrollPhysics(),
          itemBuilder: (context, indexWeek) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => SizedBox(
                          width: 10,
                        ),
                    itemCount: 7,
                    padding: EdgeInsets.all(10),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int indexDay) {
                      DateTime thisIndexDate = _getWeekDates(
                          weekNumber: indexWeek,
                          year: _initialDate.year)[indexDay];
                      return Column(
                        children: [
                          Text(DateFormat.MMM().format(thisIndexDate)),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _selectedDate = thisIndexDate;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(5),
                              width: MediaQuery.of(context).size.width * 0.11,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: _colorsFromDateDifference(
                                      _selectedDate, thisIndexDate)["button"]),
                              child: Column(
                                children: [
                                  Text(
                                    DateFormat.E().format(thisIndexDate),
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: _colorsFromDateDifference(
                                            _selectedDate,
                                            thisIndexDate)["text"]),
                                  ),
                                  Text(
                                    "${thisIndexDate.day}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: _colorsFromDateDifference(
                                            _selectedDate,
                                            thisIndexDate)["text"]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Text(
                            DateFormat.y().format(thisIndexDate),
                            style: getAppTextTheme(context).subtitle1,
                          ),
                        ],
                      );
                    }),
              ),
            );
          },
        ));
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return day == other.day && year == other.year && month == other.month;
  }
}

/// TODO avoid nesting the listview.builder but make the direction in another way
/// TODO fix the choosing
