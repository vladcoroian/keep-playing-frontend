import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:keep_playing_frontend/widgets/events.dart';
import '../../../constants.dart';
import '../../../models/event.dart';
import '../../../urls.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/dialogs.dart';

class FeedEventWidget extends StatelessWidget {
  final Event event;

  const FeedEventWidget({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return EventWidget(
        event: event,
        leftButton: DetailsButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DetailsDialog(event: event);
                });
          },
        ),
        rightButton: TakeJobButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AcceptDialog(event: event);
                });
          },
        ));
  }
}

class DetailsDialog extends StatelessWidget {
  final Event event;

  const DetailsDialog({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DetailsAndAcceptDialogBuilder(
      event: event,
      lastWidget: Align(
        alignment: Alignment.center,
        child: CancelButton(onPressed: () => {Navigator.pop(context)}),
      ),
    );
  }
}

class AcceptDialog extends StatelessWidget {
  final Event event;

  final Client client = http.Client();

  AcceptDialog({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return DetailsAndAcceptDialogBuilder(
      event: event,
      lastWidget: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CancelButton(onPressed: () => {Navigator.pop(context)}),
          AcceptButton(
              onPressed: () => {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ConfirmationDialog(
                            title:
                                'Are you sure that you want to accept this job?',
                            onCancelPressed: () => {Navigator.pop(context)},
                            onAcceptPressed: () {
                              client.patch(URL.updateEvent(event.pk),
                                  body: {"coach": "true"});
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                          );
                        })
                  })
        ],
      ),
    );
  }
}

class DetailsAndAcceptDialogBuilder extends StatelessWidget {
  final Event event;
  final Widget lastWidget;

  const DetailsAndAcceptDialogBuilder(
      {super.key, required this.event, required this.lastWidget});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(DEFAULT_PADDING),
      title: Center(child: _showName()),
      children: <Widget>[
        _showLocation(),
        const SizedBox(height: DEFAULT_PADDING),
        _showDate(),
        const SizedBox(height: DEFAULT_PADDING),
        _showStartTime(),
        const SizedBox(height: DEFAULT_PADDING),
        _showEndTime(),
        const SizedBox(height: DEFAULT_PADDING),
        _showPay(),
        const SizedBox(height: DEFAULT_PADDING),
        const Divider(),
        Text(event.details),
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
      TextStyle(fontWeight: FontWeight.bold, color: APP_COLOR);

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
}
