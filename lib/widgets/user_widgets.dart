import 'package:flutter/material.dart';
import 'package:keep_playing_frontend/constants.dart';
import 'package:keep_playing_frontend/models/user.dart';
import 'package:keep_playing_frontend/widgets/dialogs.dart';

class UserWidgets {
  final User user;

  UserWidgets({required this.user});

  static const TextStyle _textStyleForTitle =
      TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: APP_COLOR);

  List<Widget> getDetailsAboutUser() {
    return <Widget>[
      ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Name', style: _textStyleForTitle),
          subtitle: Text('${user.firstName} ${user.lastName}')),
      ListTile(
          leading: const Icon(Icons.email),
          title: const Text('Email', style: _textStyleForTitle),
          subtitle: Text(user.email)),
      ListTile(
          leading: const Icon(Icons.location_on),
          title: const Text('Location', style: _textStyleForTitle),
          subtitle: Text(user.location)),
    ];
  }
}

class CoachInformationDialog extends StatelessWidget {
  final User user;

  const CoachInformationDialog({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        contentPadding: const EdgeInsets.all(DIALOG_PADDING),
        title: const Center(
            child: Text(
          'Coach Information',
          style: UserWidgets._textStyleForTitle,
          textScaleFactor: 1.5,
        )),
        children: UserWidgets(user: user).getDetailsAboutUser());
  }
}
