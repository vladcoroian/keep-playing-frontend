import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:keep_playing_frontend/widgets/events_views.dart';

import '../../organiser.dart';

class AllEventsForDayPage extends StatefulWidget {
  final DateTime day;

  const AllEventsForDayPage({Key? key, required this.day}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PendingEventsForDayState();
}

class _PendingEventsForDayState extends State<AllEventsForDayPage> {
  List<Event> eventsForDay = [];

  @override
  void initState() {
    _retrieveEventsForThisDay();
    super.initState();
  }

  _retrieveEventsForThisDay() async {
    List<Event> retrievedEvents =
        await API.events.retrieveEvents(onDay: widget.day);

    setState(() {
      eventsForDay = retrievedEvents;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events on ${DateFormat('dd MMMM').format(widget.day)}'),
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            _retrieveEventsForThisDay();
          },
          child: ListViewOfEvents(
            events: eventsForDay,
            eventWidgetBuilder: (Event event) {
              return Organiser.getCardForEvent(event: event);
            },
          )),
    );
  }
}
