import 'package:flutter/material.dart';

import '../constants.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final MaterialColor color;
  final VoidCallback? onPressed;

  const CustomButton(
      {super.key,
      required this.text,
      required this.color,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(DEFAULT_PADDING),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: color,
                textStyle:
                    const TextStyle(fontSize: DEFAULT_FONT_SIZE_BUTTONS)),
            onPressed: onPressed,
            child: Text(text)));
  }
}

class NoButton extends CustomButton {
  const NoButton({Key? key, required super.onPressed})
      : super(
    key: key,
    text: 'No',
    color: APP_COLOR,
  );
}

class YesButton extends CustomButton {
  const YesButton({Key? key, required super.onPressed})
      : super(
    key: key,
    text: 'Yes',
    color: APP_COLOR,
  );
}

class CancelButton extends CustomButton {
  const CancelButton({Key? key, required super.onPressed})
      : super(
          key: key,
          text: 'Cancel',
          color: CANCEL_BUTTON_COLOR,
        );
}

class CancelEventButton extends CustomButton {
  const CancelEventButton({Key? key, required super.onPressed})
      : super(
          key: key,
          text: 'Cancel Event',
          color: CANCEL_BUTTON_COLOR,
        );
}

class MessageButton extends CustomButton {
  const MessageButton({Key? key, required super.onPressed})
      : super(
          key: key,
          text: 'Message',
          color: APP_COLOR,
        );
}

class AcceptButton extends CustomButton {
  const AcceptButton({Key? key, required super.onPressed})
      : super(
          key: key,
          text: 'Accept',
          color: APP_COLOR,
        );
}

class ManageButton extends CustomButton {
  const ManageButton({Key? key, required super.onPressed})
      : super(
          key: key,
          text: 'Manage',
          color: APP_COLOR,
        );
}

class DetailsButton extends CustomButton {
  const DetailsButton({Key? key, required super.onPressed})
      : super(
          key: key,
          text: 'Details',
          color: APP_COLOR,
        );
}

class TakeJobButton extends CustomButton {
  const TakeJobButton({Key? key, required super.onPressed})
      : super(
          key: key,
          text: 'Take Job',
          color: APP_COLOR,
        );
}

class SubmitButton extends CustomButton {
  const SubmitButton({Key? key, required super.onPressed})
      : super(
          key: key,
          text: 'Submit',
          color: APP_COLOR,
        );
}

class SaveChangesButton extends CustomButton {
  const SaveChangesButton({Key? key, required super.onPressed})
      : super(
    key: key,
    text: 'Save Changes',
    color: APP_COLOR,
  );
}