import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/feed_events_cubit.dart';
import 'feed_view.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        FeedEventsCubit feedEventsCubit = FeedEventsCubit();
        feedEventsCubit.retrieveFeedEvents();
        return feedEventsCubit;
      },
      child: const FeedView(),
    );
  }
}