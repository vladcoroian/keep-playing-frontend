import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keep_playing_frontend/api_manager.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:keep_playing_frontend/widgets/event_widgets.dart';
import 'package:keep_playing_frontend/widgets/events_pages.dart';
import 'package:keep_playing_frontend/widgets/events_views.dart';

import '../../constants.dart';
import '../../widgets/event_new_page.dart';

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
    List<Event> events = await API.retrievePendingEvents();

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
                    ? CalendarViewOfEvents(
                        events: pendingEvents,
                        onDaySelected: (DateTime day) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ScheduledEventsForDayPage(day: day)));
                        },
                      )
                    : ListViewOfEvents(
                        events: pendingEvents,
                        eventWidgetBuilder: (Event event) => PendingEventWidget(
                              event: event,
                            ))),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NewEventPage()),
                ).then((value) => {
                      if (value != null) {
                        setState(() {
                          final body = jsonDecode(value.body);
                          body["price"] = int.parse(body["price"]);
                          body["coach"] = body["coach"].toLowerCase() == 'true';
                          pendingEvents.add(Event.fromJson(body));
                        })
                      }
                    })
              },
              extendedTextStyle:
                  const TextStyle(fontSize: DEFAULT_BUTTON_FONT_SIZE),
              tooltip: 'Increment',
              icon: const Icon(Icons.add),
              label: const Text("New Job"),
            )));
  }
}
