import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:keep_playing_frontend/widgets/events_views.dart';

import '../event_cards/pending_event_card.dart';

class PendingEventsForDayPage extends StatefulWidget {
  final DateTime day;

  const PendingEventsForDayPage({Key? key, required this.day})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _PendingEventsForDayState();
}

class _PendingEventsForDayState extends State<PendingEventsForDayPage> {
  List<Event> pendingEventsForDay = [];

  @override
  void initState() {
    _retrievePendingEventsForThisDay();
    super.initState();
  }

  _retrievePendingEventsForThisDay() async {
    List<Event> retrievedEvents =
        await API.events.retrieveEvents(pending: true, onDay: widget.day);

    setState(() {
      pendingEventsForDay = retrievedEvents;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Pending Events on ${DateFormat('dd MMMM').format(widget.day)}'),
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            _retrievePendingEventsForThisDay();
          },
          child: ListViewOfEvents(
            events: pendingEventsForDay,
            eventWidgetBuilder: (Event event) {
              return PendingEventCard(event: event);
            },
          )),
    );
  }
}
