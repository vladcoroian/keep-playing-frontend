import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';
import '../../../models/event.dart';

class EventWidget extends StatelessWidget {
  final Event event;

  const EventWidget({super.key, required this.event});

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
                  Text(DateFormat("MMMM dd").format(event.dateTime)),
                  Text(DateFormat("HH:mm").format(event.dateTime)),
                ],
              ),
              title: Text(event.name, textAlign: TextAlign.left),
              subtitle: Text(event.location, textAlign: TextAlign.left),
              trailing: Text(
                  NumberFormat.simpleCurrency(name: "GBP").format(event.price)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_detailsButton(), _takeJobButton()],
            ),
          ],
        ));
  }

  Widget _detailsButton() {
    return Container(
        padding: const EdgeInsets.all(DEFAULT_PADDING),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                textStyle:
                    const TextStyle(fontSize: DEFAULT_FONT_SIZE_BUTTONS)),
            onPressed: () {},
            child: const Text('Details')));
  }

  Widget _takeJobButton() {
    return Container(
        padding: const EdgeInsets.all(DEFAULT_PADDING),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                textStyle:
                    const TextStyle(fontSize: DEFAULT_FONT_SIZE_BUTTONS)),
            onPressed: () {},
            child: const Text('Take Job')));
  }
}
