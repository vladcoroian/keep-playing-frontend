import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/app_coach/cubits/upcoming_jobs_cubit.dart';
import 'package:keep_playing_frontend/constants.dart';
import 'package:keep_playing_frontend/models/user.dart';
import 'package:keep_playing_frontend/stored_data.dart';
import 'package:keep_playing_frontend/widgets/dialogs.dart';

import '../../models/event.dart';
import '../../widgets/event_widgets.dart';

class UpcomingJobsView extends StatelessWidget {
  const UpcomingJobsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget viewOfEvents = BlocBuilder<UpcomingJobsCubit, List<Event>>(
      builder: (context, state) {
        return ListView.builder(
          itemCount: state.length,
          itemBuilder: (context, index) {
            return _UpcomingJobWidget(event: state[index]);
          },
        );
      },
    );

    return Scaffold(
        appBar: AppBar(
          title: const Text('Upcoming Jobs'),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            BlocProvider.of<UpcomingJobsCubit>(context).retrieveUpcomingJobs(
              withCoachUser: StoredData.getCurrentUser(),
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
  Widget build(BuildContext context) {
    final Widget cancelButton = Container(
      padding: const EdgeInsets.fromLTRB(BUTTON_PADDING, 0, 0, BUTTON_PADDING),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: CANCEL_BUTTON_COLOR,
            textStyle: const TextStyle(fontSize: BUTTON_FONT_SIZE)),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext buildContext) {
              return ConfirmationDialog(
                title: 'Are you sure that you want to cancel this job?',
                onNoPressed: () {
                  Navigator.of(buildContext).pop();
                },
                onYesPressed: () async {
                  final NavigatorState navigator = Navigator.of(buildContext);
                  final UpcomingJobsCubit upcomingJobsCubit =
                      BlocProvider.of<UpcomingJobsCubit>(context);
                  final User coachUser = StoredData.getCurrentUser();
                  final Response response =
                      await API.coach.cancelJob(event: event);
                  if (response.statusCode == HTTP_202_ACCEPTED) {
                    upcomingJobsCubit.retrieveUpcomingJobs(
                        withCoachUser: coachUser);
                  } else {
                    // TODO
                  }
                  navigator.pop();
                },
              );
            },
          );
        },
        child: const Text('Cancel'),
      ),
    );

    final Widget detailsButton = Container(
      padding: const EdgeInsets.fromLTRB(0, 0, BUTTON_PADDING, BUTTON_PADDING),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: DETAILS_BUTTON_COLOR,
            textStyle: const TextStyle(fontSize: BUTTON_FONT_SIZE)),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext buildContext) {
              final Widget backButton = Container(
                padding: const EdgeInsets.all(BUTTON_PADDING),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: BACK_BUTTON_COLOR,
                      textStyle: const TextStyle(fontSize: BUTTON_FONT_SIZE)),
                  onPressed: () async {
                    Navigator.of(buildContext).pop();
                  },
                  child: const Text('Back'),
                ),
              );

              return EventDetailsDialog(
                event: event,
                widgetsAtTheEnd: [backButton],
              );
            },
          );
        },
        child: const Text('Details'),
      ),
    );

    return EventCard(
      event: event,
      leftButton: cancelButton,
      rightButton: detailsButton,
    );
  }
}
