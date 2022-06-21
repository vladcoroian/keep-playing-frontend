import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_playing_frontend/app_organiser/cubit/all_events_cubit.dart';
import 'package:keep_playing_frontend/constants.dart';

import 'views/events_page.dart';
import 'views/profile_page.dart';

class OrganiserHomePage extends StatefulWidget {
  const OrganiserHomePage({Key? key}) : super(key: key);

  @override
  State<OrganiserHomePage> createState() => _OrganiserHomePageState();
}

class _OrganiserHomePageState extends State<OrganiserHomePage> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    BlocProvider(
      create: (BuildContext context) => AllEventsCubit(),
      child: const EventsPage(),
    ),
    const ProfilePage(),
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
      body: currentWidget,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          _EventsNavigationButton(),
          _ProfileNavigationButton(),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: BOTTOM_NAVIGATION_BAR_COLOR,
        onTap: _onItemTapped,
      ),
    );
  }
}

class _EventsNavigationButton extends BottomNavigationBarItem {
  const _EventsNavigationButton()
      : super(icon: const Icon(Icons.feed), label: 'Events');
}

class _ProfileNavigationButton extends BottomNavigationBarItem {
  const _ProfileNavigationButton()
      : super(icon: const Icon(Icons.account_box), label: 'Profile');
}
