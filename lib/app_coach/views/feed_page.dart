import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/feed_events_cubit.dart';
import 'feed_view.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FeedEventsCubit feedEventsCubit = FeedEventsCubit();

    return MultiBlocProvider(providers: [
      BlocProvider(create: (BuildContext context) {
        feedEventsCubit.retrieveFeedEvents();
        return feedEventsCubit;
      })
    ], child: const FeedView());
  }
}
