import 'package:flutter/material.dart';
import 'package:keep_playing_frontend/widgets/events_views.dart';

import '../../api_manager.dart';
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
    List<Event> events = await API.retrieveScheduledEvents();

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
                  eventWidgetBuilder: (Event event) => UpcomingJobWidget(
                        event: event,
                      ))),
        ));
  }
}
