import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:keep_playing_frontend/app_organiser/home_page/pending_events/pending_events_for_day_page.dart';
import 'package:keep_playing_frontend/events/event_widgets.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:keep_playing_frontend/urls.dart';
import 'package:table_calendar/table_calendar.dart';

class PendingEventsPage extends StatefulWidget {
  const PendingEventsPage({Key? key}) : super(key: key);

  @override
  State<PendingEventsPage> createState() => _PendingEventsPageState();
}

class _PendingEventsPageState extends State<PendingEventsPage> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = [];
  List<Widget> _buttonOptions = [];

  Client client = http.Client();
  List<Event> pendingEvents = [];

  _retrievePendingEvents() async {
    pendingEvents = [];
    List response = json.decode((await client.get(Uri.parse(URL.EVENTS))).body);
    for (var element in response) {
      Event event = Event.fromJson(element);
      if (!event.coach) {
        pendingEvents.add(Event.fromJson(element));
      }
    }
  }

  @override
  void initState() {
    _buttonOptions = [
      CalendarViewButton(
          onTap: () => {
                setState(() {
                  _selectedIndex = 1;
                })
              }),
      ListViewButton(
          onTap: () => {
                setState(() {
                  _selectedIndex = 0;
                })
              }),
    ];
    _retrievePendingEvents();
    _widgetOptions = <Widget>[
      _ListViewWidget(pendingEvents: pendingEvents),
      _CalendarViewWidget(pendingEvents: pendingEvents)
    ];
    super.initState();
  }

  @override


  @override
  Widget build(BuildContext context) {
    Widget currentWidget = _widgetOptions.elementAt(_selectedIndex);

    return RefreshIndicator(
        onRefresh: () async {
          _retrievePendingEvents();
        },
        child: Scaffold(
            appBar: AppBar(
                title: const Text('Pending Events'),
                actions: [_buttonOptions[_selectedIndex]]),
            body: Center(
              child: currentWidget,
            ),
            floatingActionButton: NewJobButton(context: context)));
  }
}

class _ListViewWidget extends StatefulWidget {
  final List<Event> pendingEvents;

  const _ListViewWidget({required this.pendingEvents});

  @override
  State<_ListViewWidget> createState() => _ListViewWidgetState();
}

class _ListViewWidgetState extends State<_ListViewWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.pendingEvents.length,
      itemBuilder: (BuildContext context, int index) {
        return PendingEventWidget(event: widget.pendingEvents[index]);
      },
    );
  }
}

class _CalendarViewWidget extends StatefulWidget {
  final List<Event> pendingEvents;

  const _CalendarViewWidget({required this.pendingEvents});

  @override
  State<_CalendarViewWidget> createState() => _CalendarViewWidgetState();
}

class _CalendarViewWidgetState extends State<_CalendarViewWidget> {
  CalendarFormat _calendarFormat = CalendarFormat.month;

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      TableCalendar(
        startingDayOfWeek: StartingDayOfWeek.monday,
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            setState(() {
              _focusedDay = focusedDay;
              _selectedDay = selectedDay;
            });
          }
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PendingEventsForDayPage(day: selectedDay)));
        },
        calendarFormat: _calendarFormat,
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        eventLoader: (day) {
          return _getEventsForDay(day);
        },
      ),
    ]);
  }

  List<Widget> _getEventsForDay(DateTime day) {
    List<Event> eventsForDay = [];
    for (Event pendingEvent in widget.pendingEvents) {
      if (isSameDay(day, pendingEvent.getDate())) {
        eventsForDay.add(pendingEvent);
      }
    }
    return eventsForDay
        .map((event) => PendingEventWidget(event: event))
        .toList();
  }
}
