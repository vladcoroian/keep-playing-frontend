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
import '../cubit/coach_cubit.dart';
import '../cubit/feed_events_cubit.dart';

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
                coachPK: context.read<CurrentCoachUserCubit>().state.pk,
              ));
    });

    return Scaffold(
        appBar: AppBar(
          title: const Text('Feed'),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<FeedEventsCubit>().retrieveFeedEvents();
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
    final Widget detailsButton = DetailsButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return _DetailsDialog(event: event);
            });
      },
    );

    final Widget applyButton = _ApplyButton(
      onPressed: () {
        final FeedEventsCubit feedEventsCubit = context.read<FeedEventsCubit>();

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

    final Widget appliedButton = _AppliedButton(
      onPressed: () {},
    );

    return EventCard(
      event: event,
      leftButton: detailsButton,
      rightButton: event.offers.contains(coachPK) ? appliedButton : applyButton,
    );
  }
}

class _ApplyButton extends ColoredButton {
  const _ApplyButton({Key? key, required super.onPressed})
      : super(
          key: key,
          text: 'Apply',
          color: APP_COLOR,
        );
}

class _AppliedButton extends ColoredButton {
  const _AppliedButton({Key? key, required super.onPressed})
      : super(
          key: key,
          text: 'Applied',
          color: APPLIED_BUTTON_COLOR,
        );
}

class _SendOfferButton extends ColoredButton {
  const _SendOfferButton({Key? key, required super.onPressed})
      : super(
          key: key,
          text: 'Send Offer',
          color: APP_COLOR,
        );
}

class _DetailsDialog extends StatelessWidget {
  final Event event;

  const _DetailsDialog({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EventDetailsDialog(
      event: event,
      widgetsAtTheEnd: [
        Align(
          alignment: Alignment.center,
          child: CancelButton(onPressed: () => {Navigator.pop(context)}),
        ),
      ],
    );
  }
}

class _AcceptJobDialog extends StatelessWidget {
  final Event event;

  const _AcceptJobDialog({required this.event});

  @override
  Widget build(BuildContext buildContext) {
    final Widget sendOffer = _SendOfferButton(onPressed: () {
      final FeedEventsCubit feedEventsCubit =
          buildContext.read<FeedEventsCubit>();
      showDialog(
          context: buildContext,
          builder: (BuildContext context) {
            return BlocProvider<FeedEventsCubit>.value(
              value: feedEventsCubit,
              child: ConfirmationDialog(
                title: 'Are you sure that you want to accept this job?',
                onNoPressed: () => {Navigator.pop(context)},
                onYesPressed: () async {
                  final NavigatorState navigator = Navigator.of(context);
                  final FeedEventsCubit feedEventsCubit =
                      buildContext.read<FeedEventsCubit>();
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
    });

    final Widget cancelButton =
        CancelButton(onPressed: () => {Navigator.pop(buildContext)});

    return EventDetailsDialog(event: event, widgetsAtTheEnd: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          sendOffer,
          cancelButton,
        ],
      ),
    ]);
  }
}
