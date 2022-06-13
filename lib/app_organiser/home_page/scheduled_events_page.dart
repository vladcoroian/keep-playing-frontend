import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keep_playing_frontend/api_manager.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:keep_playing_frontend/widgets/events_views.dart';

import 'events/new_event.dart';
import 'events_scheduled/scheduled_event_widget.dart';
import 'events_scheduled/scheduled_events_for_day.dart';
import 'new_job_button.dart';

class ScheduledEventsPage extends StatefulWidget {
  const ScheduledEventsPage({Key? key}) : super(key: key);

  @override
  State<ScheduledEventsPage> createState() => _ScheduledEventsPageState();
}

class _ScheduledEventsPageState extends State<ScheduledEventsPage> {
  int _selectedIndex = 0;
  List<Widget> _buttonOptions = [];

  List<Event> scheduledEvents = [];

  _retrieveScheduledEvents() async {
    List<Event> events = await API.retrieveScheduledEvents();

    setState(() {
      scheduledEvents = events;
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
    _retrieveScheduledEvents();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () async {
          _retrieveScheduledEvents();
        },
        child: Scaffold(
            appBar: AppBar(
                title: const Text('Scheduled Events'),
                actions: [_buttonOptions[_selectedIndex]]),
            body: Center(
                child: _selectedIndex == 0
                    ? CalendarViewOfEvents(
                        events: scheduledEvents,
                        onDaySelected: (DateTime day) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ScheduledEventsForDayPage(day: day)));
                        },
                      )
                    : ListViewOfEvents(
                        events: scheduledEvents,
                        eventWidgetBuilder: (Event event) =>
                            ScheduledEventWidget(
                              event: event,
                            ))),
            floatingActionButton: NewJobButton(
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
                            body["coach"] =
                                body["coach"].toLowerCase() == 'true';
                            scheduledEvents.add(
                                Event(eventModel: EventModel.fromJson(body)));
                          })
                        }
                    })
              },
            )));
  }
}
