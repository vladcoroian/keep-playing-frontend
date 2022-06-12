import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keep_playing_frontend/api_manager.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:keep_playing_frontend/widgets/event_widgets.dart';
import 'package:keep_playing_frontend/widgets/events_views.dart';

class PendingEventsForDayPage extends StatefulWidget {
  final DateTime day;

  const PendingEventsForDayPage({Key? key, required this.day})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _PendingEventsForDayState();
}

class _PendingEventsForDayState extends State<ScheduledEventsForDayPage> {
  List<Event> pendingEventsForDay = [];

  @override
  void initState() {
    _retrievePendingEventsForThisDay();
    super.initState();
  }

  _retrievePendingEventsForThisDay() async {
    List<Event> retrievedEvents =
        await API.retrievePendingEventsForThisDay(widget.day);

    setState(() {
      pendingEventsForDay = retrievedEvents;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Pending Events for ${DateFormat('dd MMMM').format(widget.day)}'),
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            _retrievePendingEventsForThisDay();
          },
          child: ListViewOfEvents(
            events: pendingEventsForDay,
            eventWidgetBuilder: (Event event) {
              return PendingEventWidget(event: event);
            },
          )),
    );
  }
}

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
        await API.retrieveScheduledEventsForDay(widget.day);

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
