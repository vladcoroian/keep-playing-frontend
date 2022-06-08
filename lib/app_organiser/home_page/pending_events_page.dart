import 'package:flutter/material.dart';
import 'package:keep_playing_frontend/app_organiser/home_page/pending_events/pending_event_widget.dart';
import 'package:keep_playing_frontend/constants.dart';

import '../../models/event.dart';

class PendingEventsPage extends StatelessWidget {
  const PendingEventsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Pending Events')),
        body: ListView(children: [
          PendingEventWidget(
              event: Event(
                  name: "Muay Thai Training Session",
                  location:
                      "Imperial College, Exhibition Rd, South Kensington, London SW7 2BX",
                  dateTime: DateTime(2022, 10, 12, 13, 14),
                  details: "To be announced",
                  price: 50)),
          PendingEventWidget(
              event: Event(
                  name: "Muay Thai",
                  location: "Imperial College",
                  dateTime: DateTime(2022, 10, 12, 13, 14),
                  details: "To be announced",
                  price: 40))
        ]),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => {},
          extendedTextStyle:
              const TextStyle(fontSize: DEFAULT_FONT_SIZE_BUTTONS),
          tooltip: 'Increment',
          icon: const Icon(Icons.add),
          label: const Text("New Job"),
        ));
  }
}
