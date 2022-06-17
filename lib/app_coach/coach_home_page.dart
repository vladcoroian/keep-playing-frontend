import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/constants.dart';
import 'package:keep_playing_frontend/models/user.dart';

import 'cubit/coach_cubit.dart';
import 'views/feed_page.dart';
import 'views/profile_page.dart';
import 'views/upcoming_jobs_page.dart';

class CoachHomePage extends StatefulWidget {
  const CoachHomePage({Key? key}) : super(key: key);

  @override
  State<CoachHomePage> createState() => _CoachHomePageState();
}

class _CoachHomePageState extends State<CoachHomePage> {
  User? currentUser;

  @override
  void initState() {
    _retrieveCurrentUserInformation();
    super.initState();
  }

  void _retrieveCurrentUserInformation() async {
    User user = await API.users.getCurrentUser();
    setState(() {
      currentUser = user;
    });
  }

  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    FeedPage(),
    UpcomingJobsPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentWidget = _widgetOptions.elementAt(_selectedIndex);

    // TODO: loadingScreen
    const Widget loadingScreen = Text('Loading');

    final Widget homePage = Scaffold(
      body: BlocProvider(
        create: (BuildContext context) =>
            CurrentCoachUserCubit(user: currentUser!),
        child: currentWidget,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          _FeedPageNavigationButton(),
          _UpcomingJobsNavigationButton(),
          _ProfileNavigationButton(),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: BOTTOM_NAVIGATION_BAR_COLOR,
        onTap: _onItemTapped,
      ),
    );

    if (currentUser == null) {
      return loadingScreen;
    }
    return homePage;
  }
}

class _FeedPageNavigationButton extends BottomNavigationBarItem {
  const _FeedPageNavigationButton()
      : super(icon: const Icon(Icons.feed), label: 'Feed');
}

class _UpcomingJobsNavigationButton extends BottomNavigationBarItem {
  const _UpcomingJobsNavigationButton()
      : super(icon: const Icon(Icons.business), label: 'Upcoming Jobs');
}

class _ProfileNavigationButton extends BottomNavigationBarItem {
  const _ProfileNavigationButton()
      : super(icon: const Icon(Icons.account_box), label: 'Profile');
}
