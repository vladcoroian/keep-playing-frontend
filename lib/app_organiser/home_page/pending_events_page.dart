import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/app_organiser/home_page/new_job_button.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:keep_playing_frontend/widgets/events_views.dart';

import 'events/new_event.dart';
import 'events_pending/pending_events_for_day.dart';
import 'events_pending/pending_events_widget.dart';

class PendingEventsPage extends StatefulWidget {
  const PendingEventsPage({Key? key}) : super(key: key);

  @override
  State<PendingEventsPage> createState() => _PendingEventsPageState();
}

class _PendingEventsPageState extends State<PendingEventsPage> {
  int _selectedIndex = 0;
  List<Widget> _buttonOptions = [];

  List<Event> pendingEvents = [];

  _retrievePendingEvents() async {
    List<Event> events =
        await API.events.retrieveFutureEventsWith(pending: true);

    setState(() {
      pendingEvents = events;
    });
  }

  @override
  void initState() {
    _buttonOptions = [
      ListViewButton(
          onTap: () => {
                setState(() {
                  _selectedIndex = 1;
                })
              }),
      CalendarViewButton(
          onTap: () => {
                setState(() {
                  _selectedIndex = 0;
                })
              }),
    ];
    _retrievePendingEvents();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Widget calendarViewOfEvents = CalendarViewOfEvents(
      events: pendingEvents,
      onDaySelected: (DateTime day) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PendingEventsForDayPage(day: day)));
      },
    );

    final Widget listViewOfEvents = ListViewOfEvents(
        events: pendingEvents,
        eventWidgetBuilder: (Event event) => PendingEventWidget(
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
              title: const Text('Pending Events'),
              actions: [_buttonOptions[_selectedIndex]]),
          body: Center(
              child: _selectedIndex == 0
                  ? calendarViewOfEvents
                  : listViewOfEvents),
          floatingActionButton: newJobButton,
        ));
  }
}
