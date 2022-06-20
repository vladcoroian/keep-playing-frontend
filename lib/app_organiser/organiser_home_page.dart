import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_playing_frontend/app_organiser/cubit/all_events_cubit.dart';

import 'views/events_page.dart';

class OrganiserHomePage extends StatelessWidget {
  const OrganiserHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AllEventsCubit(),
      child: const EventsPage(),
    );
  }
}
