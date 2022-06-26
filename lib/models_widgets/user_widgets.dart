import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keep_playing_frontend/constants.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:keep_playing_frontend/models/user.dart';
import 'package:keep_playing_frontend/widgets/buttons.dart';
import 'package:keep_playing_frontend/widgets/dialogs.dart';
import 'package:url_launcher/url_launcher_string.dart';

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

class CoachInformationListTile extends StatelessWidget {
  final User coach;
  final Event event;

  const CoachInformationListTile({
    super.key,
    required this.coach,
    required this.event,
  });

  Future _launchEmail({
    required String toEmail,
    required String subject,
  }) async {
    final url = 'mailto:$toEmail?subject=${Uri.encodeFull(subject)}&body=';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget messageCoachButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: APP_COLOR,
          textStyle: const TextStyle(fontSize: BUTTON_FONT_SIZE)),
      onPressed: () {
        _launchEmail(
          toEmail: coach.email,
          subject:
              '${event.name}, on: ${DateFormat.MMMEd().format(event.date)}',
        );
      },
      child: const Icon(Icons.email),
    );

    return ListTile(
      leading: const Text(
        "Coach\nInformation",
        textAlign: TextAlign.center,
        style: TextStyle(color: APP_COLOR),
      ),
      title: Text(coach.getFullName()),
      trailing: messageCoachButton,
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => _CoachInformationDialog(
            coach: coach,
          ),
        );
      },
    );
  }
}

class _CoachInformationDialog extends StatelessWidget {
  final User coach;

  const _CoachInformationDialog({
    Key? key,
    required this.coach,
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
          ),
        ),
        children: UserWidgets(user: coach).getDetailsAboutUser());
  }
}
