import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class PendingEventsCalendarPage extends StatefulWidget {
  const PendingEventsCalendarPage({Key? key}) : super(key: key);

  @override
  State<PendingEventsCalendarPage> createState() =>
      _PendingEventsCalendarPageState();
}

class _PendingEventsCalendarPageState extends State<PendingEventsCalendarPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Pending Events')),
        body: TableCalendar(
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            if (!isSameDay(_selectedDay, selectedDay)) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            }
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
        ));
  }

  List<Widget> _getEventsForDay(DateTime day) {
    return [Text('Widget1'), Text('Widget2')];
  }
}
