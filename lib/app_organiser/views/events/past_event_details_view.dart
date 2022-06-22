import 'package:flutter/material.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/constants.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:keep_playing_frontend/models/user.dart';
import 'package:keep_playing_frontend/widgets/buttons.dart';
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

    final Widget coachInformationListTile = ListTile(
      leading: const Text(
        "Coach\nInformation",
        textAlign: TextAlign.center,
        style: TextStyle(color: APP_COLOR),
      ),
      title: Text(coach!.getFullName()),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => CoachInformationDialog(
            user: coach!,
          ),
        );
      },
    );

    final Widget addToFavouritesButton = Container(
      padding: const EdgeInsets.fromLTRB(0, 0, BUTTON_PADDING, 0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: APP_COLOR,
          textStyle: const TextStyle(fontSize: BUTTON_FONT_SIZE),
        ),
        onPressed: () {},
        child: const Text('Add To Favourites'),
      ),
    );

    final Widget blockButton = Container(
      padding: const EdgeInsets.fromLTRB(BUTTON_PADDING, 0, 0, 0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: BLOCK_BUTTON_COLOR,
          textStyle: const TextStyle(fontSize: BUTTON_FONT_SIZE),
        ),
        onPressed: () {},
        child: const Text('Block'),
      ),
    );

    final Widget coachInformationCard = Card(
      margin: const EdgeInsets.all(CARD_PADDING),
      child: Column(
        children: [
          coachInformationListTile,
          ButtonBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: [
              blockButton,
              addToFavouritesButton,
            ],
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Details about past event'),
      ),
      body: ListView(
        children: [coachInformationCard, ...coachWidgets.getDetailsAboutUser()],
      ),
    );
  }
}
