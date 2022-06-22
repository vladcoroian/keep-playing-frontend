import 'package:flutter/material.dart';
import 'package:keep_playing_frontend/app_organiser/views/events/past_event_details_page.dart';
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
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PastEventDetailsPage(event: event),
          ),
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
