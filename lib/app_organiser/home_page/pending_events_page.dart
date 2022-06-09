import 'package:flutter/material.dart';
import 'package:keep_playing_frontend/app_organiser/home_page/pending_events/new_event_page.dart';
import 'package:keep_playing_frontend/app_organiser/home_page/pending_events/pending_event_widget.dart';
import 'package:keep_playing_frontend/constants.dart';

import '../../models/event.dart';

class PendingEventsPage extends StatelessWidget {
  const PendingEventsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Pending Events')),
        body: ListView(children: []),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NewEventPage()),
            )
          },
          extendedTextStyle:
              const TextStyle(fontSize: DEFAULT_FONT_SIZE_BUTTONS),
          tooltip: 'Increment',
          icon: const Icon(Icons.add),
          label: const Text("New Job"),
        ));
  }
}
