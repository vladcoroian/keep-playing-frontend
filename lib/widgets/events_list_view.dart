import 'package:flutter/material.dart';
import 'package:keep_playing_frontend/models/event.dart';

class ListViewOfEvents extends StatefulWidget {
  final List<Event> events;
  final Widget Function(Event event) eventWidgetBuilder;

  const ListViewOfEvents(
      {Key? key, required this.events, required this.eventWidgetBuilder})
      : super(key: key);

  @override
  State<ListViewOfEvents> createState() => _ListViewOfEventsState();
}

class _ListViewOfEventsState extends State<ListViewOfEvents> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.events.length,
      itemBuilder: (BuildContext context, int index) {
        return widget.eventWidgetBuilder(widget.events[index]);
      },
    );
  }
}
