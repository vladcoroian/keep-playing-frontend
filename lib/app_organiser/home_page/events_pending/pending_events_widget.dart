import 'package:flutter/material.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/constants.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:keep_playing_frontend/models/user.dart';
import 'package:keep_playing_frontend/widgets/buttons.dart';
import 'package:keep_playing_frontend/widgets/dialogs.dart';
import 'package:keep_playing_frontend/widgets/event_widgets.dart';

import '../events/manage_event.dart';

class PendingEventWidget extends StatefulWidget {
  final Event event;

  const PendingEventWidget({super.key, required this.event});

  @override
  State<PendingEventWidget> createState() => _PendingEventWidgetState();
}

class _PendingEventWidgetState extends State<PendingEventWidget> {
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
    final Widget listOfCoaches = Container(
        height: 300.0, // Change as per your requirement
        width: 300.0,
        child: ListView.builder(
          itemCount: widget.event.offers.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
                margin: const EdgeInsets.all(DEFAULT_PADDING),
                child: ListTile(
                  title: Text(
                      "${offers[index].firstName} ${offers[index].lastName}"),
                  trailing: _AcceptCoachButton(
                    onPressed: () {
                      API.events.acceptCoach(
                          event: widget.event, coach: offers[index]);
                    },
                  ),
                ));
          },
        ));

    return EventWidget(
        event: widget.event,
        leftButton: _OffersButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return _OffersDialog(
                    event: widget.event,
                    body: listOfCoaches,
                    button: _CancelButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  );
                });
          },
        ),
        rightButton: _ManageButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ManageEventPage(event: widget.event)),
            );
          },
        ));
  }
}

class _OffersButton extends ColoredButton {
  const _OffersButton({Key? key, required super.onPressed})
      : super(
          key: key,
          text: 'Offers',
          color: BUTTON_GRAY_COLOR,
        );
}

class _ManageButton extends ColoredButton {
  const _ManageButton({Key? key, required super.onPressed})
      : super(
          key: key,
          text: 'Manage',
          color: APP_COLOR,
        );
}

class _OffersDialog extends OneOptionDialog {
  final Event event;

  const _OffersDialog(
      {Key? key,
      required this.event,
      required super.body,
      required super.button})
      : super(
          key: key,
          title: 'Current Offers',
        );
}

class _CancelButton extends ColoredButton {
  const _CancelButton({Key? key, required super.onPressed})
      : super(
          key: key,
          text: 'Cancel',
          color: CANCEL_BUTTON_COLOR,
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
