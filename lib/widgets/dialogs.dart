import 'package:flutter/material.dart';

import '../constants.dart';

const double DIALOG_PADDING = 16;

class OneOptionDialog extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Widget button;

  const OneOptionDialog(
      {super.key,
      required this.title,
      required this.children,
      required this.button});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(DIALOG_PADDING),
      title: Center(child: Text(title)),
      children: children +
          [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [button],
            ),
          ],
    );
  }
}

class TwoOptionsDialog extends StatelessWidget {
  final String title;
  final String text;
  final Widget leftButton;
  final Widget rightButton;

  const TwoOptionsDialog(
      {super.key,
      required this.title,
      required this.text,
      required this.leftButton,
      required this.rightButton});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(DIALOG_PADDING),
      title: Center(child: Text(title)),
      children: <Widget>[
        Container(padding: const EdgeInsets.all(10), child: Text(text)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [leftButton, rightButton],
        ),
      ],
    );
  }
}

class ConfirmationDialog extends TwoOptionsDialog {
  final VoidCallback? onNoPressed;
  final VoidCallback? onYesPressed;

  ConfirmationDialog(
      {Key? key,
      required super.title,
      super.text = '',
      required this.onNoPressed,
      required this.onYesPressed})
      : super(
          key: key,
          leftButton: Container(
            padding: const EdgeInsets.all(BUTTON_PADDING),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: APP_COLOR,
                  textStyle: const TextStyle(fontSize: BUTTON_FONT_SIZE)),
              onPressed: () => onYesPressed,
              child: const Text('Yes'),
            ),
          ),
          rightButton: Container(
            padding: const EdgeInsets.all(BUTTON_PADDING),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: BUTTON_GRAY_COLOR,
                  textStyle: const TextStyle(fontSize: BUTTON_FONT_SIZE)),
              onPressed: () => onNoPressed,
              child: const Text('No'),
            ),
          ),
        );
}

class ExitDialog extends TwoOptionsDialog {
  final BuildContext context;

  ExitDialog(
      {Key? key,
      required this.context,
      required super.title,
      required super.text})
      : super(
          key: key,
          leftButton: Container(
            padding: const EdgeInsets.all(BUTTON_PADDING),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: APP_COLOR,
                  textStyle: const TextStyle(fontSize: BUTTON_FONT_SIZE)),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ),
          rightButton: Container(
            padding: const EdgeInsets.all(BUTTON_PADDING),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: BUTTON_GRAY_COLOR,
                  textStyle: const TextStyle(fontSize: BUTTON_FONT_SIZE)),
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
          ),
        );
}
