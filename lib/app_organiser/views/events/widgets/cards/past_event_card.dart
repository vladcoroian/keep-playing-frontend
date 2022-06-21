import 'package:flutter/material.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:keep_playing_frontend/widgets/buttons.dart';
import 'package:keep_playing_frontend/widgets/event_widgets.dart';

class PastEventCard extends StatelessWidget {
  final Event event;

  const PastEventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final Widget detailsButton = ColoredButton(
      text: 'Details',
      color: DETAILS_BUTTON_COLOR,
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            final Widget cancelButton = ColoredButton(
              text: 'Cancel',
              color: CANCEL_BUTTON_COLOR,
              onPressed: () {
                Navigator.pop(context);
              },
            );

            return EventDetailsDialog(
              event: event,
              widgetsAtTheEnd: [cancelButton],
            );
          },
        );
      },
    );

    return EventCard(
      event: event,
      leftButton: const SizedBox(width: 0, height: 0),
      rightButton: detailsButton,
    );
  }
}
