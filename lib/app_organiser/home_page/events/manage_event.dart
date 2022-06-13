import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:keep_playing_frontend/api_manager.dart';
import 'package:keep_playing_frontend/constants.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:keep_playing_frontend/widgets/buttons.dart';
import 'package:keep_playing_frontend/widgets/dialogs.dart';

class ManageEventPage extends StatefulWidget {
  final Event event;

  const ManageEventPage({super.key, required this.event});

  @override
  State<ManageEventPage> createState() => _ManageEventPageState();
}

class _ManageEventPageState extends State<ManageEventPage> {
  late String _name;
  late String _location;
  late String _details = '';
  late DateTime _date;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late TimeOfDay _flexibleStartTime;
  late TimeOfDay _flexibleEndTime;
  late int _price;
  late bool _coach;

  TextEditingController startTimeInput = TextEditingController();
  TextEditingController endTimeInput = TextEditingController();

  @override
  void initState() {
    _name = widget.event.name;
    _location = widget.event.location;
    _details = widget.event.details;
    _date = widget.event.date;
    _startTime = widget.event.startTime;
    _endTime = widget.event.endTime;
    _flexibleStartTime = widget.event.flexibleStartTime;
    _flexibleEndTime = widget.event.flexibleEndTime;
    _price = widget.event.price;
    _coach = widget.event.coach;

    startTimeInput.text = const DefaultMaterialLocalizations()
        .formatTimeOfDay(_startTime, alwaysUse24HourFormat: true);
    endTimeInput.text = const DefaultMaterialLocalizations()
        .formatTimeOfDay(_endTime, alwaysUse24HourFormat: true);

    super.initState();
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => ExitDialog(
              context: context,
              title: 'Are you sure that you want to exit?',
              text: 'You haven\'t finished editing the event'),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(title: const Text('Edit Event')),
        body: ListView(children: [
          _showName(),
          _writeLocationForm(),
          _writeDetailsForm(),
          _selectDateForm(),
          _selectStartTimeForm(),
          _selectEndTimeForm(),
          _selectPriceForm(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _CancelEventButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ConfirmationDialog(
                          title: 'Are you sure you want to cancel this event?',
                          onNoPressed: () {
                            Navigator.pop(context);
                          },
                          onYesPressed: () {
                            API.cancelEvent(event: widget.event);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                        );
                      });
                },
              ),
              _SaveChangesButton(
                onPressed: () {
                  NewEvent newEvent = NewEvent(
                      name: _name,
                      location: _location,
                      details: _details,
                      date: _date,
                      startTime: _startTime,
                      endTime: _endTime,
                      flexibleStartTime: _flexibleStartTime,
                      flexibleEndTime: _flexibleEndTime,
                      price: _price,
                      coach: _coach);
                  final Future<Response> response =
                      API.changeEvent(event: widget.event, newEvent: newEvent);
                  Navigator.of(context).pop(response);
                },
              )
            ],
          )
        ]),
      ),
    );
  }

  Widget _showName() {
    return Container(
        padding: const EdgeInsets.all(DEFAULT_PADDING),
        child: TextFormField(
          initialValue: _name,
          readOnly: true,
          decoration: const InputDecoration(
            icon: Icon(Icons.sports_soccer),
            hintText: 'Enter the name',
            labelText: 'Name',
          ),
        ));
  }

  Widget _writeLocationForm() {
    return Container(
        padding: const EdgeInsets.all(DEFAULT_PADDING),
        child: TextFormField(
            initialValue: _location,
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
            initialValue: _details,
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
          initialValue: _date,
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
            initialValue: _price.toString(),
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

class _SaveChangesButton extends ColoredButton {
  const _SaveChangesButton({Key? key, required super.onPressed})
      : super(
          key: key,
          text: 'Save Changes',
          color: APP_COLOR,
        );
}

class _CancelEventButton extends ColoredButton {
  const _CancelEventButton({Key? key, required super.onPressed})
      : super(
          key: key,
          text: 'Cancel Event',
          color: CANCEL_BUTTON_COLOR,
        );
}
