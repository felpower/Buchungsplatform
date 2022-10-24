import 'package:counter_button/counter_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/utils/utils.dart';

import '../../models/Event.dart';
import '../../services/EventProvider.dart';

class EventEditingPage extends StatefulWidget {
  final Event? event;

  const EventEditingPage({
    Key? key,
    this.event,
  }) : super(key: key);

  @override
  _EventEditingPageState createState() => _EventEditingPageState();
}

class _EventEditingPageState extends State<EventEditingPage> {
  final _formKey = GlobalKey<FormState>();
  final playerController = TextEditingController();
  late DateTime fromDate;
  late DateTime toDate;
  int guestCounter = 0;

  @override
  void initState() {
    super.initState();

    if (widget.event == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(const Duration(hours: 2));
    }
  }

  @override
  void dispose() {
    playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: const CloseButton(),
          actions: buildEditingActions(),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                buildPlayers(),
                buildGuests(),
                const SizedBox(height: 12),
                buildDurationPicker(),
              ],
            ),
          ),
        ),
      );

  List<Widget> buildEditingActions() => [
        ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              primary: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            onPressed: saveForm,
            icon: const Icon(Icons.done),
            label: const Text('Reservieren')),
      ];

  Widget buildPlayers() => TextFormField(
        style: const TextStyle(fontSize: 24),
        decoration: const InputDecoration(
            border: UnderlineInputBorder(), hintText: 'Spieler hinzufügen'),
        onFieldSubmitted: (_) {},
        validator: (players) => players != null && players.isEmpty
            ? 'Spieler können nicht leer sein'
            : null,
        controller: playerController,
      );

  Widget buildGuests() =>
      Row(children: [const Text('Anzahl Gäste'), buildCounterButton()]);

  Widget buildDurationPicker() => Column(
        children: [
          buildFrom(),
        ],
      );

  Widget buildFrom() => Row(
        children: [
          Expanded(
              child: buildDropdownField(
            text: Utils.toDate(fromDate),
            onClicked: () => pickFromDateTime(),
          )),
          Expanded(child: pickFromDuration()),
        ],
      );

  buildDropdownField({required String text, required VoidCallback onClicked}) =>
      ListTile(
        title: Text(text),
        trailing: const Icon(Icons.arrow_drop_down),
        onTap: onClicked,
      );

  buildCounterButton() => CounterButton(
        loading: false,
        onChange: (int val) {
          setState(() {
            if (val < 0 || val > 10) {
            } else {
              guestCounter = val;
            }
          });
        },
        count: guestCounter,
        countColor: Colors.purple,
        buttonColor: Colors.purpleAccent,
        progressColor: Colors.purpleAccent,
      );

  Future pickFromDateTime() async {
    final date = await pickDateTime(fromDate, pickDate: true);

    if (date == null) return;

    setState(() => fromDate = date);
  }

  Future<DateTime?> pickDateTime(DateTime initialDate,
      {required bool pickDate, DateTime? firstDate}) async {
    if (pickDate) {
      final date = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: firstDate ?? DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)));
      if (date == null) return null;

      final time =
      Duration(hours: initialDate.hour, minutes: initialDate.minute);

      return date.add(time);

    }
  }

  int chosenDuration = 1;

  var items = [
    1,
    2,
    3,
    4,
    5,
  ];

  pickFromDuration() => Column(children: [
        DropdownButton(
          // Initial Value
          value: chosenDuration,

          // Down Arrow Icon
          icon: const Icon(Icons.keyboard_arrow_down),

          // Array list of items
          items: items.map((int items) {
            return DropdownMenuItem(
              value: items,
              child: Text('$items Stunde'),
            );
          }).toList(),
          // After selecting the desired option,it will
          // change button value to selected value
          onChanged: (int? newValue) {
            setState(() {
              chosenDuration = newValue!;
            });
          },
        )
      ]);

  Future saveForm() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      //ToDo: Validate and change player counter
      final event = Event(
          start: fromDate,
          player: playerController.text,
          numberOfPlayers: guestCounter,
          playingType: 'Einzel',
          duration: chosenDuration,
          place: 'Place 1',
          info: '');
      final provider = Provider.of<EventProvider>(context, listen: false);
      provider.addEvent(event);

      Navigator.of(context).pop();
    }
  }
}
