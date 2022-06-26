import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/app_organiser/cubit/events_cubit.dart';
import 'package:keep_playing_frontend/app_organiser/cubit/organiser_cubit.dart';
import 'package:keep_playing_frontend/constants.dart';
import 'package:keep_playing_frontend/models/coach.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:keep_playing_frontend/models/organiser.dart';
import 'package:keep_playing_frontend/models/user.dart';
import 'package:keep_playing_frontend/models_widgets/event_widgets.dart';
import 'package:keep_playing_frontend/models_widgets/user_widgets.dart';
import 'package:keep_playing_frontend/widgets/buttons.dart';
import 'package:keep_playing_frontend/widgets/dialogs.dart';
import 'package:keep_playing_frontend/widgets/loading_widgets.dart';

class PastEventDetailsView extends StatefulWidget {
  static const String _title = 'Details about past event';

  final Event event;

  const PastEventDetailsView({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  State<PastEventDetailsView> createState() => _PastEventDetailsViewState();
}

class _PastEventDetailsViewState extends State<PastEventDetailsView> {
  User? _coach;
  bool _coachInformationIsLoaded = false;

  @override
  void initState() {
    _retrieveCoachInformation();

    super.initState();
  }

  void _retrieveCoachInformation() async {
    User? retrievedCoach = widget.event.coachPK == null
        ? null
        : await API.user.getUser(widget.event.coachPK!);

    setState(() {
      _coach = retrievedCoach;
      _coachInformationIsLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool coachInformationIsNotLoaded = !_coachInformationIsLoaded;

    if (coachInformationIsNotLoaded) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(PastEventDetailsView._title),
        ),
        body: LOADING_CIRCLE,
      );
    }

    final Widget blockButton = BlocBuilder<OrganiserCubit, Organiser>(
      builder: (context, state) {
        return state.hasBlockedUser(_coach!)
            ? _UnblockButton(coach: _coach!)
            : _BlockButton(coach: _coach!);
      },
    );

    final Widget favouriteButton = BlocBuilder<OrganiserCubit, Organiser>(
      builder: (context, state) {
        return state.hasBlockedUser(_coach!)
            ? const SizedBox(width: 0, height: 0)
            : (state.hasUserAsAFavourite(_coach!)
                ? _RemoveFromFavouritesButton(coach: _coach!)
                : _AddToFavouritesButton(coach: _coach!));
      },
    );

    final Widget rateButton = BlocBuilder<EventsCubit, List<Event>>(
      builder: (context, state) {
        return widget.event.rated
            ? _RatedButton()
            : _RateButton(event: widget.event);
      },
    );

    final Widget coachInformationCard = _coach == null
        ? const Card(
            margin: EdgeInsets.all(CARD_PADDING),
            child: ListTile(
              title: Center(child: Text('This event didn\'t have a coach.')),
            ),
          )
        : Card(
            margin: const EdgeInsets.all(CARD_PADDING),
            child: Column(
              children: [
                CoachInformationListTile(coach: _coach!, event: widget.event),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceBetween,
                  children: [blockButton, favouriteButton],
                ),
                rateButton,
              ],
            ),
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text(PastEventDetailsView._title),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          BlocProvider.of<EventsCubit>(context).retrieveEvents();
          BlocProvider.of<OrganiserCubit>(context)
              .retrieveOrganiserInformation();
        },
        child: ListView(
          children: [
            coachInformationCard,
            ...EventWidgets(event: widget.event).getDetailsTilesAboutEvent()
          ],
        ),
      ),
    );
  }
}

