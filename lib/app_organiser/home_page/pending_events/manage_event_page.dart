import 'package:flutter/material.dart';
import 'package:keep_playing_frontend/widgets/buttons.dart';

import '../../../models/event.dart';
import '../../../widgets/dialogs.dart';

class ManageEventPage extends StatefulWidget {
  final Event event;

  const ManageEventPage({super.key, required this.event});

  @override
  State<ManageEventPage> createState() => _ManageEventPageState();
}

class _ManageEventPageState extends State<ManageEventPage> {
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => ExitDialog(
              context: context,
              title: 'Are you sure that you want to exit?',
              text: 'You haven\'t finished editing the event'),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(title: const Text('Edit Event')),
        body: ListView(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CancelEventButton(
                onPressed: () {},
              ),
              SaveChangesButton(
                onPressed: () {},
              )
            ],
          )
        ]),
      ),
    );
  }
}
