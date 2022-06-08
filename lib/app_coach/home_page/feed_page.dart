import 'package:flutter/material.dart';
import 'package:keep_playing_frontend/app_coach/home_page/feed/event_widget.dart';

import '../../models/event.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Feed')),
        body: ListView(children: [
          EventWidget(Event(
              name: "Muay Thai Training Session",
              location:
                  "Imperial College, Exhibition Rd, South Kensington, London SW7 2BX",
              dateTime: DateTime(2022, 10, 12, 13, 14),
              details: "To be announced",
              price: 50)),
          EventWidget(Event(
              name: "Muay Thai",
              location: "Imperial College",
              dateTime: DateTime(2022, 10, 12, 13, 14),
              details: "To be announced",
              price: 40))
        ]));
  }
}
