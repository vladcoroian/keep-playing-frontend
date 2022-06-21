import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_playing_frontend/app_organiser/cubit/events_cubit.dart';

import 'events_for_day_view.dart';

class EventsForDayPage extends StatelessWidget {
  final EventsCubit eventsCubit;
  final DateTime day;

  const EventsForDayPage({
    Key? key,
    required this.eventsCubit,
    required this.day,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EventsCubit>.value(
      value: eventsCubit,
      child: EventsForDayView(day: day),
    );
  }
}
