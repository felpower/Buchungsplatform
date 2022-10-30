import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:untitled/models/EventDataSource.dart';
import 'package:untitled/services/EventProvider.dart';

import 'EventViewingPage.dart';

class TaskWidget extends StatefulWidget {
  const TaskWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);
    final selectedEvents = provider.eventsOfSelectedDate;
    if (selectedEvents.isEmpty) {
      return const Center(
        child: Text('Keine Events gefunden!'),
      );
    } else {
      return SfCalendarTheme(
        data: SfCalendarThemeData(),
        child: SfCalendar(
          view: CalendarView.timelineWeek,
          dataSource: DataSource.getDataSource(provider.events),
          initialDisplayDate: provider.selectedDate,
          resourceViewSettings:
              const ResourceViewSettings(visibleResourceCount: 2, size: 40),
          appointmentBuilder: appointmentBuilder,
          todayHighlightColor: Colors.black,
          selectionDecoration:
              BoxDecoration(color: Colors.red.withOpacity(0.3)),
          onTap: (details) {
            if (details.appointments == null) {
              return;
            }
            final event = details.appointments!.first;
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EventViewingPage(event: event)));
          },
        ),
      );
    }
  }

  Widget appointmentBuilder(
      BuildContext context, CalendarAppointmentDetails details) {
    final event = details.appointments.first;

    return Container(
      width: details.bounds.width,
      height: details.bounds.height,
      decoration: BoxDecoration(
          color: Colors.green.shade700,
          borderRadius: BorderRadius.circular(12)),
      child: Text(
        event.player.join(",\n"),
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
            color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
