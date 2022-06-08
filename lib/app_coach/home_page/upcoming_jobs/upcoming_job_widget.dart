import 'package:flutter/material.dart';
import 'package:keep_playing_frontend/widgets/event_widget.dart';

import '../../../constants.dart';
import '../../../models/event.dart';

class UpcomingJobWidget extends StatelessWidget {
  final Event event;

  const UpcomingJobWidget({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return EventWidget(
        event: event,
        leftButton: _cancelButton(),
        rightButton: _messageButton());
  }

  Widget _cancelButton() {
    return Container(
        padding: const EdgeInsets.all(DEFAULT_PADDING),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: CANCEL_BUTTON_COLOR,
                textStyle:
                    const TextStyle(fontSize: DEFAULT_FONT_SIZE_BUTTONS)),
            onPressed: () {},
            child: const Text('Cancel')));
  }

  Widget _messageButton() {
    return Container(
        padding: const EdgeInsets.all(DEFAULT_PADDING),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                textStyle:
                    const TextStyle(fontSize: DEFAULT_FONT_SIZE_BUTTONS)),
            onPressed: () {},
            child: const Text('Message')));
  }
}
