import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MonthlyScreen extends StatefulWidget {
  @override
  _MonthlyScreenState createState() => _MonthlyScreenState();
}

CalendarController ctrlr = new CalendarController();

class _MonthlyScreenState extends State<MonthlyScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: TableCalendar(
      calendarController: ctrlr,
      availableCalendarFormats: const {
        CalendarFormat.week: 'Week',
      },
      startingDayOfWeek: StartingDayOfWeek.monday,
      initialCalendarFormat: CalendarFormat.week,
    ));
  }
}
