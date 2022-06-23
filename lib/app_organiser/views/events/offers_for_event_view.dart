import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/app_organiser/cubit/events_cubit.dart';
import 'package:keep_playing_frontend/constants.dart';
import 'package:keep_playing_frontend/models/coach.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:keep_playing_frontend/models/organiser.dart';
import 'package:keep_playing_frontend/models/user.dart';
import 'package:keep_playing_frontend/widgets/loading_widgets.dart';

class OffersForEventView extends StatefulWidget {
  final Event event;

  const OffersForEventView({Key? key, required this.event}) : super(key: key);

  @override
  State<OffersForEventView> createState() => _OffersForEventViewState();
}

class _OffersForEventViewState extends State<OffersForEventView> {
  Organiser? organiser;
  List<User> offers = [];
  Map<User, CoachRating> coachRatingMap = {};

  @override
  void initState() {
    _retrieveOrganiser();
    _retrieveOffers();
    super.initState();
  }

  void _retrieveOrganiser() async {
    Organiser retrievedOrganiser = await API.organiser.getOrganiser();

    setState(() {
      organiser = retrievedOrganiser;
    });
  }

  void _retrieveOffers() async {
    List<User> users = [];
    for (var offer in widget.event.offers) {
      User user = await API.user.getUser(offer);
      CoachRating coachRating = await API.organiser.getCoachRating(user);
      coachRatingMap[user] = coachRating;
      users.add(user);
    }
    users.sort(
      (User user1, User user2) =>
          (organiser!.hasUserAsAFavourite(user2) ? 1 : 0) -
          (organiser!.hasUserAsAFavourite(user1) ? 1 : 0),
    );

    setState(() {
      offers = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (organiser == null) {
      return const LoadingScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Current Offers'),
      ),
      body: ListView(
        children: _getOffersList(),
      ),
    );
  }

  List<Widget> _getOffersList() {
    List<Widget> offersList = [];

    for (User offer in offers) {
      final Widget acceptButton = Container(
        padding:
            const EdgeInsets.fromLTRB(0, 0, BUTTON_PADDING, BUTTON_PADDING),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: APP_COLOR,
              textStyle: const TextStyle(fontSize: BUTTON_FONT_SIZE)),
          onPressed: () async {
            NavigatorState navigator = Navigator.of(context);
            EventsCubit eventsCubit = BlocProvider.of<EventsCubit>(context);
            await API.organiser.acceptCoach(event: widget.event, coach: offer);
            eventsCubit.retrieveEvents();
            navigator.pop();
          },
          child: const Text('Accept'),
        ),
      );

      final Widget experienceRatingBar = RatingBarIndicator(
        rating: coachRatingMap[offer]!.getExperienceAverage(),
        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
        itemBuilder: (context, _) => const Icon(
          Icons.star,
          color: Colors.amber,
        ),
        itemSize: 20.0,
      );

      final Widget flexibilityRatingBar = RatingBarIndicator(
        rating: coachRatingMap[offer]!.getFlexibilityAverage(),
        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
        itemBuilder: (context, _) => const Icon(
          Icons.star,
          color: Colors.amber,
        ),
        itemSize: 20.0,
      );

      final Widget reliabilityRatingBar = RatingBarIndicator(
        rating: coachRatingMap[offer]!.getExperienceAverage(),
        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
        itemBuilder: (context, _) => const Icon(
          Icons.star,
          color: Colors.amber,
        ),
        itemSize: 20.0,
      );

      final experienceRow = Row(
        children: [
          const Text('Experienced'),
          experienceRatingBar,
        ],
      );

      final flexibilityRow = Row(
        children: [
          const Text('Flexible'),
          flexibilityRatingBar,
        ],
      );

      final reliabilityRow = Row(
        children: [
          const Text('Reliable'),
          reliabilityRatingBar,
        ],
      );

      offersList.add(
        Card(
          margin: const EdgeInsets.all(CARD_PADDING),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                leading: organiser!.hasUserAsAFavourite(offer)
                    ? const Icon(Icons.favorite, color: FAVOURITE_ICON_COLOR)
                    : const SizedBox(height: 0, width: 0),
                title: Text("${offer.firstName} ${offer.lastName}"),
                subtitle: Column(
                  children: [
                    experienceRow,
                    flexibilityRow,
                    reliabilityRow,
                  ],
                ),
              ),
              Center(child: acceptButton),
            ],
          ), // children: [Text("${offer.firstName} ${offer.lastName}")],
        ),
      );
    }

    return offersList;
  }
}
