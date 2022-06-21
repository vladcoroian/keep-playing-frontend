import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_playing_frontend/app_organiser/cubit/events_cubit.dart';
import 'package:keep_playing_frontend/app_organiser/views/events/new_event_view.dart';

class NewEventPage extends StatelessWidget {
  final EventsCubit eventsCubit;

  const NewEventPage({
    Key? key,
    required this.eventsCubit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EventsCubit>.value(
      value: eventsCubit,
      child: const NewEventView(),
    );
  }
}
