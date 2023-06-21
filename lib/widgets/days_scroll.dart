import 'package:energy_of_hco/helpers/app_theme_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

List<DateTime> getWeekDates({required int year, required int weekNumber}) {
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

class DaysScroll extends StatefulWidget {
  const DaysScroll({Key? key}) : super(key: key);

  @override
  _DaysScrollState createState() => _DaysScrollState();
}

class _DaysScrollState extends State<DaysScroll> {
  List<String> listOfMonths = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ]; //List Of Months

  List<String> listOfDays = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun"
  ]; //List of Days

  DateTime selectedDate = DateTime.now(); // TO tracking date

  int currentDateSelectedIndex = 0; //For Horizontal Date
  ScrollController scrollController =
      ScrollController(); //Scroll Controller for ListView

  @override
  Widget build(BuildContext context) {
    print(getWeekDates(weekNumber: 1, year: 2023));
    return Container(
        height: 100,
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
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int indexDay) {
                      DateTime currentDate = getWeekDates(
                          weekNumber: indexWeek + 1, year: 2023)[indexDay];
                      return Column(
                        children: [
                          Text(DateFormat.MMM().format(currentDate)),
                          InkWell(
                            onTap: () {
                              setState(() {
                                currentDateSelectedIndex = indexDay;
                                selectedDate =
                                    DateTime.now().add(Duration(days: indexDay));
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(2),
                              width: MediaQuery.of(context).size.width * 0.11,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: currentDateSelectedIndex == indexDay
                                      ? getAppColorScheme(context).primary
                                      : getAppColorScheme(context).onPrimary),
                              child: Column(
                                children: [
                                  Text(
                                    DateFormat.E().format(currentDate),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: currentDateSelectedIndex ==
                                                indexDay
                                            ? getAppColorScheme(context)
                                                .onPrimary
                                            : getAppTextTheme(context)
                                                .bodyText1!
                                                .color),
                                  ),
                                  Text(
                                    "${currentDate.day}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: currentDateSelectedIndex ==
                                                indexDay
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
                            DateFormat.y().format(currentDate),
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
