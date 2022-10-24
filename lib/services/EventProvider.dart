
import 'package:flutter/material.dart';

import '../models/Event.dart';

class EventProvider extends ChangeNotifier{

  final List<Event> _events = [];

  List<Event> get events => _events;

  void addEvent(Event event){
    _events.add(event);

    notifyListeners();
  }

}
