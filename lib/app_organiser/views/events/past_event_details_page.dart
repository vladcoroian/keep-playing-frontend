import 'package:flutter/material.dart';
import 'package:keep_playing_frontend/models/event.dart';

import 'past_event_details_view.dart';

class PastEventDetailsPage extends StatelessWidget {
  final Event event;

  const PastEventDetailsPage({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PastEventDetailsView(event: event);
  }
}
