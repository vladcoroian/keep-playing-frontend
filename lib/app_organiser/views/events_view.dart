import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_playing_frontend/app_organiser/cubit/events_cubit.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:keep_playing_frontend/widgets/events_views.dart';

import 'events/events_for_day_page.dart';
import 'events/new_event_page.dart';
import 'events/widgets/event_cards.dart';
import 'events/widgets/new_job_button.dart';

class EventsView extends StatefulWidget {
  const EventsView({Key? key}) : super(key: key);

  @override
  State<EventsView> createState() => _EventsViewState();
}

class _EventsViewState extends State<EventsView> {
  static const Color ACTIVE_TRACK_COLOR = Colors.lightGreenAccent;
  static const Color ACTIVE_COLOR = Colors.green;

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

    final List<Widget> optionSelectors = [
      SwitchListTile(
        title: const Text('Past Events'),
        value: BlocProvider.of<EventsCubit>(context).allowPastEvents,
        onChanged: (bool value) {
          setState(() {
            BlocProvider.of<EventsCubit>(context)
                .setAllowPastEventsTo(value);
          });
        },
        activeTrackColor: ACTIVE_TRACK_COLOR,
        activeColor: ACTIVE_COLOR,
      ),
      SwitchListTile(
        title: const Text('Pending Events'),
        value:
            BlocProvider.of<EventsCubit>(context).allowPendingEvents,
        onChanged: (bool value) {
          setState(() {
            BlocProvider.of<EventsCubit>(context)
                .setAllowPendingEventsTo(value);
          });
        },
        activeTrackColor: ACTIVE_TRACK_COLOR,
        activeColor: ACTIVE_COLOR,
      ),
      SwitchListTile(
        title: const Text('Scheduled Events'),
        value:
            BlocProvider.of<EventsCubit>(context).allowScheduledEvents,
        onChanged: (bool value) {
          setState(() {
            BlocProvider.of<EventsCubit>(context)
                .setAllowScheduledEventsTo(value);
          });
        },
        activeTrackColor: ACTIVE_TRACK_COLOR,
        activeColor: ACTIVE_COLOR,
      ),
    ];

    final Widget sliverViewOfEvents =
        BlocBuilder<EventsCubit, List<Event>>(
      builder: (context, state) {
        return _calendarView
            ? SliverList(
                delegate: SliverChildListDelegate(
                  [
                    CalendarViewOfEvents(
                      events: state,
                      onDaySelected: (DateTime day) => {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => EventsForDayPage(
                              eventsCubit:
                                  BlocProvider.of<EventsCubit>(
                                      context),
                              day: day,
                            ),
                          ),
                        ),
                      },
                    ),
                  ],
                ),
              )
            : ListViewsOfEvents(
                events: state,
                eventWidgetBuilder: (Event event) =>
                    OrganiserEventCards.getCardForEvent(event: event),
              ).sliverListView();
      },
    );

    final Widget newJobButton = NewJobButton(
      context: context,
      onPressed: () => {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => NewEventPage(
              eventsCubit:
                  BlocProvider.of<EventsCubit>(context),
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
          BlocProvider.of<EventsCubit>(context).retrieveEvents();
        },
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(optionSelectors),
            ),
            SliverList(
              delegate: SliverChildListDelegate([const Divider()]),
            ),
            sliverViewOfEvents,
          ],
        ),
      ),
      floatingActionButton: newJobButton,
    );
  }
}
