import 'package:flutter/material.dart';
import 'package:keep_playing_frontend/constants.dart';

const double BUTTON_PADDING = 16;
const double BUTTON_FONT_SIZE = 16;
const Color BUTTON_GRAY_COLOR = Colors.black12;

const Color MANAGE_BUTTON_COLOR = APP_COLOR;
const Color DETAILS_BUTTON_COLOR = Colors.black12;
const Color CANCEL_BUTTON_COLOR = Colors.red;
const Color APPLIED_BUTTON_COLOR = Colors.red;
const Color NO_OFFERS_BUTTON_COLOR = BUTTON_GRAY_COLOR;
const Color AT_LEAST_ONE_OFFER_BUTTON_COLOR = Colors.lightGreen;

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
        padding: const EdgeInsets.all(BUTTON_PADDING),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: color,
                textStyle: const TextStyle(fontSize: BUTTON_FONT_SIZE)),
            onPressed: onPressed,
            child: Text(text)));
  }
}

class DetailsButton extends ColoredButton {
  const DetailsButton({Key? key, required super.onPressed})
      : super(
          key: key,
          text: 'Details',
          color: DETAILS_BUTTON_COLOR,
        );
}

class CancelButton extends ColoredButton {
  const CancelButton({Key? key, required super.onPressed})
      : super(
          key: key,
          text: 'Cancel',
          color: CANCEL_BUTTON_COLOR,
        );
}

class ManageButton extends ColoredButton {
  const ManageButton({Key? key, required super.onPressed})
      : super(
          key: key,
          text: 'Manage',
          color: APP_COLOR,
        );
}
