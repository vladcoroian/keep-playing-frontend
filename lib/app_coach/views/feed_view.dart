import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/constants.dart';
import 'package:keep_playing_frontend/widgets/buttons.dart';
import 'package:keep_playing_frontend/widgets/dialogs.dart';
import 'package:keep_playing_frontend/widgets/event_widgets.dart';
import 'package:keep_playing_frontend/widgets/events_views.dart';

import '../../../models/event.dart';
import '../cubits/coach_cubit.dart';
import '../cubits/feed_events_cubit.dart';

class FeedView extends StatelessWidget {
  const FeedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget viewOfEvents =
        BlocBuilder<FeedEventsCubit, List<Event>>(builder: (context, state) {
      return ListViewOfEvents(
          events: state,
          eventWidgetBuilder: (Event event) => _FeedEventWidget(
                event: event,
                coachPK: BlocProvider.of<CoachUserCubit>(context).state.pk,
              ));
    });

    return Scaffold(
        appBar: AppBar(
          title: const Text('Feed'),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            BlocProvider.of<FeedEventsCubit>(context).retrieveFeedEvents();
          },
          child: Center(child: viewOfEvents),
        ));
  }
}

class _FeedEventWidget extends StatelessWidget {
  final Event event;
  final int coachPK;

  const _FeedEventWidget({required this.event, required this.coachPK});

  @override
  Widget build(BuildContext context) {
    final Widget detailsButton = ColoredButton(
      text: 'Details',
      color: DETAILS_BUTTON_COLOR,
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return _DetailsDialog(event: event);
            });
      },
    );

    final Widget applyButton = ColoredButton(
      text: 'Apply',
      color: APP_COLOR,
      onPressed: () {
        final FeedEventsCubit feedEventsCubit =
            BlocProvider.of<FeedEventsCubit>(context);

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return BlocProvider<FeedEventsCubit>.value(
                value: feedEventsCubit,
                child: _AcceptJobDialog(event: event),
              );
            });
      },
    );

    final Widget appliedButton = ColoredButton(
      text: 'Applied',
      color: APPLIED_BUTTON_COLOR,
      onPressed: () {},
    );

    return EventCard(
      event: event,
      leftButton: detailsButton,
      rightButton: event.offers.contains(coachPK) ? appliedButton : applyButton,
    );
  }
}

class _DetailsDialog extends StatelessWidget {
  final Event event;

  const _DetailsDialog({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget cancelButton = ColoredButton(
      text: 'Cancel',
      color: CANCEL_BUTTON_COLOR,
      onPressed: () => {
        Navigator.pop(context),
      },
    );

    return EventDetailsDialog(
      event: event,
      widgetsAtTheEnd: [
        Align(
          alignment: Alignment.center,
          child: cancelButton,
        ),
      ],
    );
  }
}

class _AcceptJobDialog extends StatelessWidget {
  final Event event;

  const _AcceptJobDialog({required this.event});

  @override
  Widget build(BuildContext context) {
    final Widget sendOfferButton = ColoredButton(
      text: 'Send Offer',
      color: APP_COLOR,
      onPressed: () {
        final FeedEventsCubit feedEventsCubit =
            BlocProvider.of<FeedEventsCubit>(context);
        showDialog(
            context: context,
            builder: (BuildContext buildContext) {
              return BlocProvider<FeedEventsCubit>.value(
                value: feedEventsCubit,
                child: ConfirmationDialog(
                  title: 'Are you sure that you want to accept this job?',
                  onNoPressed: () => {
                    Navigator.pop(buildContext),
                  },
                  onYesPressed: () async {
                    final NavigatorState navigator = Navigator.of(buildContext);
                    final FeedEventsCubit feedEventsCubit =
                        BlocProvider.of<FeedEventsCubit>(context);
                    final Response response =
                        await API.events.applyToJob(event: event);
                    if (response.statusCode == HTTP_202_ACCEPTED) {
                      feedEventsCubit.retrieveFeedEvents();
                    } else {
                      // TODO
                    }
                    navigator.pop();
                    navigator.pop();
                  },
                ),
              );
            });
      },
    );

    final Widget cancelButton = ColoredButton(
      text: 'Cancel',
      color: CANCEL_BUTTON_COLOR,
      onPressed: () => {Navigator.pop(context)},
    );

    return EventDetailsDialog(event: event, widgetsAtTheEnd: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          sendOfferButton,
          cancelButton,
        ],
      ),
    ]);
  }
}
