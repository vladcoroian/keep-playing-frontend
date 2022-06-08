import 'package:flutter/material.dart';
import 'package:keep_playing_frontend/app_coach/home_page/feed/event_widget.dart';

import '../../models/event.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Feed')),
        body: Column(children: [
          EventWidget(Event(
              "Muay Thai Training Session",
              "Imperial College, Exhibition Rd, South Kensington, London SW7 2BX",
              DateTime(2022, 10, 12, 13, 14),
              "To be announced")),
          Divider(),
          EventWidget(Event("Muay Thai", "Imperial College",
              DateTime(2022, 10, 12, 13, 14), "To be announced"))
        ]));
  }
}
