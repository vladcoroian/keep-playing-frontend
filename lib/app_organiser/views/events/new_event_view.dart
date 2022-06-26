import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/app_organiser/cubit/events_cubit.dart';
import 'package:keep_playing_frontend/app_organiser/cubit/organiser_cubit.dart';
import 'package:keep_playing_frontend/constants.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:keep_playing_frontend/widgets/buttons.dart';
import 'package:keep_playing_frontend/widgets/dialogs.dart';

class NewEventView extends StatefulWidget {
  final DateTime? date;

  const NewEventView({Key? key, this.date}) : super(key: key);

  @override
  State<NewEventView> createState() => _NewEventViewState();
}

class _NewEventViewState extends State<NewEventView> {
  String _name = '';
  String _location = '';
  String _details = '';
  String _sport = '';
  String _role = '';

  DateTime _date = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();

  bool recurring = false;
  int? _price;

  final DateTime _creationStarted = DateTime.now();

  final TimeOfDay _flexibleStartTime = const TimeOfDay(hour: 0, minute: 0);
  final TimeOfDay _flexibleEndTime = const TimeOfDay(hour: 0, minute: 0);

  TextEditingController startTimeInput = TextEditingController();
  TextEditingController endTimeInput = TextEditingController();

  bool defaultValuesAreLoaded = false;

  @override
  void initState() {
    _date = widget.date == null ? DateTime.now() : widget.date!;
    startTimeInput.text = "";
    endTimeInput.text = "";
    super.initState();
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (_) => const ExitDialog(
              title: 'Are you sure that you want to exit?',
              text: 'You haven\'t finished editing the new event'),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    if (!defaultValuesAreLoaded) {
      _sport = BlocProvider.of<OrganiserCubit>(context).state.defaultSport;
      _role = BlocProvider.of<OrganiserCubit>(context).state.defaultRole;
      _location =
          BlocProvider.of<OrganiserCubit>(context).state.defaultLocation;
      _price = BlocProvider.of<OrganiserCubit>(context).state.defaultPrice;

      defaultValuesAreLoaded = true;
    }

    final Widget nameForm = ListTile(
      title: TextFormField(
        decoration: const InputDecoration(
          icon: Icon(Icons.title),
          hintText: 'Enter the name',
          labelText: 'Name',
        ),
        onChanged: (text) {
          _name = text;
        },
      ),
    );

    final Widget sportForm = ListTile(
      leading: const Icon(Icons.sports_soccer),
      title: DropdownButton<String>(
        value: _sport == "" ? null : _sport,
        items: SPORTS.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        hint: const Text('Enter sport'),
        onChanged: (String? newValue) {
          setState(() {
            _sport = newValue!;
          });
        },
      ),
    );

    final Widget roleForm = ListTile(
      leading: const Icon(Icons.sports),
      title: DropdownButton<String>(
        value: _role == "" ? null : _role,
        items: ROLES.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        hint: const Text('Enter role'),
        onChanged: (String? newValue) {
          setState(() {
            _role = newValue!;
          });
        },
      ),
    );

    final Widget locationForm = ListTile(
      title: TextFormField(
        initialValue: _location,
        decoration: const InputDecoration(
          icon: Icon(Icons.location_on),
          hintText: 'Enter the location',
          labelText: 'Location',
        ),
        onChanged: (text) {
          _location = text;
        },
      ),
    );

    final Widget detailsForm = ListTile(
      title: TextFormField(
        decoration: const InputDecoration(
          icon: Icon(Icons.details),
          hintText: 'Enter details',
          labelText: 'Details',
        ),
        onChanged: (text) {
          _details = text;
        },
      ),
    );

    final Widget dateForm = ListTile(
      title: DateTimeField(
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
      ),
    );

    final Widget startTimeForm = ListTile(
      title: TextField(
        controller: startTimeInput,
        decoration: const InputDecoration(
            icon: Icon(Icons.access_time), labelText: "Start Time"),
        readOnly: true,
        onTap: () async {
          final TimeOfDay? newTime = await showTimePicker(
            context: context,
            initialTime: _startTime,
            initialEntryMode: TimePickerEntryMode.input,
          );
          if (newTime != null) {
            setState(() {
              _startTime = newTime;
              startTimeInput.text = const DefaultMaterialLocalizations()
                  .formatTimeOfDay(_startTime, alwaysUse24HourFormat: true);
              if (endTimeInput.text == '') {
                _endTime = newTime;
                endTimeInput.text = const DefaultMaterialLocalizations()
                    .formatTimeOfDay(_endTime, alwaysUse24HourFormat: true);
              }
            });
          }
        },
      ),
    );

    final Widget endTimeForm = ListTile(
      title: TextField(
        controller: endTimeInput,
        decoration: const InputDecoration(
            icon: Icon(Icons.access_time), labelText: "End Time"),
        readOnly: true,
        onTap: () async {
          final TimeOfDay? newTime = await showTimePicker(
            context: context,
            initialTime: _endTime,
            initialEntryMode: TimePickerEntryMode.input,
          );
          if (newTime != null) {
            setState(() {
              _endTime = newTime;
              endTimeInput.text = const DefaultMaterialLocalizations()
                  .formatTimeOfDay(_endTime, alwaysUse24HourFormat: true);
            });
          }
        },
      ),
    );

    final Widget recurringForm = CheckboxListTile(
      value: recurring,
      onChanged: (bool? value) => {
        setState(() {
          recurring = value!;
        })
      },
      title: const Text('Is the event weekly?'),
    );

    final Widget priceForm = ListTile(
      title: TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        initialValue: _price?.toString(),
        decoration: const InputDecoration(
          icon: Icon(Icons.price_change),
          hintText: 'Enter the fee',
          labelText: 'Fee',
        ),
        onChanged: (text) {
          // TODO: Remove this cast.
          _price = int.parse(text);
        },
      ),
    );

    final Widget submitButton = Container(
      padding: const EdgeInsets.all(BUTTON_PADDING),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: APP_COLOR,
            textStyle: const TextStyle(fontSize: BUTTON_FONT_SIZE)),
        onPressed: () async {
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
            price: _price!,
            coach: false,
            recurring: recurring,
            creationStarted: _creationStarted,
            creationEnded: DateTime.now(),
          );

          NavigatorState navigator = Navigator.of(context);
          final EventsCubit eventsCubit = BlocProvider.of<EventsCubit>(context);

          Response response =
              await API.organiser.addNewEvent(newEvent: newEvent);
          if (response.statusCode == HTTP_201_CREATED) {
            eventsCubit.retrieveEvents();
            navigator.pop();
          } else {
            showDialog(
              context: context,
              builder: (_) => const RequestFailedDialog(),
              barrierDismissible: false,
            );
          }
        },
        child: const Text('Submit'),
      ),
    );

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(title: const Text('New Event')),
        body: ListView(
          children: [
            nameForm,
            sportForm,
            roleForm,
            locationForm,
            detailsForm,
            dateForm,
            startTimeForm,
            endTimeForm,
            recurringForm,
            priceForm,
            Center(child: submitButton),
          ],
        ),
      ),
    );
  }
}
