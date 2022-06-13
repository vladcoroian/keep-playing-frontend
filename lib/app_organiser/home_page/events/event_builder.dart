import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keep_playing_frontend/constants.dart';
import 'package:keep_playing_frontend/models/event.dart';

class EventBuilder extends StatefulWidget {
  final CustomizeEvent customizeEvent;

  const EventBuilder({Key? key, required this.customizeEvent}) : super(key: key);

  @override
  State<EventBuilder> createState() => _EventBuilderState();
}

class _EventBuilderState extends State<EventBuilder> {

  TextEditingController startTimeInput = TextEditingController();
  TextEditingController endTimeInput = TextEditingController();

  @override
  void initState() {
    startTimeInput.text = "";
    endTimeInput.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _writeTitleForm(),
      _writeLocationForm(),
      _writeDetailsForm(),
      _selectDateForm(),
      _selectStartTimeForm(),
      _selectEndTimeForm(),
      _selectPriceForm(),
    ]);
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
              widget.customizeEvent.name = text;
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
              widget.customizeEvent.location = text;
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
              widget.customizeEvent.details = text;
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
            widget.customizeEvent.date = date!;
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
                  widget.customizeEvent.startTime = newTime;
                  startTimeInput.text = const DefaultMaterialLocalizations()
                      .formatTimeOfDay(widget.customizeEvent.startTime, alwaysUse24HourFormat: true);
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
                  widget.customizeEvent.endTime = newTime;
                  endTimeInput.text = const DefaultMaterialLocalizations()
                      .formatTimeOfDay(widget.customizeEvent.endTime, alwaysUse24HourFormat: true);
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
              widget.customizeEvent.price = int.parse(text);
            }));
  }
}
