import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'Event.dart';

class DataSource extends CalendarDataSource {
  DataSource(List<Event> appointments, List<CalendarResource> resourceColl) {
    this.appointments = appointments;
    resources = resourceColl;
  }

  Event getEvent(int index) {
    print("This is an Appointment " + appointments![index]);
    return appointments![index];
  }

  CalendarResource getResource(int index) => resources![index];

  @override
  DateTime getStartTime(int index) {
    var event = getEvent(index);
    return event.startTime;
  }

  @override
  DateTime getEndTime(int index) {
    var event = getEvent(index);
    return event.startTime.add(Duration(hours: event.duration));
  }

  @override
  String getSubject(int index) {
    return getEvent(index).player;
  }

  static DataSource getDataSource(List<Event> events) {
    List<CalendarResource> resources = <CalendarResource>[];

    resources.add(CalendarResource(
        displayName: 'Platz 1', id: '0001', color: Colors.red));
    resources.add(CalendarResource(
        displayName: 'Platz 2', id: '0002', color: Colors.blue));
    return DataSource(events, resources);
  }
}
