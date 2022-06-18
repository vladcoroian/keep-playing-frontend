import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_playing_frontend/app_organiser/cubit/organiser_events_cubit.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:keep_playing_frontend/widgets/events_views.dart';

import '../events/new_event.dart';
import '../events/new_job_button.dart';
import '../organiser.dart';

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
              events: context.read<OrganiserEventsCubit>().state,
              onDaySelected: (DateTime day) {},
            )
          : ListViewOfEvents(
              events: context.read<OrganiserEventsCubit>().state,
              eventWidgetBuilder: (Event event) =>
                  Organiser.getCardForEvent(event: event),
            );
    });

    final Widget newJobButton = NewJobButton(
      context: context,
      onPressed: () => {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: BlocProvider.of<OrganiserEventsCubit>(context),
              child: const NewEventPage(),
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
          context.read<OrganiserEventsCubit>().retrieveEvents();
        },
        child: viewOfEvents,
      ),
      floatingActionButton: newJobButton,
    );
  }
}
