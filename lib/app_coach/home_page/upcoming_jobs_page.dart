import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../models/event.dart';
import '../../urls.dart';
import '../../widgets/event_widgets.dart';

class UpcomingJobsPage extends StatefulWidget {
  const UpcomingJobsPage({Key? key}) : super(key: key);

  @override
  State<UpcomingJobsPage> createState() => _UpcomingJobsPageState();
}

class _UpcomingJobsPageState extends State<UpcomingJobsPage> {
  http.Client client = http.Client();
  List<Event> events = [];

  @override
  void initState() {
    _retrieveEvents();
    super.initState();
  }

  _retrieveEvents() async {
    events = [];
    List response = json.decode((await client.get(Uri.parse(URL.EVENTS))).body);
    for (var element in response) {
      events.add(Event.fromJson(element));
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upcoming Jobs')),
      body: RefreshIndicator(
        onRefresh: () async {
          _retrieveEvents();
        },
        child: ListView.builder(
          itemCount: events.length,
          itemBuilder: (BuildContext context, int index) {
            if (events[index].coach) {
              return UpcomingJobWidget(event: events[index]);
            }
            return const SizedBox(width: 0, height: 0);
          },
        ),
      ),
    );
  }
}
