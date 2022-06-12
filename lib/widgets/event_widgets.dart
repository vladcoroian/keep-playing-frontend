import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keep_playing_frontend/widgets/event_manage-page.dart';
import 'package:keep_playing_frontend/widgets/event_new_page.dart';

import '../constants.dart';
import '../models/event.dart';
import 'buttons.dart';

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
                  Text(event.getStartTimeToString()),
                  Text(event.getEndTimeToString()),
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

class PendingEventWidget extends StatelessWidget {
  final Event event;

  const PendingEventWidget({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return EventWidget(
        event: event,
        leftButton: const SizedBox(width: 0, height: 0),
        rightButton: _ManageButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ManageEventPage(event: event)),
            );
          },
        ));
  }
}

class NewJobButton extends FloatingActionButton {
  final BuildContext context;

  NewJobButton({Key? key, required this.context})
      : super.extended(
          key: key,
          onPressed: () => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NewEventPage()),
            )
          },
          extendedTextStyle:
              const TextStyle(fontSize: DEFAULT_BUTTON_FONT_SIZE),
          tooltip: 'Increment',
          icon: const Icon(Icons.add),
          label: const Text("New Job"),
        );
}

class CalendarViewButton extends StatelessWidget {
  final Function()? onTap;

  const CalendarViewButton({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(right: APP_BAR_BUTTON_PADDING),
        child: GestureDetector(
          onTap: onTap,
          child: const Icon(
            Icons.calendar_month,
            size: APP_BAR_BUTTON_SIZE,
          ),
        ));
  }
}

class ListViewButton extends StatelessWidget {
  final Function()? onTap;

  const ListViewButton({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(right: APP_BAR_BUTTON_PADDING),
        child: GestureDetector(
          onTap: onTap,
          child: const Icon(
            Icons.list,
            size: APP_BAR_BUTTON_SIZE,
          ),
        ));
  }
}

class _ManageButton extends ColoredButton {
  const _ManageButton({Key? key, required super.onPressed})
      : super(
          key: key,
          text: 'Manage',
          color: APP_COLOR,
        );
}
