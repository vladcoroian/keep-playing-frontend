import 'package:flutter/material.dart';
import 'package:keep_playing_frontend/app_coach/home_page/upcoming_jobs/upcoming_job_widget.dart';

import '../../models/event.dart';

class UpcomingJobsPage extends StatelessWidget {
  const UpcomingJobsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Upcoming Jobs')),
        body: ListView(children: [
          UpcomingJobWidget(
              event: Event(
                  name: "Muay Thai Training Session",
                  location:
                      "Imperial College, Exhibition Rd, South Kensington, London SW7 2BX",
                  dateTime: DateTime(2022, 10, 12, 13, 14),
                  details: "To be announced",
                  price: 50)),
          UpcomingJobWidget(
              event: Event(
                  name: "Muay Thai",
                  location: "Imperial College",
                  dateTime: DateTime(2022, 10, 12, 13, 14),
                  details: "To be announced",
                  price: 40))
        ]));
  }
}
