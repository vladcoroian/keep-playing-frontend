import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/app_organiser/cubit/events_cubit.dart';
import 'package:keep_playing_frontend/constants.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:keep_playing_frontend/models/user.dart';
import 'package:keep_playing_frontend/widgets/buttons.dart';
import 'package:keep_playing_frontend/widgets/dialogs.dart';
import 'package:keep_playing_frontend/widgets/event_widgets.dart';

import '../../manage_event_page.dart';

class PendingEventCard extends StatefulWidget {
  final Event event;

  const PendingEventCard({super.key, required this.event});

  @override
  State<PendingEventCard> createState() => _PendingEventCardState();
}

class _PendingEventCardState extends State<PendingEventCard> {
  List<User> offers = [];

  @override
  void initState() {
    _retrieveOffers();
    super.initState();
  }

  void _retrieveOffers() async {
    List<User> users = [];
    for (var offer in widget.event.offers) {
      User user = await API.user.getUser(offer);
      users.add(user);
    }

    setState(() {
      offers = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget offersButton = ColoredButton(
      text: widget.event.offers.isEmpty
          ? 'No Offers'
          : 'Offers (${widget.event.offers.length})',
      color: widget.event.offers.isEmpty
          ? NO_OFFERS_BUTTON_COLOR
          : AT_LEAST_ONE_OFFER_BUTTON_COLOR,
      onPressed: () {
        if (widget.event.offers.isNotEmpty) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              final Widget cancelButton = ColoredButton(
                text: 'Cancel',
                color: CANCEL_BUTTON_COLOR,
                onPressed: () {
                  Navigator.pop(context);
                },
              );

              return _OffersDialog(
                event: widget.event,
                button: cancelButton,
                children: _getOffersList(),
              );
            },
          );
        }
      },
    );

    final Widget manageButton = ColoredButton(
      text: 'Manage',
      color: MANAGE_BUTTON_COLOR,
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
      final Widget acceptButton = ColoredButton(
        text: 'Accept',
        color: APP_COLOR,
        onPressed: () async {
          NavigatorState navigator = Navigator.of(context);
          EventsCubit eventsCubit = BlocProvider.of<EventsCubit>(context);
          await API.organiser.acceptCoach(event: widget.event, coach: offer);
          eventsCubit.retrieveEvents();
          navigator.pop();
        },
      );

      offersList.add(
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.person),
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