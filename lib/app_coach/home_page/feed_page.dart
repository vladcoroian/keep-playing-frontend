import 'package:flutter/material.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/constants.dart';
import 'package:keep_playing_frontend/widgets/buttons.dart';
import 'package:keep_playing_frontend/widgets/dialogs.dart';
import 'package:keep_playing_frontend/widgets/events_views.dart';

import '../../models/event.dart';
import '../../widgets/event_widgets.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<Event> feedEvents = [];
  int coachPK = 0;

  _retrieveFeedEvents() async {
    List<Event> events = await API.events.retrieveFutureEventsWith(pending: true);

    setState(() {
      feedEvents = events;
    });
  }

  _retrieveCoachPK() async {
    int pk = (await API.users.getCurrentUser()).pk;

    setState(() {
      coachPK = pk;
    });
  }

  @override
  void initState() {
    _retrieveFeedEvents();
    _retrieveCoachPK();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () async {
          _retrieveFeedEvents();
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Feed'),
          ),
          body: Center(
              child: ListViewOfEvents(
                  events: feedEvents,
                  eventWidgetBuilder: (Event event) => _FeedEventWidget(
                        event: event,
                        coachPK: coachPK,
                      ))),
        ));
  }
}

class _FeedEventWidget extends StatelessWidget {
  final Event event;
  final int coachPK;

  const _FeedEventWidget({required this.event, required this.coachPK});

  @override
  Widget build(BuildContext context) {
    final Widget detailsButton = _DetailsButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return _DetailsDialog(event: event);
            });
      },
    );

    final Widget applyButton = _ApplyButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return _AcceptJobDialog(event: event);
            });
      },
    );

    final Widget appliedButton = _AppliedButton(
      onPressed: () {},
    );

    return EventCard(
      event: event,
      leftButton: detailsButton,
      rightButton: event.offers.contains(coachPK) ? appliedButton : applyButton,
    );
  }
}

class _DetailsButton extends ColoredButton {
  const _DetailsButton({Key? key, required super.onPressed})
      : super(
          key: key,
          text: 'Details',
          color: DETAILS_BUTTON_COLOR,
        );
}

class _ApplyButton extends ColoredButton {
  const _ApplyButton({Key? key, required super.onPressed})
      : super(
          key: key,
          text: 'Apply',
          color: APP_COLOR,
        );
}

class _AppliedButton extends ColoredButton {
  const _AppliedButton({Key? key, required super.onPressed})
      : super(
          key: key,
          text: 'Applied',
          color: APPLIED_BUTTON_COLOR,
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

class _SendOfferButton extends ColoredButton {
  const _SendOfferButton({Key? key, required super.onPressed})
      : super(
          key: key,
          text: 'Send Offer',
          color: APP_COLOR,
        );
}

class _DetailsDialog extends StatelessWidget {
  final Event event;

  const _DetailsDialog({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EventDetailsDialog(
      event: event,
      widgetsAtTheEnd: [
        Align(
          alignment: Alignment.center,
          child: _CancelButton(onPressed: () => {Navigator.pop(context)}),
        ),
      ],
    );
  }
}

class _AcceptJobDialog extends StatelessWidget {
  final Event event;

  const _AcceptJobDialog({required this.event});

  @override
  Widget build(BuildContext context) {
    final Widget sendOffer = _SendOfferButton(
        onPressed: () => {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ConfirmationDialog(
                      title: 'Are you sure that you want to accept this job?',
                      onNoPressed: () => {Navigator.pop(context)},
                      onYesPressed: () {
                        API.events.applyToJob(event: event);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    );
                  })
            });

    final Widget cancelButton =
        _CancelButton(onPressed: () => {Navigator.pop(context)});

    return EventDetailsDialog(event: event, widgetsAtTheEnd: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          sendOffer,
          cancelButton,
        ],
      ),
    ]);
  }
}
