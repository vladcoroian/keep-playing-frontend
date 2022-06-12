import 'package:flutter/material.dart';
import 'package:keep_playing_frontend/constants.dart';
import 'package:keep_playing_frontend/widgets/event_widgets.dart';
import 'package:keep_playing_frontend/widgets/event_manage-page.dart';
import 'package:keep_playing_frontend/widgets/buttons.dart';

import '../../models/event.dart';
import '../../api-manager.dart';

class ScheduledEventsPage extends StatefulWidget {
  const ScheduledEventsPage({Key? key}) : super(key: key);

  @override
  State<ScheduledEventsPage> createState() => _ScheduledEventsPageState();
}

class _ScheduledEventsPageState extends State<ScheduledEventsPage> {
  List<Event> events = [];

  @override
  void initState() {
    _retrieveEvents();
    super.initState();
  }

  _retrieveEvents() async {
    List<Event> retrievedEvents = await API.retrieveEvents();

    setState(() {
      events = retrievedEvents;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scheduled Events')),
      body: RefreshIndicator(
          onRefresh: () async {
            _retrieveEvents();
          },
          child: ListView.builder(
            itemCount: events.length,
            itemBuilder: (BuildContext context, int index) {
              if (events[index].coach) {
                return ScheduledEventWidget(event: events[index]);
              }
              return const SizedBox(width: 0, height: 0);
            },
          )),
    );
  }
}

class ScheduledEventWidget extends StatelessWidget {
  final Event event;

  const ScheduledEventWidget({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return EventWidget(
        event: event,
        leftButton: const SizedBox(width: 0, height: 0),
        rightButton: _ManageButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ManageEventPage(event: event)),
            );
          },
        ));
  }
}

class _ManageButton extends ColoredButton {
  const _ManageButton({Key? key, required super.onPressed})
      : super(
          key: key,
          text: 'Manage',
          color: APP_COLOR,
        );
}
