import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/constants.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:keep_playing_frontend/widgets/buttons.dart';
import 'package:keep_playing_frontend/widgets/dialogs.dart';

class NewEventPage extends StatefulWidget {
  const NewEventPage({Key? key}) : super(key: key);

  @override
  State<NewEventPage> createState() => _NewEventPageState();
}

class _NewEventPageState extends State<NewEventPage> {
  String _name = '';
  String _location = '';
  String _details = '';
  String _sport = '';
  String _role = '';
  DateTime _date = DateTime.now();
  TimeOfDay _startTime = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay _flexibleStartTime = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay _flexibleEndTime = const TimeOfDay(hour: 0, minute: 0);
  int _price = 0;

  String? selectedSport = null;
  String? selectedRole = null;


  TextEditingController startTimeInput = TextEditingController();
  TextEditingController endTimeInput = TextEditingController();

  @override
  void initState() {
    startTimeInput.text = "";
    endTimeInput.text = "";
    super.initState();
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => ExitDialog(
              context: context,
              title: 'Are you sure that you want to exit?',
              text: 'You haven\'t finished editing the new event'),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {

    // Form Widgets

    final Widget nameForm = ListTile(
        title: TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.sports_soccer),
              hintText: 'Enter the name',
              labelText: 'Name',
            ),
            onChanged: (text) {
              _name = text;
            }));

    final Widget locationForm = ListTile(
        title: TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.location_on),
              hintText: 'Enter the location',
              labelText: 'Location',
            ),
            onChanged: (text) {
              _location = text;
            }));

    final Widget detailsForm = ListTile(
        title: TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.details),
              hintText: 'Enter details',
              labelText: 'Details',
            ),
            onChanged: (text) {
              _details = text;
            }));

    final Widget dateForm = ListTile(
        title: DateTimeField(
      decoration: const InputDecoration(
        icon: Icon(Icons.date_range),
        hintText: 'Enter the date',
        labelText: 'Date',
      ),
      format: DateFormat("dd-MMMM-yyyy"),
      onShowPicker: (context, currentValue) {
        return showDatePicker(
            context: context,
            firstDate: DateTime.now(),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2100));
      },
      onChanged: (date) {
        _date = date!;
      },
    ));

    final Widget startTimeForm = ListTile(
        title: TextField(
            controller: startTimeInput,
            decoration: const InputDecoration(
                icon: Icon(Icons.access_time), labelText: "Start Time"),
            readOnly: true,
            onTap: () async {
              final TimeOfDay? newTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (newTime != null) {
                setState(() {
                  _startTime = newTime;
                  startTimeInput.text = const DefaultMaterialLocalizations()
                      .formatTimeOfDay(_startTime, alwaysUse24HourFormat: true);
                });
              }
            }));

    final Widget endTimeForm = ListTile(
        title: TextField(
            controller: endTimeInput,
            decoration: const InputDecoration(
                icon: Icon(Icons.access_time), labelText: "End Time"),
            readOnly: true,
            onTap: () async {
              final TimeOfDay? newTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (newTime != null) {
                setState(() {
                  _endTime = newTime;
                  endTimeInput.text = const DefaultMaterialLocalizations()
                      .formatTimeOfDay(_endTime, alwaysUse24HourFormat: true);
                });
              }
            }));

    final Widget priceForm = ListTile(
        title: TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.price_change),
              hintText: 'Enter the price',
              labelText: 'Price',
            ),
            onChanged: (text) {
              // TODO: Remove this cast.
              _price = int.parse(text);
            }));

    final Widget sportForm = DropdownButton<String>(
        value: selectedSport,
        items: SPORTS.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
               value: value,
                child: Text(value),
             );
        }).toList(),
        hint: Text('Enter sport'),
        onChanged: (String? newValue) {
          _sport = newValue!;
          setState(() {
             selectedSport = _sport;
          });
        }
    );

    final Widget roleForm = DropdownButton<String>(
        value: selectedRole,
        items: ROLES.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        hint: Text('Enter role'),
        onChanged: (String? newValue) {
          _role = newValue!;
          setState(() {
            selectedRole = _role;
          });
        }
    );

    // Form Submission Widget

    final Widget submitButton = _SubmitButton(
      onPressed: () {
        NewEvent newEvent = NewEvent(
            name: _name,
            location: _location,
            details: _details,
            sport: _sport,
            role: _role,
            date: _date,
            startTime: _startTime,
            endTime: _endTime,
            flexibleStartTime: _flexibleStartTime,
            flexibleEndTime: _flexibleEndTime,
            price: _price,
            coach: false);
        final Future<Response> response =
            API.events.addNewEvent(newEvent: newEvent);
        Navigator.of(context).pop(response);
      },
    );

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(title: const Text('New Event')),
        body: ListView(children: [
          nameForm,
          locationForm,
          detailsForm,
          dateForm,
          startTimeForm,
          endTimeForm,
          priceForm,
          sportForm,
          roleForm,
          Center(child: submitButton),
        ]),
      ),
    );
  }
}

class _SubmitButton extends ColoredButton {
  const _SubmitButton({Key? key, required super.onPressed})
      : super(
          key: key,
          text: 'Submit',
          color: APP_COLOR,
        );
}
