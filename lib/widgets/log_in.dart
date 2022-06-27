import 'package:flutter/material.dart';

import 'dialogs.dart';

enum LoginStatus {
  INVALID_CREDENTIALS,
  NOT_COACH_CREDENTIALS,
  NOT_ORGANISER_CREDENTIALS,
}

class InvalidCredentialsDialog extends StatelessWidget {
  const InvalidCredentialsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(DIALOG_PADDING),
      title: const Text('Invalid Credentials'),
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(10),
          child: const Text('Please try again.'),
        ),
      ],
    );
  }
}

class NotCoachCredentialsDialog extends StatelessWidget {
  const NotCoachCredentialsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(DIALOG_PADDING),
      title: const Text('You tried to log in with a non-coach account'),
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(10),
          child: const Text('Please log in with a coach account.'),
        ),
      ],
    );
  }
}

class NotOrganiserCredentialsDialog extends StatelessWidget {
  const NotOrganiserCredentialsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(DIALOG_PADDING),
      title: const Text('You tried to log in with a non-organiser account'),
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(10),
          child: const Text('Please log in with an organiser account.'),
        ),
      ],
    );
  }
}
