import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:keep_playing_frontend/widgets/events_views.dart';

import 'past_events_widget.dart';

class PastEventsForDayPage extends StatefulWidget {
  final DateTime day;

  const PastEventsForDayPage({Key? key, required this.day}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PastEventsForDayState();
}

class _PastEventsForDayState extends State<PastEventsForDayPage> {
  List<Event> pastEventsForDayPage = [];

  @override
  void initState() {
    _retrievePastEventsForThisDay();
    super.initState();
  }

  _retrievePastEventsForThisDay() async {
    List<Event> retrievedEvents = (await API.events.retrieveEventsBefore());

    retrievedEvents.retainWhere((element) =>
        widget.day.day == element.date.day &&
        widget.day.year == element.date.year &&
        widget.day.month == element.date.month);

    setState(() {
      pastEventsForDayPage = retrievedEvents;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Past Events for ${DateFormat('dd MMMM').format(widget.day)}'),
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            _retrievePastEventsForThisDay();
          },
          child: ListViewOfEvents(
            events: pastEventsForDayPage,
            eventWidgetBuilder: (Event event) {
              return PastEventWidget(event: event);
            },
          )),
    );
  }
}
