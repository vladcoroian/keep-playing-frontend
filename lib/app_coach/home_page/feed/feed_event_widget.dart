import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keep_playing_frontend/widgets/event_widget.dart';

import '../../../constants.dart';
import '../../../models/event.dart';

class FeedEventWidget extends StatelessWidget {
  final Event event;

  const FeedEventWidget({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return EventWidget(
        event: event,
        leftButton: _detailsButton(context),
        rightButton: _takeJobButton());
  }

  Widget _detailsButton(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(DEFAULT_PADDING),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                textStyle:
                    const TextStyle(fontSize: DEFAULT_FONT_SIZE_BUTTONS)),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DetailsEventDialog(event: event);
                  });
            },
            child: const Text('Details')));
  }

  Widget _takeJobButton() {
    return Container(
        padding: const EdgeInsets.all(DEFAULT_PADDING),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                textStyle:
                    const TextStyle(fontSize: DEFAULT_FONT_SIZE_BUTTONS)),
            onPressed: () {},
            child: const Text('Take Job')));
  }
}

class DetailsEventDialog extends StatelessWidget {
  final Event event;

  const DetailsEventDialog({super.key, required this.event});

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
