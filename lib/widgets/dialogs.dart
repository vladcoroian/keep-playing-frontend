import 'package:flutter/material.dart';

import '../constants.dart';

const double DIALOG_PADDING = 16;

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final VoidCallback? onNoPressed;
  final VoidCallback? onYesPressed;

  const ConfirmationDialog({
    super.key,
    required this.title,
    this.onNoPressed,
    this.onYesPressed,
  });

  @override
  Widget build(BuildContext context) {
    final Widget yesButton = Container(
      padding: const EdgeInsets.all(BUTTON_PADDING),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: APP_COLOR,
            textStyle: const TextStyle(fontSize: BUTTON_FONT_SIZE)),
        onPressed: onYesPressed,
        child: const Text('Yes'),
      ),
    );

    final Widget noButton = Container(
      padding: const EdgeInsets.all(BUTTON_PADDING),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: BUTTON_GRAY_COLOR,
            textStyle: const TextStyle(fontSize: BUTTON_FONT_SIZE)),
        onPressed: onNoPressed,
        child: const Text('No'),
      ),
    );

    return SimpleDialog(
      contentPadding: const EdgeInsets.all(DIALOG_PADDING),
      title: Center(child: Text(title)),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [yesButton, noButton],
        ),
      ],
    );
  }
}

class ExitDialog extends StatelessWidget {
  final String title;
  final String text;
  final BuildContext context;

  const ExitDialog({
    super.key,
    required this.title,
    required this.text,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    final Widget yesButton = Container(
      padding: const EdgeInsets.all(BUTTON_PADDING),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: APP_COLOR,
            textStyle: const TextStyle(fontSize: BUTTON_FONT_SIZE)),
        onPressed: () => Navigator.of(context).pop(true),
        child: const Text('Yes'),
      ),
    );

    final Widget noButton = Container(
      padding: const EdgeInsets.all(BUTTON_PADDING),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: BUTTON_GRAY_COLOR,
            textStyle: const TextStyle(fontSize: BUTTON_FONT_SIZE)),
        onPressed: () => Navigator.of(context).pop(false),
        child: const Text('No'),
      ),
    );

    return SimpleDialog(
      contentPadding: const EdgeInsets.all(DIALOG_PADDING),
      title: Center(child: Text(title)),
      children: <Widget>[
        Container(padding: const EdgeInsets.all(10), child: Text(text)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [yesButton, noButton],
        ),
      ],
    );
  }
}
