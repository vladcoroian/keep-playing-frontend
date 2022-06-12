import 'package:flutter/material.dart';
import 'package:keep_playing_frontend/constants.dart';
import 'package:keep_playing_frontend/api-manager.dart';
import 'package:keep_playing_frontend/widgets/buttons.dart';

import '../models/event.dart';
import 'dialogs.dart';

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
              _CancelEventButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return _confirmCancellationOfEventDialog();
                      });
                },
              ),
              _SaveChangesButton(
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          )
        ]),
      ),
    );
  }

  Widget _confirmCancellationOfEventDialog() {
    return ConfirmationDialog(
      title: 'Are you sure you want to cancel this event?',
      onNoPressed: () {
        Navigator.pop(context);
      },
      onYesPressed: () {
        API.cancelEvent(event: widget.event);
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
  }
}

class _SaveChangesButton extends ColoredButton {
  const _SaveChangesButton({Key? key, required super.onPressed})
      : super(
          key: key,
          text: 'Save Changes',
          color: APP_COLOR,
        );
}

class _CancelEventButton extends ColoredButton {
  const _CancelEventButton({Key? key, required super.onPressed})
      : super(
          key: key,
          text: 'Cancel Event',
          color: CANCEL_BUTTON_COLOR,
        );
}
