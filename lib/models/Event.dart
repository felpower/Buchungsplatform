import 'package:syncfusion_flutter_calendar/calendar.dart';

class Event extends Appointment {
  final DateTime start;
  final String player;
  final int numberOfPlayers;
  final String playingType;
  final int duration;
  final int place;
  final String info;

  Event(
      {required this.start,
      required this.player,
      required this.numberOfPlayers,
      required this.playingType,
      required this.duration,
      required this.place,
      required this.info})
      : super(
            startTime: start,
            endTime: start.add(Duration(hours: duration)),
            resourceIds: <Object>['000$place']);
}
