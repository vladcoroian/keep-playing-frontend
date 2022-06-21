import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:keep_playing_frontend/app_organiser/cubit/organiser_events_cubit.dart';
import 'package:keep_playing_frontend/app_organiser/views/widgets/event_cards.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:keep_playing_frontend/widgets/events_views.dart';
import 'package:table_calendar/table_calendar.dart';

class EventsForDayView extends StatelessWidget {
  final DateTime day;

  const EventsForDayView({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    final Widget viewOfEvents = BlocBuilder<OrganiserEventsCubit, List<Event>>(
      builder: (context, state) {
        List<Event> eventsForDay = [
          ...BlocProvider.of<OrganiserEventsCubit>(context).state
        ];
        eventsForDay.retainWhere((event) => isSameDay(event.date, day));

        return ListViewsOfEvents(
          events: eventsForDay,
          eventWidgetBuilder: (Event event) =>
              OrganiserEventCards.getCardForEvent(event: event),
        ).listView();
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Events on ${DateFormat('dd MMMM').format(day)}'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          BlocProvider.of<OrganiserEventsCubit>(context).retrieveEvents();
        },
        child: viewOfEvents,
      ),
    );
  }
}
