import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:add_2_calendar/add_2_calendar.dart' as add2calendar;
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/constants.dart';
import 'package:keep_playing_frontend/models/event.dart' as sport_event;
import 'package:keep_playing_frontend/models/user.dart';
import 'package:keep_playing_frontend/widgets/dialogs.dart';
import 'package:keep_playing_frontend/widgets/loading_widgets.dart';
import 'package:keep_playing_frontend/widgets/user_widgets.dart';

import '../../cubit/events_cubit.dart';

class ManageEventView extends StatefulWidget {
  final sport_event.Event event;

  const ManageEventView({super.key, required this.event});

  @override
  State<ManageEventView> createState() => _ManageEventView();
}

class _ManageEventView extends State<ManageEventView> {
  late String _name;

  late String _location;
  late String _details;
  late String _sport;
  late String _role;

  late DateTime _date;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late TimeOfDay _flexibleStartTime;
  late TimeOfDay _flexibleEndTime;
  late int _price;
  late bool _coach;
  late bool _recurring;
  User? _sessionCoach;
  late String selectedSport;
  late String selectedRole;

  TextEditingController startTimeInput = TextEditingController();
  TextEditingController endTimeInput = TextEditingController();

  bool dataWasLoaded = false;

  @override
  void initState() {
    _name = widget.event.name;
    _location = widget.event.location;
    _details = widget.event.details;
    _sport = widget.event.sport;
    _role = widget.event.role;
    _date = widget.event.date;
    _startTime = widget.event.startTime;
    _endTime = widget.event.endTime;
    _flexibleStartTime = widget.event.flexibleStartTime;
    _flexibleEndTime = widget.event.flexibleEndTime;
    _price = widget.event.price;
    _coach = widget.event.coach;
    _recurring = widget.event.recurring;
    _retrieveCoachUser();

    selectedSport = _sport;
    selectedRole = _role;

    startTimeInput.text = const DefaultMaterialLocalizations()
        .formatTimeOfDay(_startTime, alwaysUse24HourFormat: true);
    endTimeInput.text = const DefaultMaterialLocalizations()
        .formatTimeOfDay(_endTime, alwaysUse24HourFormat: true);

    dataWasLoaded = true;

    super.initState();
  }

  _retrieveCoachUser() async {
    User? coach = widget.event.coachPK == null
        ? null
        : await API.user.getUser(widget.event.coachPK!);

    setState(() {
      _sessionCoach = coach;
    });
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
    if (!dataWasLoaded || _sessionCoach == null) {
      return const LoadingScreen();
    }

    final Widget coachInformationCard = Card(
      margin: const EdgeInsets.all(BUTTON_PADDING),
      child:
          CoachInformationListTile(coach: _sessionCoach!, event: widget.event),
    );

    final Widget addToCalendarButton = Container(
      padding: const EdgeInsets.fromLTRB(BUTTON_PADDING, 0, BUTTON_PADDING, 0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: APP_COLOR,
            textStyle: const TextStyle(fontSize: BUTTON_FONT_SIZE)),
        onPressed: () {
          final add2calendar.Event event = add2calendar.Event(
            title: widget.event.name,
            description: widget.event.details,
            location: widget.event.location,
            startDate: widget.event.getStartTimestamp(),
            endDate: widget.event.getEndTimestamp(),
          );
          Add2Calendar.addEvent2Cal(event);
        },
        child: const Text('Add to calendar'),
      ),
    );

    final Widget nameForm = ListTile(
      title: TextFormField(
        initialValue: _name,
        readOnly: false,
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
        value: selectedSport,
        items: SPORTS.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          _sport = newValue!;
          setState(() {
            selectedSport = _sport;
          });
        },
      ),
    );

    final Widget roleForm = ListTile(
      leading: const Icon(Icons.sports),
      title: DropdownButton<String>(
        value: selectedRole,
        items: ROLES.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          _role = newValue!;
          setState(() {
            selectedRole = _role;
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
        initialValue: _details,
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
            initialTime: TimeOfDay.now(),
            initialEntryMode: TimePickerEntryMode.input,
          );
          if (newTime != null) {
            setState(() {
              _startTime = newTime;
              startTimeInput.text = const DefaultMaterialLocalizations()
                  .formatTimeOfDay(_startTime, alwaysUse24HourFormat: true);
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
            initialTime: TimeOfDay.now(),
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
      value: _recurring,
      onChanged: (bool? value) => {
        setState(() {
          _recurring = value!;
        })
      },
      title: const Text('Is the event weekly?'),
    );

    final Widget priceForm = ListTile(
      title: TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        initialValue: _price.toString(),
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

    final Widget cancelEventButton = Container(
      padding: const EdgeInsets.fromLTRB(
          BUTTON_PADDING, BUTTON_PADDING, 0, BUTTON_PADDING),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: CANCEL_BUTTON_COLOR,
            textStyle: const TextStyle(fontSize: BUTTON_FONT_SIZE)),
        onPressed: () {
          final EventsCubit eventsCubit = BlocProvider.of<EventsCubit>(context);
          showDialog(
            context: context,
            builder: (BuildContext buildContext) {
              return BlocProvider<EventsCubit>.value(
                value: eventsCubit,
                child: ConfirmationDialog(
                  title: 'Are you sure that you want to cancel this event?',
                  onNoPressed: () => {
                    Navigator.of(buildContext).pop(true),
                  },
                  onYesPressed: () async {
                    NavigatorState navigator = Navigator.of(buildContext);
                    final EventsCubit eventsCubit =
                        BlocProvider.of<EventsCubit>(context);
                    await API.organiser.cancelEvent(event: widget.event);
                    eventsCubit.retrieveEvents();
                    navigator.pop();
                    navigator.pop();
                  },
                ),
              );
            },
          );
        },
        child: const Text('Cancel Event'),
      ),
    );

    final Widget saveChangesButton = Container(
      padding: const EdgeInsets.fromLTRB(
          0, BUTTON_PADDING, BUTTON_PADDING, BUTTON_PADDING),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: APP_COLOR,
            textStyle: const TextStyle(fontSize: BUTTON_FONT_SIZE)),
        onPressed: () async {
          sport_event.NewEvent newEvent = sport_event.NewEvent(
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
            coach: _coach,
            recurring: _recurring,
            creationStarted: widget.event.creationStarted,
            creationEnded: widget.event.creationEnded,
          );

          NavigatorState navigator = Navigator.of(context);
          final EventsCubit eventsCubit = BlocProvider.of<EventsCubit>(context);
          Response response = await API.organiser.changeEvent(
            event: widget.event,
            newEvent: newEvent,
          );
          if (response.statusCode == HTTP_202_ACCEPTED) {
            eventsCubit.retrieveEvents();
          } else {
            // TODO
          }
          navigator.pop();
        },
        child: const Text('Save Changes'),
      ),
    );

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(title: const Text('Manage Event')),
        body: ListView(
          children: [
            _sessionCoach == null
                ? const SizedBox(height: 0, width: 0)
                : coachInformationCard,
            addToCalendarButton,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [cancelEventButton, saveChangesButton],
            ),
          ],
        ),
      ),
    );
  }
}
