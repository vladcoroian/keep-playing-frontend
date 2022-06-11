import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:keep_playing_frontend/constants.dart';
import 'package:keep_playing_frontend/widgets/buttons.dart';
import 'package:keep_playing_frontend/widgets/dialogs.dart';

import '../../models/event.dart';
import '../../urls.dart';
import '../../widgets/event_widgets.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _DetailsButton extends ColoredButton {
  const _DetailsButton({Key? key, required super.onPressed})
      : super(
    key: key,
    text: 'Details',
    color: APP_COLOR,
  );
}

class _FeedPageState extends State<FeedPage> {
  Client client = http.Client();
  List<Event> events = [];

  @override
  void initState() {
    _retrieveEvents();
    super.initState();
  }

  _retrieveEvents() async {
    events = [];
    List response = json.decode((await client.get(Uri.parse(URL.EVENTS))).body);
    for (var element in response) {
      events.add(Event.fromJson(element));
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feed')),
      body: RefreshIndicator(
        onRefresh: () async {
          _retrieveEvents();
        },
        child: ListView.builder(
          itemCount: events.length,
          itemBuilder: (BuildContext context, int index) {
            if (events[index].coach) {
              return const SizedBox(width: 0, height: 0);
            }
            return FeedEventWidget(event: events[index]);
          },
        ),
      ),
    );
  }
}

class FeedEventWidget extends StatelessWidget {
  final Event event;

  const FeedEventWidget({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return EventWidget(
        event: event,
        leftButton: _DetailsButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return _EventDetailsDialog(event: event);
                });
          },
        ),
        rightButton: _TakeJobButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return _AcceptJobDialog(event: event);
                });
          },
        ));
  }
}

class _TakeJobButton extends ColoredButton {
  const _TakeJobButton({Key? key, required super.onPressed})
      : super(
          key: key,
          text: 'Take Job',
          color: APP_COLOR,
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

class _AcceptButton extends ColoredButton {
  const _AcceptButton({Key? key, required super.onPressed})
      : super(
          key: key,
          text: 'Accept',
          color: APP_COLOR,
        );
}

class _EventDetailsDialog extends StatelessWidget {
  final Event event;

  const _EventDetailsDialog({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _DetailsAndAcceptJobsDialogBuilder(
      event: event,
      lastWidget: Align(
        alignment: Alignment.center,
        child: _CancelButton(onPressed: () => {Navigator.pop(context)}),
      ),
    );
  }
}

class _AcceptJobDialog extends StatelessWidget {
  final Event event;

  final Client client = http.Client();

  _AcceptJobDialog({required this.event});

  @override
  Widget build(BuildContext context) {
    return _DetailsAndAcceptJobsDialogBuilder(
      event: event,
      lastWidget: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _AcceptButton(
              onPressed: () => {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ConfirmationDialog(
                            title:
                                'Are you sure that you want to accept this job?',
                            onNoPressed: () => {Navigator.pop(context)},
                            onYesPressed: () {
                              client.patch(URL.updateEvent(event.pk),
                                  body: {"coach": "true"});
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                          );
                        })
                  }),
          _CancelButton(onPressed: () => {Navigator.pop(context)}),
        ],
      ),
    );
  }
}

class _DetailsAndAcceptJobsDialogBuilder extends StatelessWidget {
  final Event event;
  final Widget lastWidget;

  static const double SPACE_BETWEEN_ROWS = 10;

  const _DetailsAndAcceptJobsDialogBuilder(
      {required this.event, required this.lastWidget});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(DEFAULT_PADDING),
      title: Center(child: _showName()),
      children: <Widget>[
        _showLocation(),
        const SizedBox(height: SPACE_BETWEEN_ROWS),
        _showDate(),
        const SizedBox(height: SPACE_BETWEEN_ROWS),
        _showStartTime(),
        const SizedBox(height: SPACE_BETWEEN_ROWS),
        _showEndTime(),
        const SizedBox(height: SPACE_BETWEEN_ROWS),
        _showPay(),
        const SizedBox(height: SPACE_BETWEEN_ROWS),
        const Divider(),
        _showDetails(),
        const Divider(),
        lastWidget,
      ],
    );
  }

  static const TextStyle _textStyleForTextSpan = TextStyle(
    fontSize: 16.0,
    color: Colors.black,
  );
  static const TextStyle _textStyleForDetails =
      TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: APP_COLOR);

  Widget _detailTextWidget(String detail, String content) {
    return RichText(
      text: TextSpan(
        style: _textStyleForTextSpan,
        children: <TextSpan>[
          TextSpan(text: detail, style: _textStyleForDetails),
          TextSpan(text: content),
        ],
      ),
    );
  }

  Widget _showName() {
    return Text(event.name, style: _textStyleForDetails);
  }

  Widget _showLocation() {
    return _detailTextWidget('Location:\n', event.location);
  }

  Widget _showDate() {
    return _detailTextWidget(
        'Date: ', DateFormat("MMMM dd").format(event.getDate()));
  }

  Widget _showStartTime() {
    return _detailTextWidget('Start Time: ', event.getStartTimeToString());
  }

  Widget _showEndTime() {
    return _detailTextWidget('End Time: ', event.getEndTimeToString());
  }

  Widget _showPay() {
    return _detailTextWidget('Pay: ', event.getPriceInPounds());
  }

  Widget _showDetails() {
    return _detailTextWidget('Details:\n', event.details);
  }
}
