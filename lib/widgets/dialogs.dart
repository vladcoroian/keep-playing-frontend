import 'package:flutter/material.dart';

import '../constants.dart';
import 'buttons.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String text;
  final Widget leftButton;
  final Widget rightButton;

  const CustomDialog(
      {super.key,
      required this.title,
      required this.text,
      required this.leftButton,
      required this.rightButton});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(DEFAULT_PADDING),
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

class ConfirmationDialog extends CustomDialog {
  final VoidCallback? onCancelPressed;
  final VoidCallback? onAcceptPressed;

  ConfirmationDialog(
      {Key? key,
      required super.title,
      required this.onCancelPressed,
      required this.onAcceptPressed})
      : super(
            key: key,
            text: '',
            leftButton: CancelButton(onPressed: onCancelPressed),
            rightButton: AcceptButton(onPressed: onAcceptPressed));
}

class ExitDialog extends CustomDialog {
  final BuildContext context;

  ExitDialog(
      {Key? key,
      required this.context,
      required super.title,
      required super.text})
      : super(
            key: key,
            leftButton: TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            rightButton: TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes')));
}