// **************************************************************************
// **************** BUTTONS
// **************************************************************************

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
            showDialog(
              context: context,
              builder: (_) => const RequestFailedDialog(),
              barrierDismissible: false,
            );
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
            showDialog(
              context: context,
              builder: (_) => const RequestFailedDialog(),
              barrierDismissible: false,
            );
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
      padding: const EdgeInsets.fromLTRB(0, 0, BUTTON_PADDING, 0),
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
            showDialog(
              context: context,
              builder: (_) => const RequestFailedDialog(),
              barrierDismissible: false,
            );
          }
        },
        child: const Text('Add Favourite'),
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
      padding: const EdgeInsets.fromLTRB(0, 0, BUTTON_PADDING, 0),
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
            showDialog(
              context: context,
              builder: (_) => const RequestFailedDialog(),
              barrierDismissible: false,
            );
          }
        },
        child: const Text('Remove Favourite'),
      ),
    );
  }
}

class _RateButton extends StatelessWidget {
  final Event event;

  const _RateButton({required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
          BUTTON_PADDING, 0, BUTTON_PADDING, BUTTON_PADDING),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: RATE_BUTTON_COLOR,
          textStyle: const TextStyle(fontSize: BUTTON_FONT_SIZE),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) {
              return BlocProvider<EventsCubit>.value(
                value: BlocProvider.of<EventsCubit>(context),
                child: _RateDialog(event: event),
              );
            },
          );
        },
        child: const Text('Rate'),
      ),
    );
  }
}

class _RatedButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
          BUTTON_PADDING, 0, BUTTON_PADDING, BUTTON_PADDING),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: RATED_BUTTON_COLOR,
          textStyle: const TextStyle(fontSize: BUTTON_FONT_SIZE),
        ),
        onPressed: () {},
        child: const Text('Rated'),
      ),
    );
  }
}

// **************************************************************************
// **************** DIALOGS
// **************************************************************************

class _RateDialog extends StatefulWidget {
  final Event event;

  const _RateDialog({required this.event});

  @override
  State<_RateDialog> createState() => _RateDialogState();
}

class _RateDialogState extends State<_RateDialog> {
  double _experienceRating = 3;

  double _flexibilityRating = 3;

  double _reliabilityRating = 3;

  @override
  Widget build(BuildContext context) {
    final Widget experienceRatingBar = RatingBar.builder(
      initialRating: _experienceRating,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: false,
      itemSize: 30.0,
      itemCount: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        _experienceRating = rating;
      },
    );

    final Widget flexibilityRatingBar = RatingBar.builder(
      initialRating: _flexibilityRating,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: false,
      itemSize: 30.0,
      itemCount: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        _flexibilityRating = rating;
      },
    );

    final Widget reliabilityRatingBar = RatingBar.builder(
      initialRating: _reliabilityRating,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: false,
      itemSize: 30.0,
      itemCount: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        _reliabilityRating = rating;
      },
    );

    final experienceListTile = ListTile(
      title: const Text('Experienced'),
      subtitle: experienceRatingBar,
    );

    final flexibilityListTile = ListTile(
      title: const Text('Flexible'),
      subtitle: flexibilityRatingBar,
    );

    final reliabilityListTile = ListTile(
      title: const Text('Reliable'),
      subtitle: reliabilityRatingBar,
    );

    final Widget sendRatingButton = Container(
      padding: const EdgeInsets.all(BUTTON_PADDING),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: SEND_RATING_BUTTON_COLOR,
            textStyle: const TextStyle(fontSize: BUTTON_FONT_SIZE)),
        onPressed: () async {
          NavigatorState navigator = Navigator.of(context);
          EventsCubit eventsCubit = BlocProvider.of<EventsCubit>(context);

          CoachNewRating coachNewRating = CoachNewRating(
            experience: _experienceRating.toInt(),
            flexibility: _flexibilityRating.toInt(),
            reliability: _reliabilityRating.toInt(),
          );

          final Response response = await API.organiser.rateEventCoach(
            event: widget.event,
            coachNewRating: coachNewRating,
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
        child: const Text('Send Rating'),
      ),
    );

    return SimpleDialog(
      contentPadding: const EdgeInsets.all(DIALOG_PADDING),
      title: const Center(child: Text('Rate')),
      children: <Widget>[
        experienceListTile,
        flexibilityListTile,
        reliabilityListTile,
        sendRatingButton,
      ],
    );
  }
}
