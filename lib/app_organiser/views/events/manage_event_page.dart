import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_playing_frontend/app_organiser/cubit/organiser_events_cubit.dart';
import 'package:keep_playing_frontend/app_organiser/views/events/manage_event_view.dart';
import 'package:keep_playing_frontend/models/event.dart';

class ManageEventPage extends StatelessWidget {
  final OrganiserEventsCubit organiserEventsCubit;
  final Event event;

  const ManageEventPage({
    Key? key,
    required this.organiserEventsCubit,
    required this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrganiserEventsCubit>.value(
      value: organiserEventsCubit,
      child: ManageEventView(event: event),
    );
  }
}
