import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_playing_frontend/app_organiser/cubit/organiser_events_cubit.dart';

import 'events_view.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        OrganiserEventsCubit organiserEventsCubit = OrganiserEventsCubit();
        organiserEventsCubit.retrieveEvents();
        return organiserEventsCubit;
      },
      child: const EventsView(),
    );
  }
}
