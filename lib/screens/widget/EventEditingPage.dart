import 'package:counter_button/counter_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_picker_widget/time_picker_widget.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:untitled/utils/utils.dart';

import '../../models/Event.dart';
import '../../services/EventProvider.dart';

final key = GlobalKey<CastListState>();
final playerController = TextEditingController();

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

  late DateTime fromDate;
  late DateTime toDate;
  int chosenDuration = 1;
  int guestCounter = 0;
  String gameType = 'Spieltyp: Einzel';
  int place = 1;
  String players = "Patrick";
  TextEditingController textEditingController = TextEditingController();
  TextEditingController infoTextController = TextEditingController();
  CastList stateWidget = CastList(key: key);

  @override
  void initState() {
    super.initState();

    if (widget.event == null) {
      fromDate = DateTime.now();
      fromDate = fromDate
          .subtract(Duration(minutes: fromDate.minute))
          .add(const Duration(hours: 1));
      print("From Date: $fromDate");
      toDate = DateTime.now().add(const Duration(hours: 2));
    } else {
      final event = widget.event!;

      playerController.text = event.player;

      fromDate = event.startTime;
      fromDate = fromDate
          .subtract(Duration(minutes: fromDate.minute))
          .add(const Duration(hours: 1));
      print("From Date: $fromDate");
      toDate = fromDate.add(Duration(hours: event.duration));
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    infoTextController.dispose();
    textEditingController.dispose();
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
                buildPlayer(),
                const SizedBox(height: 12),
                stateWidget,
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
                const SizedBox(height: 12),
                buildInfo(),
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

  List<String> playerList = [
    "Fritz",
    "Gerhard",
    "Johann",
    "Richard",
    "Hermann"
  ];

  ElevatedButton createButton(item) => ElevatedButton.icon(
        // <-- ElevatedButton
        onPressed: () {},
        icon: const Icon(
          Icons.close,
          size: 24.0,
        ),
        label: Text(item),
      );

  Widget buildPlayer() => Autocomplete(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text == '') {
            return const Iterable<String>.empty();
          } else {
            List<String> matches = <String>[];
            matches.addAll(playerList);

            matches.retainWhere((s) {
              return s
                  .toLowerCase()
                  .contains(textEditingValue.text.toLowerCase());
            });

            return matches;
          }
        },
        onSelected: (String selection) {
          key.currentState?.addToCastList(selection);
          (context as Element).reassemble();
          playerController.text = key.currentState!._cast.toString();
          textEditingController.text = "";
        },
        fieldViewBuilder: (BuildContext context,
            TextEditingController fieldTextEditingController,
            FocusNode fieldFocusNode,
            VoidCallback onFieldSubmitted) {
          textEditingController = fieldTextEditingController;
          return TextField(
            controller: fieldTextEditingController,
            focusNode: fieldFocusNode,
            style: const TextStyle(fontWeight: FontWeight.bold),
          );
        },
      );

  int tag = 1;

  Widget buildPlace() => ToggleSwitch(
        initialLabelIndex: 0,
        totalSwitches: 2,
        minWidth: 100,
        labels: const ['Platz 1', 'Platz 2'],
        onToggle: (index) {
          place = index! + 1;
        },
      );

  Widget buildDuration() => ToggleSwitch(
        initialLabelIndex: 0,
        totalSwitches: 2,
        minWidth: 100,
        labels: const ['1 Stunde', '2 Stunden'],
        onToggle: (index) {
          chosenDuration = index! + 1;
        },
      );

  Widget buildGuests() =>
      Row(children: [const Text('Anzahl Gäste'), buildCounterButton()]);

  Widget buildSpielTyp() {
    if (key.currentState == null) {
      return Row(
        children: [Text(gameType)],
      );
    }
    if (guestCounter + key.currentState!._cast.length < 3) {
      gameType = 'Spieltyp: Einzel';
      return Row(
        children: [Text(gameType)],
      );
    } else if (guestCounter + key.currentState!._cast.length > 4) {
      gameType = "Für diese Einstellungen gibt es keinen wählbaren Spieltyp!";
      return SizedBox(
        width: 150,
        child: Text(gameType),
      );
    } else {
      gameType = 'Spieltyp: Doppel';
      return Row(
        children: [Text(gameType)],
      );
    }
  }

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

  Future saveForm() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      //ToDo: Validate and change player counter
      final event = Event(
          start: fromDate,
          player: playerController.text,
          numberOfPlayers: guestCounter + key.currentState!._cast.length,
          playingType: gameType,
          duration: chosenDuration,
          place: place,
          info: infoTextController.text);
      final isEditing = widget.event != null;
      print("Saving Event: ${event.writeOut()}");
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

  buildInfo() {
    return TextField(
      controller: infoTextController,
      decoration: InputDecoration(
          border: InputBorder.none,
          labelText: 'Erweiterte Infos eingeben',
          hintText: 'Ich komme erst ab ...'),
    );
  }
}

class CastList extends StatefulWidget {
  const CastList({required Key key}) : super(key: key);

  @override
  State createState() => CastListState();
}

class CastListState extends State<CastList> {
  final List<String> _cast = [
    "Fritz",
  ];

  addToCastList(String value) {
    _cast.add(value);
    updateList();
    playerController.text = _cast.toString();
  }

  updateList() {
    actorWidgets;
  }

  Iterable<Widget> get actorWidgets {
    return _cast.map((String actor) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Chip(
          label: Text(actor),
          onDeleted: () {
            setState(() {
              if (_cast.length > 1) {
                //ToDo: Change to Current User
                _cast.removeWhere((String entry) {
                  return entry == actor;
                });
              }
              playerController.text = _cast.toString();
            });
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: actorWidgets.toList(),
    );
  }
}
