import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_playing_frontend/app_coach/cubit/coach_cubit.dart';
import 'package:keep_playing_frontend/app_coach/cubit/upcoming_jobs_cubit.dart';

import 'upcoming_jobs_view.dart';

class UpcomingJobsPage extends StatelessWidget {
  const UpcomingJobsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        UpcomingJobsCubit upcomingJobsCubit = UpcomingJobsCubit();
        upcomingJobsCubit.retrieveUpcomingJobs(
          withCoachUser: context.read<CurrentCoachUserCubit>().state,
        );
        return upcomingJobsCubit;
      },
      child: const UpcomingJobsView(),
    );
  }
}