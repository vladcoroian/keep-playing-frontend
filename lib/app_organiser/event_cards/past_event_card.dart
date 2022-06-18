import 'package:flutter/material.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:keep_playing_frontend/widgets/buttons.dart';
import 'package:keep_playing_frontend/widgets/event_widgets.dart';

class PastEventCard extends StatelessWidget {
  final Event event;

  const PastEventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return EventCard(
        event: event,
        leftButton: const SizedBox(width: 0, height: 0),
        rightButton: DetailsButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return EventDetailsDialog(
                    event: event,
                    widgetsAtTheEnd: [
                      CancelButton(onPressed: () {
                        Navigator.pop(context);
                      })
                    ],
                  );
                });
          },
        ));
  }
}
