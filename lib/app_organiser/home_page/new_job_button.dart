import 'package:flutter/material.dart';
import 'package:keep_playing_frontend/constants.dart';

class NewJobButton extends FloatingActionButton {
  final BuildContext context;

  const NewJobButton(
      {Key? key, required this.context, required super.onPressed})
      : super.extended(
          key: key,
          extendedTextStyle:
              const TextStyle(fontSize: DEFAULT_BUTTON_FONT_SIZE),
          tooltip: 'Increment',
          icon: const Icon(Icons.add),
          label: const Text("New Job"),
        );
}