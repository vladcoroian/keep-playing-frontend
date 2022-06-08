import 'package:flutter/material.dart';
import 'package:keep_playing_frontend/widgets/event_widget.dart';

import '../../../models/event.dart';
import '../../../widgets/buttons.dart';

class UpcomingJobWidget extends StatelessWidget {
  final Event event;

  const UpcomingJobWidget({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return EventWidget(
        event: event,
        leftButton: CancelButton(onPressed: () {}),
        rightButton: MessageButton(
          onPressed: () {},
        ));
  }
}
