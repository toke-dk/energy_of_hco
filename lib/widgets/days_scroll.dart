import 'package:energy_of_hco/helpers/app_theme_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

List<DateTime> getWeekDates(int weekNumber) {
  final DateTime now = DateTime.now();
  final DateTime firstDayOfYear = DateTime(now.year, 1, 1);
  final int daysOffset = (weekNumber - 1) * 7;

  final DateTime firstDayOfTargetWeek = firstDayOfYear.add(Duration(days: daysOffset));
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

    return Container(
        height: 60,
        color: Colors.green,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: 3,
          scrollDirection: Axis.horizontal,
          physics: const PageScrollPhysics(),
          itemBuilder: (context, indexWeek) {
            List<DateTime> currentWeekDates = getWeekDates(indexWeek);
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
                      return InkWell(
                        onTap: () {
                          setState(() {
                            currentDateSelectedIndex = indexDay;
                            selectedDate =
                                DateTime.now().add(Duration(days: indexDay));
                          });
                        },
                        child: Column(
                          children: [
                            Text(listOfDays[indexDay]),
                            InkWell(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.1,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: currentDateSelectedIndex == indexDay
                                        ? getAppColorScheme(context).primary
                                        : getAppColorScheme(context).onPrimary),
                                child: Text(
                                  "${currentWeekDates[indexDay].day}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: currentDateSelectedIndex ==
                                              indexDay
                                          ? getAppColorScheme(context).onPrimary
                                          : getAppTextTheme(context)
                                              .bodyText1!
                                              .color),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            );
          },
        ));
  }
}
/// TODO avoid nesting the listview.builder but make the direction in another way