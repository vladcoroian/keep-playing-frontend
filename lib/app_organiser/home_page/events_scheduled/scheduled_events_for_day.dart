import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:keep_playing_frontend/widgets/events_views.dart';

import 'scheduled_event_widget.dart';

class ScheduledEventsForDayPage extends StatefulWidget {
  final DateTime day;

  const ScheduledEventsForDayPage({Key? key, required this.day})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScheduledEventsForDayState();
}

class _ScheduledEventsForDayState extends State<ScheduledEventsForDayPage> {
  List<Event> scheduledEventsForDayPage = [];

  @override
  void initState() {
    _retrievePendingEventsForThisDay();
    super.initState();
  }

  _retrievePendingEventsForThisDay() async {
    List<Event> retrievedEvents =
        await API.events.retrieveScheduledEventsForDay(widget.day);

    setState(() {
      scheduledEventsForDayPage = retrievedEvents;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Scheduled Events for ${DateFormat('dd MMMM').format(widget.day)}'),
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            _retrievePendingEventsForThisDay();
          },
          child: ListViewOfEvents(
            events: scheduledEventsForDayPage,
            eventWidgetBuilder: (Event event) {
              return ScheduledEventWidget(event: event);
            },
          )),
    );
  }
}
