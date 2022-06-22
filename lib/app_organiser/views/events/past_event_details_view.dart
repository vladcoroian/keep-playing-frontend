import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/app_organiser/cubit/organiser_cubit.dart';
import 'package:keep_playing_frontend/constants.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:keep_playing_frontend/models/organiser.dart';
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

    final Widget coachInformationCard = BlocBuilder<OrganiserCubit, Organiser>(
      builder: (context, state) {
        final Widget leftButton = state.hasBlockedUser(coach!)
            ? _UnblockButton(coach: coach!)
            : _BlockButton(coach: coach!);

        final Widget rightButton = state.hasBlockedUser(coach!)
            ? const SizedBox(width: 0, height: 0)
            : (state.hasUserAsAFavourite(coach!)
                ? _RemoveFromFavouritesButton(coach: coach!)
                : _AddToFavouritesButton(coach: coach!));

        return Card(
          margin: const EdgeInsets.all(CARD_PADDING),
          child: Column(
            children: [
              coachInformationListTile,
              ButtonBar(
                alignment: MainAxisAlignment.spaceBetween,
                children: [leftButton, rightButton],
              ),
            ],
          ),
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Details about past event'),
      ),
      body: ListView(
        children: [
          coachInformationCard,
          ...UserWidgets(user: coach!).getDetailsAboutUser()
        ],
      ),
    );
  }
}

class _BlockButton extends StatelessWidget {
  final User coach;

  const _BlockButton({required this.coach});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(BUTTON_PADDING, 0, 0, 0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: BLOCK_BUTTON_COLOR,
          textStyle: const TextStyle(fontSize: BUTTON_FONT_SIZE),
        ),
        onPressed: () async {
          OrganiserCubit organiserCubit =
              BlocProvider.of<OrganiserCubit>(context);
          Response response = await API.organiser.blockCoach(coach);
          if (response.statusCode == HTTP_202_ACCEPTED) {
            organiserCubit.retrieveOrganiserInformation();
          } else {
            // TODO
          }
        },
        child: const Text('Block'),
      ),
    );
  }
}

class _UnblockButton extends StatelessWidget {
  final User coach;

  const _UnblockButton({required this.coach});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(BUTTON_PADDING, 0, 0, 0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: UNBLOCK_BUTTON_COLOR,
          textStyle: const TextStyle(fontSize: BUTTON_FONT_SIZE),
        ),
        onPressed: () async {
          OrganiserCubit organiserCubit =
              BlocProvider.of<OrganiserCubit>(context);
          Response response = await API.organiser.unblockCoach(coach);
          if (response.statusCode == HTTP_202_ACCEPTED) {
            organiserCubit.retrieveOrganiserInformation();
          } else {
            // TODO
          }
        },
        child: const Text('Unblock'),
      ),
    );
  }
}

class _AddToFavouritesButton extends StatelessWidget {
  final User coach;

  const _AddToFavouritesButton({required this.coach});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(BUTTON_PADDING, 0, 0, 0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: APP_COLOR,
          textStyle: const TextStyle(fontSize: BUTTON_FONT_SIZE),
        ),
        onPressed: () async {
          OrganiserCubit organiserCubit =
              BlocProvider.of<OrganiserCubit>(context);
          Response response =
              await API.organiser.addCoachToFavouritesList(coach);
          if (response.statusCode == HTTP_202_ACCEPTED) {
            organiserCubit.retrieveOrganiserInformation();
          } else {
            // TODO
          }
        },
        child: const Text('Add to Favourites'),
      ),
    );
  }
}

class _RemoveFromFavouritesButton extends StatelessWidget {
  final User coach;

  const _RemoveFromFavouritesButton({required this.coach});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(BUTTON_PADDING, 0, 0, 0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: APP_COLOR,
          textStyle: const TextStyle(fontSize: BUTTON_FONT_SIZE),
        ),
        onPressed: () async {
          OrganiserCubit organiserCubit =
              BlocProvider.of<OrganiserCubit>(context);
          Response response =
              await API.organiser.removeCoachFromFavouritesList(coach);
          if (response.statusCode == HTTP_202_ACCEPTED) {
            organiserCubit.retrieveOrganiserInformation();
          } else {
            // TODO
          }
        },
        child: const Text('Remove from Favourites'),
      ),
    );
  }
}
