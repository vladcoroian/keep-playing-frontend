import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_playing_frontend/app_organiser/cubit/organiser_events_cubit.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:keep_playing_frontend/widgets/events_views.dart';

import '../organiser.dart';

class EventsView extends StatelessWidget {
  const EventsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<OrganiserEventsCubit, List<Event>>(
        builder: (context, state) {
      return ListViewOfEvents(
          events: context.read<OrganiserEventsCubit>().state,
          eventWidgetBuilder: (Event event) =>
              Organiser.getCardForEvent(event: event));
    }));
  }
}
