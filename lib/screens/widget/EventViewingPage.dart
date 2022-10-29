import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/screens/widget/EventEditingPage.dart';

import '../../models/Event.dart';
import '../../services/EventProvider.dart';
import '../../utils/utils.dart';

class EventViewingPage extends StatelessWidget {
  final Event event;

  const EventViewingPage({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: CloseButton(),
          actions: buildViewingActions(context, event),
        ),
        body: ListView(
          padding: EdgeInsets.all(32),
          children: <Widget>[
            buildDateTime(event),
            SizedBox(height: 32),
            Text(event.player.join(" "),
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Text(
              event.info,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      );

  buildDateTime(event) {
    return Column(
      children: [
        Text('Datum: ' + Utils.toDate(event.startTime)),
        Text('Dauer: ' + event.duration.toString()),
      ],
    );
  }

  List<Widget> buildViewingActions(BuildContext context, Event event) =>
      <Widget>[
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => EventEditingPage(event: event))),
        ),
        IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              final provider =
                  Provider.of<EventProvider>(context, listen: false);

              provider.deleteEvent(event);
              Navigator.of(context).pop();
            }),
      ];
}
