import 'package:flutter/material.dart';
import 'package:keep_playing_frontend/constants.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:keep_playing_frontend/widgets/buttons.dart';
import 'package:keep_playing_frontend/widgets/dialogs.dart';
import 'package:keep_playing_frontend/widgets/event_widgets.dart';

import '../events/manage_event.dart';

class PendingEventWidget extends StatelessWidget {
  final Event event;

  const PendingEventWidget({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return EventWidget(
        event: event,
        leftButton: _OffersButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return _OffersDialog(button: _CancelButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ));
                });
          },
        ),
        rightButton: _ManageButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ManageEventPage(event: event)),
            );
          },
        ));
  }
}

class _OffersButton extends ColoredButton {
  const _OffersButton({Key? key, required super.onPressed})
      : super(
          key: key,
          text: 'Offers',
          color: DEFAULT_BUTTON_GRAY_COLOR,
        );
}

class _ManageButton extends ColoredButton {
  const _ManageButton({Key? key, required super.onPressed})
      : super(
          key: key,
          text: 'Manage',
          color: APP_COLOR,
        );
}

class _OffersDialog extends OneOptionDialog {
  const _OffersDialog({Key? key, required super.button})
      : super(
          key: key,
          title: 'Current Offers',
          text: '',
        );
}

class _CancelButton extends ColoredButton {
  const _CancelButton({Key? key, required super.onPressed})
      : super(
          key: key,
          text: 'Cancel',
          color: CANCEL_BUTTON_COLOR,
        );
}
