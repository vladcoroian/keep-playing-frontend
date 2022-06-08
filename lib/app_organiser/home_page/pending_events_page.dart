import 'package:flutter/material.dart';

class PendingEventsPage extends StatelessWidget {
  const PendingEventsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Pending Events')),
        body: const Text('Pending Events Page'));
  }
}
