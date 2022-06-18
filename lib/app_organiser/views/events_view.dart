import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_playing_frontend/app_organiser/cubit/organiser_events_cubit.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:keep_playing_frontend/widgets/events_views.dart';

import 'events_for_day_page.dart';
import 'new_event_page.dart';
import 'widgets/event_cards.dart';
import 'widgets/new_job_button.dart';

class EventsView extends StatefulWidget {
  const EventsView({Key? key}) : super(key: key);

  @override
  State<EventsView> createState() => _EventsViewState();
}

class _EventsViewState extends State<EventsView> {
  bool _calendarView = true;

  @override
  Widget build(BuildContext context) {
    final Widget appBarButton = _calendarView
        ? ListViewButton(
            onTap: () => {
                  setState(() {
                    _calendarView = !_calendarView;
                  })
                })
        : CalendarViewButton(
            onTap: () => {
                  setState(() {
                    _calendarView = !_calendarView;
                  })
                });

    final Widget viewOfEvents = BlocBuilder<OrganiserEventsCubit, List<Event>>(
        builder: (context, state) {
      return _calendarView
          ? CalendarViewOfEvents(
              events: BlocProvider.of<OrganiserEventsCubit>(context).state,
              onDaySelected: (DateTime day) => {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => EventsForDayPage(
                      organiserEventsCubit:
                          BlocProvider.of<OrganiserEventsCubit>(context),
                      day: day,
                    ),
                  ),
                ),
              },
            )
          : ListViewOfEvents(
              events: BlocProvider.of<OrganiserEventsCubit>(context).state,
              eventWidgetBuilder: (Event event) =>
                  OrganiserEventCards.getCardForEvent(event: event),
            );
    });

    final Widget newJobButton = NewJobButton(
      context: context,
      onPressed: () => {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => NewEventPage(
              organiserEventsCubit:
                  BlocProvider.of<OrganiserEventsCubit>(context),
            ),
          ),
        ),
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        actions: [appBarButton],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          BlocProvider.of<OrganiserEventsCubit>(context).retrieveEvents();
        },
        child: viewOfEvents,
      ),
      floatingActionButton: newJobButton,
    );
  }
}
