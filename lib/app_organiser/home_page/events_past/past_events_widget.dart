import 'package:flutter/material.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:keep_playing_frontend/widgets/buttons.dart';
import 'package:keep_playing_frontend/widgets/event_widgets.dart';

class PastEventWidget extends StatelessWidget {
  final Event event;

  const PastEventWidget({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return EventCard(
        event: event,
        leftButton: const SizedBox(width: 0, height: 0),
        rightButton: DetailsButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EventDetailsDialog(
                        event: event,
                        widgetsAtTheEnd: [
                          CancelButton(onPressed: () {
                            Navigator.pop(context);
                          })
                        ],
                      )),
            );
          },
        ));
  }
}
