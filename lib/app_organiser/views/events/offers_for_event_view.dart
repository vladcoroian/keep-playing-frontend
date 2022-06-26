import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/app_organiser/cubit/events_cubit.dart';
import 'package:keep_playing_frontend/constants.dart';
import 'package:keep_playing_frontend/models/coach.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:keep_playing_frontend/models/organiser.dart';
import 'package:keep_playing_frontend/models/user.dart';
import 'package:keep_playing_frontend/widgets/buttons.dart';
import 'package:keep_playing_frontend/widgets/dialogs.dart';
import 'package:keep_playing_frontend/widgets/loading_widgets.dart';

class OffersForEventView extends StatefulWidget {
  static const String _title = 'Current Offers';

  final Event event;

  const OffersForEventView({Key? key, required this.event}) : super(key: key);

  @override
  State<OffersForEventView> createState() => _OffersForEventViewState();
}

class _OffersForEventViewState extends State<OffersForEventView> {
  Organiser? organiser;
  List<User>? offers;
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
    final bool organiserIsNotLoaded = organiser == null;
    final bool offersAreNotLoaded = offers == null;

    if (organiserIsNotLoaded || offersAreNotLoaded) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(OffersForEventView._title),
        ),
        body: LOADING_CIRCLE,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(OffersForEventView._title),
      ),
      body: ListView.builder(
        itemCount: offers!.length,
        itemBuilder: (_, index) {
          return _OfferCard(
            event: widget.event,
            organiser: organiser!,
            user: offers![index],
            coachRatingMap: coachRatingMap,
          );
        },
      ),
    );
  }
}

class _OfferCard extends StatelessWidget {
  final Event event;
  final Organiser organiser;
  final User user;
  final Map<User, CoachRating> coachRatingMap;

  const _OfferCard({
    required this.event,
    required this.organiser,
    required this.user,
    required this.coachRatingMap,
  });

  @override
  Widget build(BuildContext context) {
    final Widget leadingListTile = Column(
      children: [
        organiser.hasUserAsAFavourite(user)
            ? const Icon(Icons.favorite, color: FAVOURITE_ICON_COLOR)
            : const SizedBox(height: 0, width: 0),
        user.isVerified()
            ? const Icon(Icons.verified, color: VERIFIED_ICON_COLOR)
            : const SizedBox(width: 0, height: 0),
      ],
    );

    final Widget experienceRatingBar = RatingBarIndicator(
      rating: coachRatingMap[user]!.getExperienceAverage(),
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (_, __) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      itemSize: 20.0,
    );

    final Widget flexibilityRatingBar = RatingBarIndicator(
      rating: coachRatingMap[user]!.getFlexibilityAverage(),
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (_, __) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      itemSize: 20.0,
    );

    final Widget reliabilityRatingBar = RatingBarIndicator(
      rating: coachRatingMap[user]!.getReliabilityAverage(),
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (_, __) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      itemSize: 20.0,
    );

    final Widget experienceRow = Row(
      children: [
        const Text('Experienced'),
        const Spacer(),
        experienceRatingBar,
      ],
    );

    final Widget flexibilityRow = Row(
      children: [
        const Text('Flexible'),
        const Spacer(),
        flexibilityRatingBar,
      ],
    );

    final Widget reliabilityRow = Row(
      children: [
        const Text('Reliable'),
        const Spacer(),
        reliabilityRatingBar,
      ],
    );

    final Widget acceptButton = Container(
      padding: const EdgeInsets.fromLTRB(0, 0, BUTTON_PADDING, BUTTON_PADDING),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: APP_COLOR,
            textStyle: const TextStyle(fontSize: BUTTON_FONT_SIZE)),
        onPressed: () async {
          NavigatorState navigator = Navigator.of(context);
          EventsCubit eventsCubit = BlocProvider.of<EventsCubit>(context);

          final Response response = await API.organiser.acceptCoach(
            event: event,
            coach: user,
          );
          if (response.statusCode == HTTP_202_ACCEPTED) {
            eventsCubit.retrieveEvents();
            navigator.pop();
          } else {
            showDialog(
              context: context,
              builder: (_) => const RequestFailedDialog(),
              barrierDismissible: false,
            );
          }
        },
        child: const Text('Accept'),
      ),
    );

    return Card(
      margin: const EdgeInsets.all(CARD_PADDING),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: leadingListTile,
            title: Text("${user.firstName} ${user.lastName}"),
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
    );
  }
}
