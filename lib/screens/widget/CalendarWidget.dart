import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:untitled/services/EventProvider.dart';

import '../../models/EventDataSource.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventProvider>(context).events;
    return SfCalendar(
      view: CalendarView.week,
      dataSource: EventDataSource(events),
      initialDisplayDate: DateTime.now(),
      firstDayOfWeek: DateTime.monday,

    );
  }
}
