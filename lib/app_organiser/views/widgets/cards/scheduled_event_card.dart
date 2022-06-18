import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_playing_frontend/app_organiser/cubit/organiser_events_cubit.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:keep_playing_frontend/widgets/buttons.dart';
import 'package:keep_playing_frontend/widgets/event_widgets.dart';

import '../../manage_event_page.dart';

class ScheduledEventCard extends StatelessWidget {
  final Event event;

  const ScheduledEventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return EventCard(
        event: event,
        leftButton: const SizedBox(width: 0, height: 0),
        rightButton: ManageButton(
          onPressed: () => {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: BlocProvider.of<OrganiserEventsCubit>(context),
                  child: ManageEventPage(event: event),
                ),
              ),
            ),
          },
        ));
  }
}
