import 'package:flutter/material.dart';
import 'package:keep_playing_frontend/api-manager.dart';
import 'package:keep_playing_frontend/app_organiser/home_page/pending_events/pending_events_for_day_page.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:keep_playing_frontend/widgets/event_widgets.dart';
import 'package:keep_playing_frontend/widgets/events_calendar.dart';
import 'package:keep_playing_frontend/widgets/events_list_view.dart';

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
      CalendarViewButton(
          onTap: () => {
                setState(() {
                  _selectedIndex = 1;
                })
              }),
      ListViewButton(
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
                                      PendingEventsForDayPage(day: day)));
                        },
                      )
                    : ListViewOfEvents(
                        events: pendingEvents,
                        eventWidgetBuilder: (event) => PendingEventWidget(
                              event: event,
                            ))),
            floatingActionButton: NewJobButton(context: context)));
  }
}
