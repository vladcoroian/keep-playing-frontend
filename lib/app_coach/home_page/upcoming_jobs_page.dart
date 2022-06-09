import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:keep_playing_frontend/widgets/buttons.dart';
import 'package:keep_playing_frontend/widgets/dialogs.dart';

import '../../models/event.dart';
import '../../urls.dart';
import '../../widgets/event_widgets.dart';

class UpcomingJobsPage extends StatefulWidget {
  const UpcomingJobsPage({Key? key}) : super(key: key);

  @override
  State<UpcomingJobsPage> createState() => _UpcomingJobsPageState();
}

class _UpcomingJobsPageState extends State<UpcomingJobsPage> {
  Client client = http.Client();
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

class UpcomingJobWidget extends StatelessWidget {
  final Event event;

  final Client client = http.Client();

  UpcomingJobWidget({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return EventWidget(
        event: event,
        leftButton: CancelButton(onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return YesNoDialog(
                  title: 'Are you sure that you want to cancel this job?',
                  onCancelPressed: () => {Navigator.pop(context)},
                  onAcceptPressed: () {
                    client.patch(URL.updateEvent(event.pk),
                        body: {"coach": "false"});
                    Navigator.pop(context);
                  },
                );
              });
        }),
        rightButton: MessageButton(
          onPressed: () {},
        ));
  }
}
