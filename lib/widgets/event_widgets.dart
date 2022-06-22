import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../models/event.dart';
import 'dialogs.dart';

class EventWidgets {
  final Event event;

  EventWidgets({required this.event});

  static const TextStyle _textStyleForTitle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: APP_COLOR,
  );

  List<Widget> getDetailsAboutEvent() {
    return <Widget>[
      ListTile(
          leading: const Icon(Icons.sports_soccer),
          title: const Text('Sport', style: _textStyleForTitle),
          subtitle: Text(event.sport)),
      ListTile(
          leading: const Icon(Icons.sports),
          title: const Text('Role', style: _textStyleForTitle),
          subtitle: Text(event.role)),
      ListTile(
          leading: const Icon(Icons.location_on),
          title: const Text('Location', style: _textStyleForTitle),
          subtitle: Text(event.location)),
      ListTile(
          leading: const Icon(Icons.date_range),
          title: const Text('Date', style: _textStyleForTitle),
          subtitle: Text(DateFormat("MMMM dd").format(event.date))),
      ListTile(
          leading: const Icon(Icons.access_time),
          title: const Text('Start Time', style: _textStyleForTitle),
          subtitle: Text(const DefaultMaterialLocalizations()
              .formatTimeOfDay(event.startTime, alwaysUse24HourFormat: true))),
      ListTile(
          leading: const Icon(Icons.access_time),
          title: const Text('End Time', style: _textStyleForTitle),
          subtitle: Text(const DefaultMaterialLocalizations()
              .formatTimeOfDay(event.endTime, alwaysUse24HourFormat: true))),
      const Divider(),
      ListTile(
          leading: const Icon(Icons.details),
          title: const Text('Details', style: _textStyleForTitle),
          subtitle: Text(event.details)),
      const Divider()
    ];
  }
}

class EventCard extends StatelessWidget {
  final Event event;
  final Widget leftButton;
  final Widget rightButton;

  const EventCard(
      {super.key,
      required this.event,
      required this.leftButton,
      required this.rightButton});

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.all(CARD_PADDING),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(DateFormat("MMMM dd").format(event.date)),
                  Text(const DefaultMaterialLocalizations().formatTimeOfDay(
                      event.startTime,
                      alwaysUse24HourFormat: true)),
                  Text(const DefaultMaterialLocalizations().formatTimeOfDay(
                      event.endTime,
                      alwaysUse24HourFormat: true)),
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

class EventDetailsDialog extends StatelessWidget {
  final Event event;
  final List<Widget> widgetsAtTheEnd;

  const EventDetailsDialog({
    Key? key,
    required this.event,
    required this.widgetsAtTheEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(DIALOG_PADDING),
      title: Center(
          child: Text(
        event.name,
        style: EventWidgets._textStyleForTitle,
        textScaleFactor: 1.5,
      )),
      children:
          EventWidgets(event: event).getDetailsAboutEvent() + widgetsAtTheEnd,
    );
  }
}
