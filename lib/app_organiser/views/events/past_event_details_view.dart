import 'package:flutter/material.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:keep_playing_frontend/models/user.dart';
import 'package:keep_playing_frontend/widgets/user_widgets.dart';

class PastEventDetailsView extends StatefulWidget {
  final Event event;

  const PastEventDetailsView({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  State<PastEventDetailsView> createState() => _PastEventDetailsViewState();
}

class _PastEventDetailsViewState extends State<PastEventDetailsView> {
  User? coach;

  @override
  void initState() {
    _retrieveCoachInformation();
    super.initState();
  }

  void _retrieveCoachInformation() async {
    User retrievedCoach = await API.user.getUser(widget.event.coachPK!);
    setState(() {
      coach = retrievedCoach;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (coach == null) {
      return const Text('Loading');
    }

    UserWidgets coachWidgets = UserWidgets(user: coach!);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Details about past event'),
        ),
        body: ListView(
          children: [
            coachWidgets.getCoachInformationCard(),
            ...coachWidgets.getDetailsAboutUser()
          ],
        ));
  }
}
