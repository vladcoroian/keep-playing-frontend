import 'dart:convert';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:keep_playing_frontend/api_manager.dart';
import 'package:keep_playing_frontend/widgets/dialogs.dart';

import '../constants.dart';
import 'buttons.dart';

class NewEventPage extends StatefulWidget {
  const NewEventPage({Key? key}) : super(key: key);

  @override
  State<NewEventPage> createState() => _NewEventPageState();
}

class _NewEventPageState extends State<NewEventPage> {
  String _name = '';
  String _location = '';
  String _details = '';

  String _date = '';
  TimeOfDay _startTime = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 0, minute: 0);

  int _price = 0;

  TextEditingController startTimeInput = TextEditingController();
  TextEditingController endTimeInput = TextEditingController();

  @override
  void initState() {
    startTimeInput.text = "";
    endTimeInput.text = "";
    super.initState();
  }

  Client client = http.Client();

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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(title: const Text('New Event')),
        body: ListView(children: [
          _writeTitleForm(),
          _writeLocationForm(),
          _writeDetailsForm(),
          _selectDateForm(),
          _selectStartTimeForm(),
          _selectEndTimeForm(),
          _selectPriceForm(),
          Center(child: _SubmitButton(
            onPressed: () {
              client.post(API.addEventLink(),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, String>{
                    "name": _name,
                    'location': _location,
                    'details': _details,
                    'date': _date,
                    'start_time': const DefaultMaterialLocalizations()
                        .formatTimeOfDay(_startTime,
                            alwaysUse24HourFormat: true),
                    'end_time': const DefaultMaterialLocalizations()
                        .formatTimeOfDay(_endTime, alwaysUse24HourFormat: true),
                    // TODO : Remove this cast.
                    'price': _price.toString(),
                    'coach': 'False'
                  }));
              Navigator.pop(context);
            },
          )),
        ]),
      ),
    );
  }

  Widget _writeTitleForm() {
    return Container(
        padding: const EdgeInsets.all(DEFAULT_PADDING),
        child: TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.sports_soccer),
              hintText: 'Enter the title',
              labelText: 'Title',
            ),
            onChanged: (text) {
              _name = text;
            }));
  }

  Widget _writeLocationForm() {
    return Container(
        padding: const EdgeInsets.all(DEFAULT_PADDING),
        child: TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.location_on),
              hintText: 'Enter the location',
              labelText: 'Location',
            ),
            onChanged: (text) {
              _location = text;
            }));
  }

  Widget _writeDetailsForm() {
    return Container(
        padding: const EdgeInsets.all(DEFAULT_PADDING),
        child: TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.details),
              hintText: 'Enter details',
              labelText: 'Details',
            ),
            onChanged: (text) {
              _details = text;
            }));
  }

  Widget _selectDateForm() {
    return Container(
        padding: const EdgeInsets.all(DEFAULT_PADDING),
        child: DateTimeField(
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
            _date = DateFormat('yyyy-MM-dd').format(date!);
          },
        ));
  }

  Widget _selectStartTimeForm() {
    return Container(
        padding: const EdgeInsets.all(DEFAULT_PADDING),
        child: TextField(
            controller: startTimeInput,
            decoration: const InputDecoration(
                icon: Icon(Icons.access_time), labelText: "Enter Start Time"),
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
  }

  Widget _selectEndTimeForm() {
    return Container(
        padding: const EdgeInsets.all(DEFAULT_PADDING),
        child: TextField(
            controller: endTimeInput,
            decoration: const InputDecoration(
                icon: Icon(Icons.access_time), labelText: "Enter End Time"),
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
  }

  Widget _selectPriceForm() {
    return Container(
        padding: const EdgeInsets.all(DEFAULT_PADDING),
        child: TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.price_change),
              hintText: 'Enter the price',
              labelText: 'Price',
            ),
            onChanged: (text) {
              // TODO: Remove this cast.
              _price = int.parse(text);
            }));
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
