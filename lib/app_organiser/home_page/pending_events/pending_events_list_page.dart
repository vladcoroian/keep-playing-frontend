import 'package:flutter/material.dart';
import 'package:keep_playing_frontend/app_organiser/home_page/pending_events/pending_events_for_day_page.dart';
import 'package:keep_playing_frontend/events/event_widgets.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:table_calendar/table_calendar.dart';

class PendingEventsListPage extends StatefulWidget {
  final List<Event> pendingEvents;

  const PendingEventsListPage({Key? key, required this.pendingEvents})
      : super(key: key);

  @override
  State<PendingEventsListPage> createState() => _PendingEventsListPageState();
}

class _PendingEventsListPageState extends State<PendingEventsListPage> {
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
