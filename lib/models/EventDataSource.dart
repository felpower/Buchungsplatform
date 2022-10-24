import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'Event.dart';

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Event> appointments) {
    this.appointments = appointments;
  }

  Event getEvent(int index) => appointments![index] as Event;

  @override
  DateTime getStartTime(int index) {
    var event = getEvent(index);
    print("This is event with start time: " + event.start.toString());
    return event.start;
  }

  @override
  DateTime getEndTime(int index) {
    var event = getEvent(index);
    return event.start.add(Duration(hours: event.duration));
  }

  @override
  String getSubject(int index) {
    return getEvent(index).player;
  }
}
