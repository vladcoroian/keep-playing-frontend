import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_playing_frontend/app_organiser/cubit/all_events_cubit.dart';
import 'package:keep_playing_frontend/app_organiser/cubit/events_cubit.dart';

import 'events_view.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EventsCubit>(
      create: (BuildContext context) {
        EventsCubit eventsCubit = EventsCubit(
          allEventsCubit: BlocProvider.of<AllEventsCubit>(context),
        );
        eventsCubit.retrieveEvents();
        return eventsCubit;
      },
      child: const EventsView(),
    );
  }
}
