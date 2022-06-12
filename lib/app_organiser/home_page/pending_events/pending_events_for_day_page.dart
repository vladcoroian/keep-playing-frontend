import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:keep_playing_frontend/urls.dart';
import 'package:keep_playing_frontend/events/event_widgets.dart';
import 'package:table_calendar/table_calendar.dart';

class PendingEventsForDayPage extends StatefulWidget {
  final DateTime day;

  const PendingEventsForDayPage({Key? key, required this.day})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _PendingEventsForDayState();
}

class _PendingEventsForDayState extends State<PendingEventsForDayPage> {
  Client client = http.Client();
  List<Event> pendingEventsForThisDay = [];

  @override
  void initState() {
    _retrievePendingEventsForThisDay();
    super.initState();
  }

  _retrievePendingEventsForThisDay() async {
    pendingEventsForThisDay = [];
    List response = json.decode((await client.get(Uri.parse(URL.EVENTS))).body);
    for (var element in response) {
      Event event = Event.fromJson(element);
      if (!event.coach && isSameDay(event.getDate(), widget.day)) {
        pendingEventsForThisDay.add(Event.fromJson(element));
      }
    }

    setState(() {});
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
          child: ListView.builder(
            itemCount: pendingEventsForThisDay.length,
            itemBuilder: (BuildContext context, int index) {
              return PendingEventWidget(event: pendingEventsForThisDay[index]);
            },
          )),
    );
  }
}
