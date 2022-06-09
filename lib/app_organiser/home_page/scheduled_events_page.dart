import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:keep_playing_frontend/app_organiser/home_page/manage_event_page.dart';

import 'package:keep_playing_frontend/widgets/buttons.dart';
import 'package:keep_playing_frontend/widgets/event_widgets.dart';

import '../../models/event.dart';
import '../../urls.dart';

class ScheduledEventsPage extends StatefulWidget {
  const ScheduledEventsPage({Key? key}) : super(key: key);

  @override
  State<ScheduledEventsPage> createState() => _ScheduledEventsPageState();
}

class _ScheduledEventsPageState extends State<ScheduledEventsPage> {
  Client client = http.Client();
  List<Event> events = [];

  @override
  void initState() {
    _retrieveEvents();
    super.initState();
  }

  _retrieveEvents() async {
    events = [];
    List response = json.decode((await client.get(Uri.parse(URL.EVENTS))).body);
    for (var element in response) {
      events.add(Event.fromJson(element));
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pending Events')),
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
        rightButton: ManageButton(
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
