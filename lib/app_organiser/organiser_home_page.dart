import 'package:flutter/material.dart';
import 'package:keep_playing_frontend/app_organiser/home_page/scheduled_events_page.dart';
import 'package:keep_playing_frontend/constants.dart';

import 'home_page/pending_events_page.dart';

class OrganiserHomePage extends StatefulWidget {
  const OrganiserHomePage({Key? key}) : super(key: key);

  @override
  State<OrganiserHomePage> createState() => _OrganiserHomePageState();
}

class _OrganiserHomePageState extends State<OrganiserHomePage> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    PendingEventsPage(),
    ScheduledEventsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentWidget = _widgetOptions.elementAt(_selectedIndex);

    return Scaffold(
      body: Center(
        child: currentWidget,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          _PendingEventsNavigationButton(),
          _ScheduledEventsNavigationButton(),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: BOTTOM_NAVIGATION_BAR_COLOR,
        onTap: _onItemTapped,
      ),
    );
  }
}

class _PendingEventsNavigationButton extends BottomNavigationBarItem {
  const _PendingEventsNavigationButton()
      : super(icon: const Icon(Icons.event_busy), label: 'Pending Events');
}

class _ScheduledEventsNavigationButton extends BottomNavigationBarItem {
  const _ScheduledEventsNavigationButton()
      : super(
            icon: const Icon(Icons.event_available), label: 'Scheduled Events');
}
