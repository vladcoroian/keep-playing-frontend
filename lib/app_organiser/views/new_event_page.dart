import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_playing_frontend/app_organiser/cubit/organiser_events_cubit.dart';
import 'package:keep_playing_frontend/app_organiser/views/new_event_view.dart';

class NewEventPage extends StatelessWidget {
  final OrganiserEventsCubit organiserEventsCubit;

  const NewEventPage({
    Key? key,
    required this.organiserEventsCubit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrganiserEventsCubit>.value(
      value: organiserEventsCubit,
      child: const NewEventView(),
    );
  }
}
