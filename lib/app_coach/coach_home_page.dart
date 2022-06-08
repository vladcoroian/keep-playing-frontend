import 'package:flutter/material.dart';

import 'home_page/account_page.dart';
import 'home_page/feed_page.dart';
import 'home_page/upcoming_jobs_page.dart';

class CoachHomePage extends StatefulWidget {
  const CoachHomePage({Key? key}) : super(key: key);

  @override
  State<CoachHomePage> createState() => _CoachHomePageState();
}

class _CoachHomePageState extends State<CoachHomePage> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    FeedPage(),
    UpcomingJobsPage(),
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
          _feedPageNavigationButton(),
          _upcomingJobsNavigationButton(),
          _accountNavigationButton(),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightBlueAccent,
        onTap: _onItemTapped,
      ),
    );
  }

  BottomNavigationBarItem _feedPageNavigationButton() {
    return const BottomNavigationBarItem(icon: Icon(Icons.feed), label: 'Feed');
  }

  BottomNavigationBarItem _upcomingJobsNavigationButton() {
    return const BottomNavigationBarItem(
        icon: Icon(Icons.business), label: 'Upcoming Jobs');
  }

  BottomNavigationBarItem _accountNavigationButton() {
    return const BottomNavigationBarItem(
        icon: Icon(Icons.account_circle), label: 'Account');
  }
}
