import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/feed_events_cubit.dart';
import 'profile_view.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        FeedEventsCubit feedEventsCubit = FeedEventsCubit();
        feedEventsCubit.retrieveFeedEvents();
        return feedEventsCubit;
      },
      child: const ProfileView(),
    );
  }
}
