import 'package:flutter/material.dart';
import 'package:keep_playing_frontend/constants.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:table_calendar/table_calendar.dart';

const double CALENDAR_PADDING = DEFAULT_PADDING;

class CalendarViewButton extends StatelessWidget {
  final Function()? onTap;

  const CalendarViewButton({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(right: APP_BAR_BUTTON_PADDING),
        child: GestureDetector(
          onTap: onTap,
          child: const Icon(
            Icons.calendar_month,
            size: APP_BAR_BUTTON_SIZE,
          ),
        ));
  }
}

class ListViewButton extends StatelessWidget {
  final Function()? onTap;

  const ListViewButton({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(right: APP_BAR_BUTTON_PADDING),
        child: GestureDetector(
          onTap: onTap,
          child: const Icon(
            Icons.list,
            size: APP_BAR_BUTTON_SIZE,
          ),
        ));
  }
}

class ListViewsOfEvents {
  final List<Event> events;
  final Widget Function(Event event) eventWidgetBuilder;

  ListViewsOfEvents({required this.events, required this.eventWidgetBuilder});

  List<Widget> _list() {
    List<Widget> listOfEventsWidgets = [];
    for (Event event in events) {
      listOfEventsWidgets.add(eventWidgetBuilder(event));
    }
    return listOfEventsWidgets;
  }

  Widget listView() {
    return ListView(children: _list());
  }

  Widget sliverListView() {
    return SliverList(delegate: SliverChildListDelegate(_list()));
  }
}

class CalendarViewOfEvents extends StatefulWidget {
  final List<Event> events;
  final void Function(DateTime day) onDaySelected;

  const CalendarViewOfEvents(
      {Key? key, required this.events, required this.onDaySelected})
      : super(key: key);

  @override
  State<CalendarViewOfEvents> createState() => _CalendarViewOfEventsState();
}

class _CalendarViewOfEventsState extends State<CalendarViewOfEvents> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(CALENDAR_PADDING),
        child: TableCalendar(
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
          calendarFormat: CalendarFormat.month,
          availableCalendarFormats: const {CalendarFormat.month: 'Month'},
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
          eventLoader: (day) {
            return _getEventsForDay(day);
          },
        ));
  }

  List<Widget> _getEventsForDay(DateTime day) {
    List<Event> eventsForDay = [];
    for (Event pendingEvent in widget.events) {
      if (isSameDay(day, pendingEvent.date)) {
        eventsForDay.add(pendingEvent);
      }
    }
    return eventsForDay
        .map((event) => const SizedBox(width: 0, height: 0))
        .toList();
  }
}
