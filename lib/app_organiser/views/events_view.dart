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
        value: BlocProvider.of<OrganiserEventsCubit>(context).allowPastEvents,
        onChanged: (bool value) {
          setState(() {
            BlocProvider.of<OrganiserEventsCubit>(context)
                .setAllowPastEventsTo(value);
          });
        },
        activeTrackColor: ACTIVE_TRACK_COLOR,
        activeColor: ACTIVE_COLOR,
      ),
      SwitchListTile(
        title: const Text('Pending Events'),
        value:
            BlocProvider.of<OrganiserEventsCubit>(context).allowPendingEvents,
        onChanged: (bool value) {
          setState(() {
            BlocProvider.of<OrganiserEventsCubit>(context)
                .setAllowPendingEventsTo(value);
          });
        },
        activeTrackColor: ACTIVE_TRACK_COLOR,
        activeColor: ACTIVE_COLOR,
      ),
      SwitchListTile(
        title: const Text('Scheduled Events'),
        value:
            BlocProvider.of<OrganiserEventsCubit>(context).allowScheduledEvents,
        onChanged: (bool value) {
          setState(() {
            BlocProvider.of<OrganiserEventsCubit>(context)
                .setAllowScheduledEventsTo(value);
          });
        },
        activeTrackColor: ACTIVE_TRACK_COLOR,
        activeColor: ACTIVE_COLOR,
      ),
    ];

    final Widget sliverViewOfEvents =
        BlocBuilder<OrganiserEventsCubit, List<Event>>(
      builder: (context, state) {
        return _calendarView
            ? SliverList(
                delegate: SliverChildListDelegate(
                  [
                    CalendarViewOfEvents(
                      events:
                          BlocProvider.of<OrganiserEventsCubit>(context).state,
                      onDaySelected: (DateTime day) => {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => EventsForDayPage(
                              organiserEventsCubit:
                                  BlocProvider.of<OrganiserEventsCubit>(
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
                events: BlocProvider.of<OrganiserEventsCubit>(context).state,
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
