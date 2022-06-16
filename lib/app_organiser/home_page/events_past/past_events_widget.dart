import 'package:flutter/material.dart';
import 'package:keep_playing_frontend/constants.dart';
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
        rightButton: _DetailsButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EventDetailsDialog(
                        event: event,
                        widgetsAtTheEnd: [
                          _CancelButton(onPressed: () {
                            Navigator.pop(context);
                          })
                        ],
                      )),
            );
          },
        ));
  }
}

class _DetailsButton extends ColoredButton {
  const _DetailsButton({Key? key, required super.onPressed})
      : super(
          key: key,
          text: 'Details',
          color: DETAILS_BUTTON_COLOR,
        );
}

class _CancelButton extends ColoredButton {
  const _CancelButton({Key? key, required super.onPressed})
      : super(
          key: key,
          text: 'Cancel',
          color: CANCEL_BUTTON_COLOR,
        );
}
