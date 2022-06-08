import 'package:flutter/material.dart';

import 'home_page/account_page.dart';
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
    AccountPage(),
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
        items: <BottomNavigationBarItem>[
          _pendingEventsNavigationButton(),
          _accountNavigationButton(),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightBlueAccent,
        onTap: _onItemTapped,
      ),
    );
  }

  BottomNavigationBarItem _pendingEventsNavigationButton() {
    return const BottomNavigationBarItem(
        icon: Icon(Icons.business), label: 'Pending Events');
  }

  BottomNavigationBarItem _accountNavigationButton() {
    return const BottomNavigationBarItem(
        icon: Icon(Icons.account_circle), label: 'Account');
  }
}
