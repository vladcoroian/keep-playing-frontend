import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:keep_playing_frontend/widgets/events_views.dart';

import 'event_cards/pending_event_card.dart';
import 'events/new_event.dart';
import 'events_for_a_day/pending_events_for_day.dart';
import 'new_job_button.dart';

class PendingEventsPage extends StatefulWidget {
  const PendingEventsPage({Key? key}) : super(key: key);

  @override
  State<PendingEventsPage> createState() => _PendingEventsPageState();
}

class _PendingEventsPageState extends State<PendingEventsPage> {
  int _selectedIndex = 0;

  List<Event> pendingEvents = [];

  _retrievePendingEvents() async {
    List<Event> events = [];
    // await API.events.retrieveEvents(past: false, pending: true);

    setState(() {
      pendingEvents = events;
    });
  }

  @override
  void initState() {
    _retrievePendingEvents();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Widget appBarButton = _selectedIndex == 0
        ? ListViewButton(
            onTap: () => {
                  setState(() {
                    _selectedIndex = 1;
                  })
                })
        : CalendarViewButton(
            onTap: () => {
                  setState(() {
                    _selectedIndex = 0;
                  })
                });

    final Widget viewOfEvents = _selectedIndex == 0
        ? CalendarViewOfEvents(
            events: pendingEvents,
            onDaySelected: (DateTime day) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PendingEventsForDayPage(day: day)));
            },
          )
        : ListViewOfEvents(
            events: pendingEvents,
            eventWidgetBuilder: (Event event) => PendingEventCard(
                  event: event,
                ));

    final Widget newJobButton = NewJobButton(
      context: context,
      onPressed: () => {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NewEventPage()),
        ).then((value) => {
              if (value != null)
                {
                  setState(() {
                    final body = jsonDecode(value.body);
                    body["price"] = int.parse(body["price"]);
                    body["coach"] = body["coach"].toLowerCase() == 'true';
//                     pendingEvents
//                         .add(Event(eventModel: EventModel.fromJson(body)));
                  })
                }
            })
      },
    );

    return RefreshIndicator(
        onRefresh: () async {
          _retrievePendingEvents();
        },
        child: Scaffold(
          appBar: AppBar(
              title: const Text('Pending Events'), actions: [appBarButton]),
          body: Center(
            child: viewOfEvents,
          ),
          floatingActionButton: newJobButton,
        ));
  }
}
