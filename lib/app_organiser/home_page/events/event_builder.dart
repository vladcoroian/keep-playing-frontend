import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keep_playing_frontend/constants.dart';
import 'package:keep_playing_frontend/models/event.dart';

class EventBuilder extends StatefulWidget {
  final CustomizeEvent customizeEvent;
  final bool isNewEvent;

  const EventBuilder(
      {Key? key, required this.customizeEvent, required this.isNewEvent})
      : super(key: key);

  @override
  State<EventBuilder> createState() => _EventBuilderState();
}

class _EventBuilderState extends State<EventBuilder> {
  TextEditingController startTimeInput = TextEditingController();
  TextEditingController endTimeInput = TextEditingController();

  @override
  void initState() {
    startTimeInput.text = widget.isNewEvent
        ? ''
        : const DefaultMaterialLocalizations().formatTimeOfDay(
            widget.customizeEvent.startTime,
            alwaysUse24HourFormat: true);
    endTimeInput.text = widget.isNewEvent
        ? ''
        : const DefaultMaterialLocalizations().formatTimeOfDay(
            widget.customizeEvent.endTime,
            alwaysUse24HourFormat: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _writeNameForm(),
      _writeLocationForm(),
      _writeDetailsForm(),
      _selectDateForm(),
      _selectStartTimeForm(),
      _selectEndTimeForm(),
      _selectPriceForm(),
    ]);
  }

  Widget _writeNameForm() {
    return Container(
        padding: const EdgeInsets.all(DEFAULT_PADDING),
        child: TextFormField(
            initialValue: widget.isNewEvent ? null : widget.customizeEvent.name,
            decoration: const InputDecoration(
              icon: Icon(Icons.sports_soccer),
              hintText: 'Enter the name',
              labelText: 'Name',
            ),
            onChanged: (text) {
              widget.customizeEvent.name = text;
            }));
  }

  Widget _writeLocationForm() {
    return Container(
        padding: const EdgeInsets.all(DEFAULT_PADDING),
        child: TextFormField(
            initialValue:
                widget.isNewEvent ? null : widget.customizeEvent.location,
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
            initialValue:
                widget.isNewEvent ? null : widget.customizeEvent.details,
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
          initialValue: widget.isNewEvent ? null : widget.customizeEvent.date,
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
            controller: widget.isNewEvent ? null : startTimeInput,
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
                      .formatTimeOfDay(widget.customizeEvent.startTime,
                          alwaysUse24HourFormat: true);
                });
              }
            }));
  }

  Widget _selectEndTimeForm() {
    return Container(
        padding: const EdgeInsets.all(DEFAULT_PADDING),
        child: TextField(
            controller: widget.isNewEvent ? null : endTimeInput,
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
                      .formatTimeOfDay(widget.customizeEvent.endTime,
                          alwaysUse24HourFormat: true);
                });
              }
            }));
  }

  Widget _selectPriceForm() {
    return Container(
        padding: const EdgeInsets.all(DEFAULT_PADDING),
        child: TextFormField(
            initialValue: widget.isNewEvent
                ? null
                : widget.customizeEvent.price.toString(),
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
