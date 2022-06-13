import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keep_playing_frontend/constants.dart';
import 'package:keep_playing_frontend/widgets/buttons.dart';
import 'package:keep_playing_frontend/widgets/dialogs.dart';
import 'package:keep_playing_frontend/widgets/events_views.dart';

import '../../api_manager.dart';
import '../../models/event.dart';
import '../../widgets/event_widgets.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<Event> feedEvents = [];

  _retrieveFeedEvents() async {
    List<Event> events = await API.retrievePendingEvents();

    setState(() {
      feedEvents = events;
    });
  }

  @override
  void initState() {
    _retrieveFeedEvents();
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
                      ))),
        ));
  }
}

class _FeedEventWidget extends StatelessWidget {
  final Event event;

  const _FeedEventWidget({required this.event});

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

class _DetailsButton extends ColoredButton {
  const _DetailsButton({Key? key, required super.onPressed})
      : super(
          key: key,
          text: 'Details',
          color: APP_COLOR,
        );
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

  const _AcceptJobDialog({required this.event});

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
                              API.eventHasCoach(event: event);
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
        ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('Location', style: _textStyleForTitle),
            subtitle: Text(event.location)),
        ListTile(
            leading: const Icon(Icons.date_range),
            title: const Text('Date', style: _textStyleForTitle),
            subtitle: Text(DateFormat("MMMM dd").format(event.date))),
        ListTile(
            leading: const Icon(Icons.timer),
            title: const Text('Start Time', style: _textStyleForTitle),
            subtitle: Text(const DefaultMaterialLocalizations().formatTimeOfDay(
                event.startTime,
                alwaysUse24HourFormat: true))),
        ListTile(
            leading: const Icon(Icons.timer),
            title: const Text('End Time', style: _textStyleForTitle),
            subtitle: Text(const DefaultMaterialLocalizations()
                .formatTimeOfDay(event.endTime, alwaysUse24HourFormat: true))),
        ListTile(
            leading: const Icon(Icons.timer),
            title: const Text('Flexible Start Time', style: _textStyleForTitle),
            subtitle: Text(const DefaultMaterialLocalizations().formatTimeOfDay(
                event.flexibleStartTime,
                alwaysUse24HourFormat: true))),
        ListTile(
            leading: const Icon(Icons.timer),
            title: const Text('Flexible End Time', style: _textStyleForTitle),
            subtitle: Text(const DefaultMaterialLocalizations()
                .formatTimeOfDay(event.flexibleEndTime, alwaysUse24HourFormat: true))),
        const Divider(),
        ListTile(
            leading: const Icon(Icons.details),
            title: const Text('Details', style: _textStyleForTitle),
            subtitle: Text(event.details)),
        const Divider(),
        lastWidget,
      ],
    );
  }

  static const TextStyle _textStyleForTextSpan = TextStyle(
    fontSize: 16.0,
    color: Colors.black,
  );
  static const TextStyle _textStyleForTitle =
      TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: APP_COLOR);

  Widget _detailTextWidget(String detail, String content) {
    return RichText(
      text: TextSpan(
        style: _textStyleForTextSpan,
        children: <TextSpan>[
          TextSpan(text: detail, style: _textStyleForTitle),
          TextSpan(text: content),
        ],
      ),
    );
  }

  Widget _showName() {
    return Text(event.name, style: _textStyleForTitle);
  }

  Widget _showLocation() {
    return _detailTextWidget('Location:\n', event.location);
  }

  Widget _showDate() {
    return _detailTextWidget(
        'Date: ', DateFormat("MMMM dd").format(event.date));
  }

  Widget _showStartTime() {
    return _detailTextWidget(
        'Start Time: ',
        const DefaultMaterialLocalizations()
            .formatTimeOfDay(event.startTime, alwaysUse24HourFormat: true));
  }

  Widget _showEndTime() {
    return _detailTextWidget(
        'End Time: ',
        const DefaultMaterialLocalizations()
            .formatTimeOfDay(event.endTime, alwaysUse24HourFormat: true));
  }

  Widget _showPay() {
    return _detailTextWidget('Pay: ', event.getPriceInPounds());
  }

  Widget _showDetails() {
    return _detailTextWidget('Details:\n', event.details);
  }
}
