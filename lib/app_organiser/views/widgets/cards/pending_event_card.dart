import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/app_organiser/cubit/organiser_events_cubit.dart';
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
      User user = await API.users.getUser(offer);
      users.add(user);
    }

    setState(() {
      offers = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget offersButton = ColoredButton(
      text: offers.isEmpty ? 'No Offers' : 'Offers (${offers.length})',
      color: offers.isEmpty
          ? NO_OFFERS_BUTTON_COLOR
          : AT_LEAST_ONE_OFFER_BUTTON_COLOR,
      onPressed: () {
        if (offers.isNotEmpty) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return _OffersDialog(
                  event: widget.event,
                  button: CancelButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  children: _getOffersList(),
                );
              });
        }
      },
    );

    final Widget manageButton = ColoredButton(
      text: 'Manage',
      color: MANAGE_BUTTON_COLOR,
      onPressed: () => {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: BlocProvider.of<OrganiserEventsCubit>(context),
              child: ManageEventPage(event: widget.event),
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
      offersList.add(Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.person),
              title: Text("${offer.firstName} ${offer.lastName}"),
              subtitle: Text(offer.email),
            ),
            Center(
              child: _AcceptCoachButton(
                onPressed: () {
                  API.events.acceptCoach(event: widget.event, coach: offer);
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ), // children: [Text("${offer.firstName} ${offer.lastName}")],
      ));
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

class _AcceptCoachButton extends ColoredButton {
  const _AcceptCoachButton({Key? key, required super.onPressed})
      : super(
          key: key,
          text: 'Accept',
          color: APP_COLOR,
        );
}
