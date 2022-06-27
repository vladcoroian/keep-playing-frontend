import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/constants.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:keep_playing_frontend/models/user.dart';
import 'package:keep_playing_frontend/widgets/buttons.dart';
import 'package:keep_playing_frontend/widgets/dialogs.dart';
import 'package:keep_playing_frontend/widgets/icons.dart';
import 'package:keep_playing_frontend/widgets/loading_widgets.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UserWidgets {
  final User user;

  UserWidgets({required this.user});

  static const TextStyle _textStyleForTitle =
      TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: APP_COLOR);

  List<Widget> getDetailsAboutUser() {
    return <Widget>[
      ListTile(
        leading: UserIcons.NAME_ICON,
        title: const Text('Name', style: _textStyleForTitle),
        subtitle: Text('${user.firstName} ${user.lastName}'),
      ),
      ListTile(
        leading: UserIcons.EMAIL_ICON,
        title: const Text('Email', style: _textStyleForTitle),
        subtitle: Text(user.email),
      ),
      ListTile(
        leading: UserIcons.LOCATION_ICON,
        title: const Text('Location', style: _textStyleForTitle),
        subtitle: Text(user.location),
      ),
    ];
  }
}

// **************************************************************************
// **************** COACH INFORMATION
// **************************************************************************

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
      child: UserIcons.EMAIL_ICON,
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
            builder: (_) => CoachInformationDialog.byUser(coach));
      },
    );
  }
}

class CoachInformationDialog {
  static Widget byUser(User user) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(DIALOG_PADDING),
      title: const Center(
        child: Text(
          'Coach Information',
          style: UserWidgets._textStyleForTitle,
          textScaleFactor: 1.5,
        ),
      ),
      children: UserWidgets(user: user).getDetailsAboutUser(),
    );
  }

  static Widget byUserPK(int pk) {
    return _CoachPKInformationDialog(coachPK: pk);
  }
}

class _CoachPKInformationDialog extends StatefulWidget {
  final int coachPK;

  const _CoachPKInformationDialog({
    Key? key,
    required this.coachPK,
  }) : super(key: key);

  @override
  State<_CoachPKInformationDialog> createState() =>
      _CoachPKInformationDialogState();
}

class _CoachPKInformationDialogState extends State<_CoachPKInformationDialog> {
  User? _coach;

  @override
  void initState() {
    _retrieveCoachInformation();

    super.initState();
  }

  void _retrieveCoachInformation() async {
    User? retrievedCoach = await API.user.getUser(widget.coachPK);

    setState(() {
      _coach = retrievedCoach;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool coachInformationIsNotLoaded = _coach == null;

    if (coachInformationIsNotLoaded) {
      return const LoadingDialog();
    }

    return CoachInformationDialog.byUser(_coach!);
  }
}
