import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:untitled/services/EventProvider.dart';

import '../../models/EventDataSource.dart';
import 'TaskWidget.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventProvider>(context).events;
    return SfCalendar(
      view: CalendarView.timelineDay,
      dataSource: DataSource.getDataSource(events),
      initialDisplayDate: DateTime.now(),
      firstDayOfWeek: DateTime.monday,
      specialRegions: _getTimeRegions(),
      resourceViewSettings:
          const ResourceViewSettings(visibleResourceCount: 2, size: 50),
      onLongPress: (details) {
        final provider = Provider.of<EventProvider>(context, listen: false);
        provider.setDate(details.date!);
        showModalBottomSheet(
          context: context,
          builder: (context) => const TaskWidget(),
        );
      },
    );
  }

  Widget appointmentBuilder(
      BuildContext context, CalendarAppointmentDetails details) {
    final event = details.appointments.first;

    return Container(
      width: details.bounds.width,
      height: details.bounds.height,
      decoration: BoxDecoration(
          color: Colors.yellowAccent.shade700,
          borderRadius: BorderRadius.circular(12)),
      child: Text(
        event.player,
        maxLines: 5,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
            color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  List<TimeRegion> _getTimeRegions() {
    final List<TimeRegion> regions = <TimeRegion>[];
    regions.add(TimeRegion(
        startTime: DateTime.utc(2022,1, 1, 20),
        endTime: DateTime.utc(2022,1, 1, 21).add(Duration(hours: 11)),
        recurrenceRule: 'FREQ=DAILY',
        enablePointerInteraction: false,
        color: Colors.grey.withOpacity(0.2)));

    return regions;
  }
}
