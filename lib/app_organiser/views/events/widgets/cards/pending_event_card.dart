import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/app_organiser/cubit/events_cubit.dart';
import 'package:keep_playing_frontend/constants.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:keep_playing_frontend/models/organiser.dart';
import 'package:keep_playing_frontend/models/user.dart';
import 'package:keep_playing_frontend/widgets/dialogs.dart';
import 'package:keep_playing_frontend/widgets/event_widgets.dart';
import 'package:keep_playing_frontend/widgets/loading_screen.dart';

import '../../manage_event_page.dart';

class PendingEventCard extends StatefulWidget {
  final Event event;

  const PendingEventCard({super.key, required this.event});

  @override
  State<PendingEventCard> createState() => _PendingEventCardState();
}

class _PendingEventCardState extends State<PendingEventCard> {
  Organiser? organiser;
  List<User> offers = [];

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

    final Widget offersButton = Container(
      padding: const EdgeInsets.fromLTRB(BUTTON_PADDING, 0, 0, BUTTON_PADDING),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: widget.event.offers.isEmpty
                ? NO_OFFERS_BUTTON_COLOR
                : AT_LEAST_ONE_OFFER_BUTTON_COLOR,
            textStyle: const TextStyle(fontSize: BUTTON_FONT_SIZE)),
        onPressed: () {
          if (widget.event.offers.isNotEmpty) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                final Widget backButton = Container(
                  padding: const EdgeInsets.fromLTRB(
                      0, 0, BUTTON_PADDING, BUTTON_PADDING),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: BACK_BUTTON_COLOR,
                        textStyle: const TextStyle(fontSize: BUTTON_FONT_SIZE)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Back'),
                  ),
                );

                return _OffersDialog(
                  event: widget.event,
                  button: backButton,
                  children: _getOffersList(),
                );
              },
            );
          }
        },
        child: Text(
          widget.event.offers.isEmpty
              ? 'No Offers'
              : 'Offers (${widget.event.offers.length})',
        ),
      ),
    );

    final Widget manageButton = Container(
      padding: const EdgeInsets.fromLTRB(0, 0, BUTTON_PADDING, BUTTON_PADDING),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: MANAGE_BUTTON_COLOR,
            textStyle: const TextStyle(fontSize: BUTTON_FONT_SIZE)),
        onPressed: () => {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ManageEventPage(
                eventsCubit: BlocProvider.of<EventsCubit>(context),
                event: widget.event,
              ),
            ),
          ),
        },
        child: const Text('Manage'),
      ),
    );

    return EventCard(
      event: widget.event,
      leftButton: offersButton,
      rightButton: manageButton,
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

      offersList.add(
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                leading: organiser!.hasUserAsAFavourite(offer)
                    ? const Icon(Icons.favorite, color: FAVOURITE_ICON_COLOR)
                    : const SizedBox(height: 0, width: 0),
                title: Text("${offer.firstName} ${offer.lastName}"),
                subtitle: Text(offer.email),
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

class _OffersDialog extends OneOptionDialog {
  final Event event;

  const _OffersDialog(
      {Key? key,
      required this.event,
      required super.children,
      required super.button})
      : super(
          key: key,
          title: 'Current Offers',
        );
}
