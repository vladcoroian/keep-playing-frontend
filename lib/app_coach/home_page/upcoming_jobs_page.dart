import 'package:flutter/material.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/widgets/buttons.dart';
import 'package:keep_playing_frontend/widgets/dialogs.dart';
import 'package:keep_playing_frontend/widgets/events_views.dart';

import '../../models/event.dart';
import '../../widgets/event_widgets.dart';

class UpcomingJobsPage extends StatefulWidget {
  const UpcomingJobsPage({Key? key}) : super(key: key);

  @override
  State<UpcomingJobsPage> createState() => _UpcomingJobsPageState();
}

class _UpcomingJobsPageState extends State<UpcomingJobsPage> {
  List<Event> upcomingJobs = [];

  _retrieveUpcomingJobs() async {
    List<Event> events =
        await API.events.retrieveFutureEventsWith(pending: false);

    setState(() {
      upcomingJobs = events;
    });
  }

  @override
  void initState() {
    _retrieveUpcomingJobs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () async {
          _retrieveUpcomingJobs();
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Upcoming Jobs'),
          ),
          body: Center(
              child: ListViewOfEvents(
                  events: upcomingJobs,
                  eventWidgetBuilder: (Event event) => _UpcomingJobWidget(
                        event: event,
                      ))),
        ));
  }
}

class _UpcomingJobWidget extends StatelessWidget {
  final Event event;

  const _UpcomingJobWidget({required this.event});

  @override
  Widget build(BuildContext context) {
    return EventCard(
        event: event,
        leftButton: CancelButton(onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return ConfirmationDialog(
                  title: 'Are you sure that you want to cancel this job?',
                  onNoPressed: () => {Navigator.pop(context)},
                  onYesPressed: () {
                    API.events.cancelJob(event: event);
                    Navigator.pop(context);
                  },
                );
              });
        }),
        rightButton: DetailsButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return EventDetailsDialog(
                    event: event,
                    widgetsAtTheEnd: [
                      CancelButton(onPressed: () {
                        Navigator.pop(context);
                      })
                    ],
                  );
                });
          },
        ));
  }
}
