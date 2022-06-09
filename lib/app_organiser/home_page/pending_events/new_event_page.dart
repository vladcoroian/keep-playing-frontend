import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:keep_playing_frontend/widgets/dialogs.dart';

import '../../../constants.dart';
import '../../../widgets/buttons.dart';

class NewEventPage extends StatefulWidget {
  const NewEventPage({Key? key}) : super(key: key);

  @override
  State<NewEventPage> createState() => _NewEventPageState();
}

class _NewEventPageState extends State<NewEventPage> {
  String name = '';
  String location = '';
  String details = '';

  String date = '';
  String start_time = '';
  String end_time ='';

  double price = 0;


  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => ExitDialog(
              context: context,
              title: 'Are you sure that you want to exit?',
              text: 'You haven\'t finished editing the new event'
          ),
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
          _selectDateForm(),
          _selectStartTimeForm(),
          _selectEndTimeForm(),
          Center(
              child: SubmitButton(
            onPressed: () {},
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
            icon: Icon(Icons.sports),
            hintText: 'Enter the title',
            labelText: 'Title',
          ),
        ));
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
        ));
  }

  TimeOfDay _startTime = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay _endTime = TimeOfDay(hour: 0, minute: 0);

  void _selectStartTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (newTime != null) {
      setState(() {
        _startTime = newTime;
      });
    }
  }

  void _selectEndTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _endTime,
    );
    if (newTime != null) {
      setState(() {
        _endTime = newTime;
      });
    }
  }
  TextEditingController startTimeInput = TextEditingController();
  TextEditingController endTimeInput = TextEditingController();

  @override
  void initState() {
    startTimeInput.text = "";
    endTimeInput.text = "";
    super.initState();
  }

  Widget _selectStartTimeForm() {
    return Container(
      padding: const EdgeInsets.all(DEFAULT_PADDING),
      child: TextField(
        controller: startTimeInput,
        decoration: const InputDecoration(
            icon: Icon(Icons.access_time),
            labelText: "Enter Start Time"
        ),
        readOnly: true,
        onTap: () async {
          final TimeOfDay? newTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          if (newTime != null) {
            setState(() {
              _startTime = newTime;
              DateTime parsedTime = DateFormat.jm().parse(_startTime.format(context).toString());
              startTimeInput.text = DateFormat('HH:mm').format(parsedTime);
            });
          }
        }
      )
    );
  }

  Widget _selectEndTimeForm() {
    return Container(
        padding: const EdgeInsets.all(DEFAULT_PADDING),
        child: TextField(
            controller: endTimeInput,
            decoration: const InputDecoration(
                icon: Icon(Icons.access_time),
                labelText: "Enter End Time"
            ),
            readOnly: true,
            onTap: () async {
              final TimeOfDay? newTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (newTime != null) {
                setState(() {
                  _endTime = newTime;
                  DateTime parsedTime = DateFormat.jm().parse(_endTime.format(context).toString());
                  endTimeInput.text = DateFormat('HH:mm').format(parsedTime);
                });
              }
            }
        )
    );
  }
}
