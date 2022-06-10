import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:keep_playing_frontend/app_organiser/home_page/manage_event_page.dart';

import 'package:keep_playing_frontend/app_organiser/home_page/pending_events/new_event_page.dart';
import 'package:keep_playing_frontend/constants.dart';
import 'package:keep_playing_frontend/widgets/buttons.dart';
import 'package:keep_playing_frontend/widgets/event_widgets.dart';

import '../../models/event.dart';
import '../../urls.dart';

class PendingEventsPage extends StatefulWidget {
  const PendingEventsPage({Key? key}) : super(key: key);

  @override
  State<PendingEventsPage> createState() => _PendingEventsPageState();
}

class _PendingEventsPageState extends State<PendingEventsPage> {
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
        appBar: AppBar(title: const Text('Small Change')),
        body: RefreshIndicator(
            onRefresh: () async {
              _retrieveEvents();
            },
            child: ListView.builder(
              itemCount: events.length,
              itemBuilder: (BuildContext context, int index) {
                if (events[index].coach) {
                  return const SizedBox(width: 0, height: 0);
                }
                return PendingEventWidget(event: events[index]);
              },
            )),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NewEventPage()),
            )
          },
          extendedTextStyle:
              const TextStyle(fontSize: DEFAULT_FONT_SIZE_BUTTONS),
          tooltip: 'Increment',
          icon: const Icon(Icons.add),
          label: const Text("New Job"),
        ));
  }
}

class PendingEventWidget extends StatelessWidget {
  final Event event;

  const PendingEventWidget({super.key, required this.event});

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
