import 'package:flutter/material.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarViewOfEvents extends StatefulWidget {
  final List<Event> events;
  final void Function(DateTime day) onDaySelected;

  const CalendarViewOfEvents({Key? key, required this.events, required this.onDaySelected}) : super(key: key);

  @override
  State<CalendarViewOfEvents> createState() => _CalendarViewOfEventsState();
}

class _CalendarViewOfEventsState extends State<CalendarViewOfEvents> {
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
          widget.onDaySelected(selectedDay);
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
    for (Event pendingEvent in widget.events) {
      if (isSameDay(day, pendingEvent.getDate())) {
        eventsForDay.add(pendingEvent);
      }
    }
    return eventsForDay
        .map((event) => const SizedBox(width: 0, height: 0))
        .toList();
  }
}
