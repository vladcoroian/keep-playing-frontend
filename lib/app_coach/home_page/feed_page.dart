import 'package:flutter/material.dart';
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
                  eventWidgetBuilder: (Event event) => FeedEventWidget(
                        event: event,
                      ))),
        ));
  }
}
