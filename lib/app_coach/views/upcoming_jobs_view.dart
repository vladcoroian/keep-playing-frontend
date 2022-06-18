import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/app_coach/cubit/coach_cubit.dart';
import 'package:keep_playing_frontend/app_coach/cubit/upcoming_jobs_cubit.dart';
import 'package:keep_playing_frontend/constants.dart';
import 'package:keep_playing_frontend/models/user.dart';
import 'package:keep_playing_frontend/widgets/buttons.dart';
import 'package:keep_playing_frontend/widgets/dialogs.dart';
import 'package:keep_playing_frontend/widgets/events_views.dart';

import '../../models/event.dart';
import '../../widgets/event_widgets.dart';

class UpcomingJobsView extends StatelessWidget {
  const UpcomingJobsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget viewOfEvents = BlocBuilder<UpcomingJobsCubit, List<Event>>(
      builder: (context, state) {
        return ListViewOfEvents(
          events: context.read<UpcomingJobsCubit>().state,
          eventWidgetBuilder: (Event event) => _UpcomingJobWidget(event: event),
        );
      },
    );

    return Scaffold(
        appBar: AppBar(
          title: const Text('Upcoming Jobs'),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<UpcomingJobsCubit>().retrieveUpcomingJobs(
                  withCoachUser: context.read<CurrentCoachUserCubit>().state,
                );
          },
          child: Center(child: viewOfEvents),
        ));
  }
}

class _UpcomingJobWidget extends StatelessWidget {
  final Event event;

  const _UpcomingJobWidget({required this.event});

  @override
  Widget build(BuildContext buildContext) {
    final Widget cancelButton = ColoredButton(
      text: 'Cancel',
      color: CANCEL_BUTTON_COLOR,
      onPressed: () {
        showDialog(
            context: buildContext,
            builder: (BuildContext context) {
              return ConfirmationDialog(
                title: 'Are you sure that you want to cancel this job?',
                onNoPressed: () => {Navigator.pop(context)},
                onYesPressed: () async {
                  final NavigatorState navigator = Navigator.of(context);
                  final UpcomingJobsCubit upcomingJobsCubit =
                      buildContext.read<UpcomingJobsCubit>();
                  final User coachUser =
                      buildContext.read<CurrentCoachUserCubit>().state;
                  final Response response =
                      await API.events.cancelJob(event: event);
                  if (response.statusCode == HTTP_202_ACCEPTED) {
                    upcomingJobsCubit.retrieveUpcomingJobs(
                        withCoachUser: coachUser);
                  } else {
                    // TODO
                  }
                  navigator.pop();
                },
              );
            });
      },
    );

    final Widget detailsButton = ColoredButton(
      text: 'Details',
      color: DETAILS_BUTTON_COLOR,
      onPressed: () {
        showDialog(
            context: buildContext,
            builder: (BuildContext context) {
              return EventDetailsDialog(
                event: event,
                widgetsAtTheEnd: [
                  CancelButton(onPressed: () async {
                    Navigator.pop(context);
                  })
                ],
              );
            });
      },
    );

    return EventCard(
      event: event,
      leftButton: cancelButton,
      rightButton: detailsButton,
    );
  }
}
