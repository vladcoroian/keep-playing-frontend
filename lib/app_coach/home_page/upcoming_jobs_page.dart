import 'package:flutter/material.dart';

class UpcomingJobsPage extends StatelessWidget {
  const UpcomingJobsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Upcoming Jobs')),
        body: const Text('Upcoming Jobs Page'));
  }
}
