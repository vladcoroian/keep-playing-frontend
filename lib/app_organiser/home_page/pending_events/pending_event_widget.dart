import 'package:flutter/material.dart';
import 'package:keep_playing_frontend/widgets/event_widget.dart';

import '../../../constants.dart';
import '../../../models/event.dart';

class PendingEventWidget extends StatelessWidget {
  final Event event;

  const PendingEventWidget({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return EventWidget(
        event: event,
        leftButton: const SizedBox(width: 0, height: 0),
        rightButton: _manageButton());
  }

  Widget _manageButton() {
    return Container(
        padding: const EdgeInsets.all(DEFAULT_PADDING),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                textStyle:
                    const TextStyle(fontSize: DEFAULT_FONT_SIZE_BUTTONS)),
            onPressed: () {},
            child: const Text('Manage')));
  }
}
