import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:keep_playing_frontend/widgets/events_views.dart';

import 'events/new_event.dart';
import 'events_past/past_events_widget.dart';
import 'events_past/past_events_for_day.dart';
import 'new_job_button.dart';

class PastEventsPage extends StatefulWidget {
  const PastEventsPage({Key? key}) : super(key: key);

  @override
  State<PastEventsPage> createState() => _PastEventsPageState();
}

class _PastEventsPageState extends State<PastEventsPage> {
  int _selectedIndex = 0;
  List<Widget> _buttonOptions = [];

  List<Event> pastEvents = [];

  _retrievePastEvents() async {
    List<Event> events = await API.events.retrieveEventsBefore();

    setState(() {
      pastEvents = events;
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
    _retrievePastEvents();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Widget calendarViewOfEvents = CalendarViewOfEvents(
      events: pastEvents,
      onDaySelected: (DateTime day) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PastEventsForDayPage(day: day)));
      },
    );

    final Widget listViewOfEvents = ListViewOfEvents(
        events: pastEvents,
        eventWidgetBuilder: (Event event) => PastEventWidget(
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
                // pastEvents
                //     .add(Event(eventModel: EventModel.fromJson(body)));
              })
            }
        })
      },
    );

    return RefreshIndicator(
        onRefresh: () async {
          _retrievePastEvents();
        },
        child: Scaffold(
            appBar: AppBar(
                title: const Text('Past Events'),
                actions: [_buttonOptions[_selectedIndex]]),
            body: Center(
                child: _selectedIndex == 0
                    ? calendarViewOfEvents
                    : listViewOfEvents),
            floatingActionButton: newJobButton));
  }
}
