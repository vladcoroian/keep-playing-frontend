import 'package:flutter/material.dart';

import '../constants.dart';

class ColoredButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback? onPressed;

  const ColoredButton(
      {super.key,
      required this.text,
      required this.color,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(DEFAULT_BUTTON_PADDING),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: color,
                textStyle: const TextStyle(fontSize: DEFAULT_BUTTON_FONT_SIZE)),
            onPressed: onPressed,
            child: Text(text)));
  }
}
