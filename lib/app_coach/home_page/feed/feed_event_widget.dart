import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keep_playing_frontend/widgets/event_widget.dart';

import '../../../constants.dart';
import '../../../models/event.dart';
import '../../../widgets/buttons.dart';

class FeedEventWidget extends StatelessWidget {
  final Event event;

  const FeedEventWidget({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return EventWidget(
        event: event,
        leftButton: DetailsButton(
          onPressed: () {},
        ),
        rightButton: TakeJobButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AcceptEventDialog(event: event);
                });
          },
        ));
  }
}

class AcceptEventDialog extends StatelessWidget {
  final Event event;

  const AcceptEventDialog({super.key, required this.event});

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
        _showTime(),
        const SizedBox(height: DEFAULT_PADDING),
        _showPay(),
        const SizedBox(height: DEFAULT_PADDING),
        const Divider(),
        Text(event.details),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CancelButton(onPressed: () => {Navigator.pop(context)}),
            AcceptButton(
                onPressed: () => {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const ConfirmationDialog();
                          })
                    })
          ],
        ),
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
        'Date: ', DateFormat("MMMM dd").format(event.dateTime));
  }

  Widget _showTime() {
    return _detailTextWidget(
        'Time: ', DateFormat("hh:mm").format(event.dateTime));
  }

  Widget _showPay() {
    return _detailTextWidget('Pay: ', event.getPriceInPounds());
  }
}

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(DEFAULT_PADDING),
      title: const Center(child: Text('Confirmation')),
      children: <Widget>[
        const Text('Are you sure that you want to accept this job?'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CancelButton(onPressed: () => {Navigator.pop(context)}),
            AcceptButton(onPressed: () => {})
          ],
        ),
      ],
    );
  }
}
