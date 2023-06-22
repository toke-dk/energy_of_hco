import 'package:energy_of_hco/helpers/app_theme_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



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
    final DateTime firstDayOfYear = DateTime(year, 1, 1);
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

  /// TODO do i need the scroll controler
  final ScrollController _scrollController =
      ScrollController(); //Scroll Controller for ListView

  @override
  Widget build(BuildContext context) {
    print(_getWeekDates(weekNumber: 1, year: 2023));
    return Container(
        height: 110,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: 3,
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
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int indexDay) {
                      DateTime thisIndexDate = _getWeekDates(
                          weekNumber: indexWeek + 1, year: 2023)[indexDay];
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
                                  color: _selectedDate == thisIndexDate
                                      ? getAppColorScheme(context).primary
                                      : getAppColorScheme(context).onPrimary),
                              child: Column(
                                children: [
                                  Text(
                                    DateFormat.E().format(thisIndexDate),
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: _selectedDate ==
                                                thisIndexDate
                                            ? getAppColorScheme(context)
                                                .onPrimary
                                            : getAppTextTheme(context)
                                                .bodyText1!
                                                .color),
                                  ),
                                  Text(
                                    "${thisIndexDate.day}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                        color: _selectedDate ==
                                                thisIndexDate
                                            ? getAppColorScheme(context)
                                                .onPrimary
                                            : getAppTextTheme(context)
                                                .bodyText1!
                                                .color),
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

/// TODO avoid nesting the listview.builder but make the direction in another way
/// TODO fix the choosing
