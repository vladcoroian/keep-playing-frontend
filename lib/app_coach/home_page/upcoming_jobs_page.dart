import 'package:flutter/material.dart';
import 'package:keep_playing_frontend/app_coach/home_page/upcoming_jobs/upcoming_job_widget.dart';

import '../../models/event.dart';

class UpcomingJobsPage extends StatelessWidget {
  const UpcomingJobsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Upcoming Jobs')),
        body: ListView(children: []));
  }
}
