import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:keep_playing_frontend/api_manager.dart';
import 'package:keep_playing_frontend/constants.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:keep_playing_frontend/widgets/buttons.dart';
import 'package:keep_playing_frontend/widgets/dialogs.dart';

import 'event_builder.dart';

class NewEventPage extends StatefulWidget {
  const NewEventPage({Key? key}) : super(key: key);

  @override
  State<NewEventPage> createState() => _NewEventPageState();
}

class _NewEventPageState extends State<NewEventPage> {
  NewEvent newEvent = NewEvent.defaultNewEvent();

  @override
  initState() {
    newEvent.coach = false;
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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(title: const Text('New Event')),
        body: ListView(children: [
          EventBuilder(newEvent: newEvent, isNewEvent: true),
          Center(child: _SubmitButton(
            onPressed: () {
              print(newEvent.toJson());
              final Future<Response> response =
                  API.addNewEvent(newEvent: newEvent);
              Navigator.of(context).pop(response);
            },
          )),
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
