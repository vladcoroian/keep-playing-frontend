import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_playing_frontend/app_organiser/cubit/events_cubit.dart';
import 'package:keep_playing_frontend/app_organiser/cubit/organiser_cubit.dart';
import 'package:keep_playing_frontend/app_organiser/views/events/new_event_view.dart';

class NewEventPage extends StatelessWidget {
  final EventsCubit eventsCubit;
  final OrganiserCubit organiserCubit;

  const NewEventPage({
    Key? key,
    required this.eventsCubit,
    required this.organiserCubit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EventsCubit>.value(value: eventsCubit),
        BlocProvider<OrganiserCubit>.value(value: organiserCubit),
      ],
      child: const NewEventView(),
    );
  }
}
