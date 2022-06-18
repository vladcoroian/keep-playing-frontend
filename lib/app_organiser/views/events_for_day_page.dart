import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_playing_frontend/app_organiser/cubit/organiser_events_cubit.dart';

import 'events_for_day_view.dart';

class EventsForDayPage extends StatelessWidget {
  final OrganiserEventsCubit organiserEventsCubit;
  final DateTime day;

  const EventsForDayPage({
    Key? key,
    required this.organiserEventsCubit,
    required this.day,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: organiserEventsCubit,
      child: EventsForDayView(day: day),
    );
  }
}
