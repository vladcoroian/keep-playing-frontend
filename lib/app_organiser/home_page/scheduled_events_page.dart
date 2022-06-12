import 'package:flutter/material.dart';
import 'package:keep_playing_frontend/api_manager.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:keep_playing_frontend/widgets/event_widgets.dart';
import 'package:keep_playing_frontend/widgets/events_pages.dart';
import 'package:keep_playing_frontend/widgets/events_views.dart';

import '../../constants.dart';
import '../../widgets/event_new_page.dart';

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
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NewEventPage()),
                )
              },
              extendedTextStyle:
                  const TextStyle(fontSize: DEFAULT_BUTTON_FONT_SIZE),
              tooltip: 'Increment',
              icon: const Icon(Icons.add),
              label: const Text("New Job"),
            )));
  }
}
