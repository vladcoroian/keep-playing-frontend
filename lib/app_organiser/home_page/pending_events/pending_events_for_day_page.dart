import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keep_playing_frontend/widgets/event_widgets.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:keep_playing_frontend/api-manager.dart';

class PendingEventsForDayPage extends StatefulWidget {
  final DateTime day;

  const PendingEventsForDayPage({Key? key, required this.day})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _PendingEventsForDayState();
}

class _PendingEventsForDayState extends State<PendingEventsForDayPage> {
  List<Event> pendingEventsForThisDay = [];

  @override
  void initState() {
    _retrievePendingEventsForThisDay();
    super.initState();
  }

  _retrievePendingEventsForThisDay() async {
    List<Event> retrievedEvents =
        await API.retrievePendingEventsForThisDay(widget.day);

    setState(() {
      pendingEventsForThisDay = retrievedEvents;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Pending Events for ${DateFormat('dd MMMM').format(widget.day)}'),
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            _retrievePendingEventsForThisDay();
          },
          child: ListView.builder(
            itemCount: pendingEventsForThisDay.length,
            itemBuilder: (BuildContext context, int index) {
              return PendingEventWidget(event: pendingEventsForThisDay[index]);
            },
          )),
    );
  }
}
