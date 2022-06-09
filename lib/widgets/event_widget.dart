import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../models/event.dart';

class EventWidget extends StatelessWidget {
  final Event event;
  final Widget leftButton;
  final Widget rightButton;

  const EventWidget(
      {super.key,
      required this.event,
      required this.leftButton,
      required this.rightButton});

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.all(DEFAULT_PADDING),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(DateFormat("MMMM dd").format(event.getDate())),
                  Text(event.start_time.toString()),
                  Text(event.end_time.toString()),
                ],
              ),
              title: Text(event.name, textAlign: TextAlign.left),
              subtitle: Text(event.location, textAlign: TextAlign.left),
              trailing: Text(event.getPriceInPounds()),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [leftButton, rightButton],
            ),
          ],
        ));
  }
}
