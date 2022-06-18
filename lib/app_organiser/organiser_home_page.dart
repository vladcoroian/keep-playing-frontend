import 'package:flutter/material.dart';

import 'views/events_page.dart';

class OrganiserHomePage extends StatefulWidget {
  const OrganiserHomePage({Key? key}) : super(key: key);

  @override
  State<OrganiserHomePage> createState() => _OrganiserHomePageState();
}

class _OrganiserHomePageState extends State<OrganiserHomePage> {
  @override
  Widget build(BuildContext context) {
    return const EventsPage();
  }
}
