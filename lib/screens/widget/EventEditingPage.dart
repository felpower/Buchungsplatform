import 'package:counter_button/counter_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_picker_widget/time_picker_widget.dart';
import 'package:toggle_switch/toggle_switch.dart';
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
  int place = 0;

  @override
  void initState() {
    super.initState();

    if (widget.event == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(const Duration(hours: 2));
    } else {
      final event = widget.event!;

      playerController.text = event.player;

      fromDate = event.startTime;
      toDate = fromDate.add(Duration(hours: event.duration));
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
                const SizedBox(height: 12),
                buildDuration(),
                const SizedBox(height: 12),
                buildPlace(),
                const SizedBox(height: 12),
                buildGuests(),
                const SizedBox(height: 12),
                buildSpielTyp(),
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

  Widget buildPlace() => ToggleSwitch(
        initialLabelIndex: place,
        totalSwitches: 2,
        minWidth: 100,
        labels: const ['Platz 1', 'Platz 2'],
        onToggle: (index) {
          place = index!;
        },
      );

  Widget buildDuration() => ToggleSwitch(
        initialLabelIndex: place,
        totalSwitches: 2,
        minWidth: 100,
        labels: const ['1 Stunde', '2 Stunden'],
        onToggle: (index) {
          chosenDuration = index!;
        },
      );

  Widget buildGuests() =>
      Row(children: [const Text('Anzahl Gäste'), buildCounterButton()]);

  Widget buildSpielTyp() => Row(
        children: [
          Text(guestCounter < 2 ? 'Spieltyp: Einzel' : 'Spieltyp: Doppel')
        ],
      );

  Widget buildDurationPicker() => Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: buildDropdownField(
                text: Utils.toDate(fromDate),
                onClicked: () => pickFromDateTime(pickDate: true),
              )),
              Expanded(
                  child: buildDropdownField(
                      text: Utils.toTime(fromDate),
                      onClicked: () => pickFromDateTime(pickDate: false))),
            ],
          )
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

  Future pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(fromDate, pickDate: pickDate);

    if (date == null) return;

    setState(() => fromDate = date);
  }

  final List<int> _availableHours = [
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21
  ];

  final List<int> _availableMinutes = [0];
  late String selectedTime;

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
    } else {
      final timeOfDay = await showCustomTimePicker(
          context: context,
          // It is a must if you provide selectableTimePredicate
          onFailValidation: (context) => print('Unavailable selection'),
          initialTime: TimeOfDay(hour: initialDate.hour, minute: 0),
          selectableTimePredicate: (initialTime) =>
              _availableHours.contains(initialTime!.hour) &&
              _availableMinutes.contains(initialTime.minute));
      if (timeOfDay == null) return null;
      final date =
          DateTime(initialDate.year, initialDate.month, initialDate.day);
      return date.add(Duration(hours: timeOfDay.hour, minutes: 0, seconds: 0));
    }
  }

  int chosenDuration = 1;

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
          place: place,
          info: '');
      final isEditing = widget.event != null;

      final provider = Provider.of<EventProvider>(context, listen: false);
      if (isEditing) {
        provider.editEvent(event, widget.event!);
        Navigator.of(context).pop();
      } else {
        provider.addEvent(event);
      }
      Navigator.of(context).pop();
    }
  }
}
