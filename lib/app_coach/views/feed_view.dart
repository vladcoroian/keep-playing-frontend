import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/constants.dart';
import 'package:keep_playing_frontend/models_widgets/event_widgets.dart';
import 'package:keep_playing_frontend/stored_data.dart';
import 'package:keep_playing_frontend/widgets/buttons.dart';
import 'package:keep_playing_frontend/widgets/dialogs.dart';

import '../../../models/event.dart';
import '../cubits/feed_events_cubit.dart';

class FeedView extends StatefulWidget {
  const FeedView({Key? key}) : super(key: key);

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
      const Duration(seconds: TIMER_DURATION_IN_SECONDS),
      (Timer t) =>
          BlocProvider.of<FeedEventsCubit>(context).retrieveFeedEvents(),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget viewOfEvents = BlocBuilder<FeedEventsCubit, List<Event>>(
      builder: (_, state) {
        return ListView.builder(
          itemCount: state.length,
          itemBuilder: (_, index) {
            return _FeedEventWidget(
              event: state[index],
              coachPK: StoredData.getCurrentUser().pk,
            );
          },
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          BlocProvider.of<FeedEventsCubit>(context).retrieveFeedEvents();
        },
        child: Center(child: viewOfEvents),
      ),
    );
  }
}

class _FeedEventWidget extends StatelessWidget {
  final Event event;
  final int coachPK;

  const _FeedEventWidget({required this.event, required this.coachPK});

  @override
  Widget build(BuildContext context) {
    final Widget detailsButton = Container(
      padding: const EdgeInsets.fromLTRB(BUTTON_PADDING, 0, 0, BUTTON_PADDING),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: DETAILS_BUTTON_COLOR,
            textStyle: const TextStyle(fontSize: BUTTON_FONT_SIZE)),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext _) {
                return _DetailsDialog(event: event);
              });
        },
        child: const Text('Details'),
      ),
    );

    return EventCard(
      event: event,
      leftButton: detailsButton,
      rightButton: event.offers.contains(coachPK)
          ? _AppliedButton()
          : _AcceptButton(event: event),
    );
  }
}

// **************************************************************************
// **************** BUTTONS
// **************************************************************************

class _AcceptButton extends StatelessWidget {
  final Event event;

  const _AcceptButton({required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, BUTTON_PADDING, BUTTON_PADDING),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: APP_COLOR,
            textStyle: const TextStyle(fontSize: BUTTON_FONT_SIZE)),
        onPressed: () {
          final FeedEventsCubit feedEventsCubit =
              BlocProvider.of<FeedEventsCubit>(context);

          showDialog(
            context: context,
            builder: (BuildContext _) {
              return BlocProvider<FeedEventsCubit>.value(
                value: feedEventsCubit,
                child: _AcceptJobDialog(event: event),
              );
            },
          );
        },
        child: const Text('Apply'),
      ),
    );
  }
}

class _AppliedButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, BUTTON_PADDING, BUTTON_PADDING),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: APPLIED_BUTTON_COLOR,
            textStyle: const TextStyle(fontSize: BUTTON_FONT_SIZE)),
        onPressed: () {},
        child: const Text('Applied'),
      ),
    );
  }
}

// **************************************************************************
// **************** DIALOGS
// **************************************************************************

class _DetailsDialog extends StatelessWidget {
  final Event event;

  const _DetailsDialog({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget backButton = Container(
      padding: const EdgeInsets.all(BUTTON_PADDING),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: BACK_BUTTON_COLOR,
            textStyle: const TextStyle(fontSize: BUTTON_FONT_SIZE)),
        onPressed: () => {
          Navigator.of(context).pop(),
        },
        child: const Text('Back'),
      ),
    );

    return EventDetailsDialog(
      event: event,
      widgetsAtTheEnd: [
        Align(
          alignment: Alignment.center,
          child: backButton,
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
    final Widget sendOfferButton = Container(
      padding: const EdgeInsets.all(BUTTON_PADDING),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: APP_COLOR,
            textStyle: const TextStyle(fontSize: BUTTON_FONT_SIZE)),
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
                    Navigator.of(buildContext).pop(),
                  },
                  onYesPressed: () async {
                    final NavigatorState navigator = Navigator.of(buildContext);
                    final FeedEventsCubit feedEventsCubit =
                        BlocProvider.of<FeedEventsCubit>(context);

                    final Response response =
                        await API.coach.applyToJob(event: event);
                    if (response.statusCode == HTTP_202_ACCEPTED) {
                      feedEventsCubit.retrieveFeedEvents();
                      navigator.pop();
                      navigator.pop();
                    } else {
                      showDialog(
                        context: context,
                        builder: (_) => const RequestFailedDialog(),
                        barrierDismissible: false,
                      );
                    }
                  },
                ),
              );
            },
          );
        },
        child: const Text('Send Offer'),
      ),
    );

    final Widget cancelButton = Container(
      padding: const EdgeInsets.all(BUTTON_PADDING),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: CANCEL_BUTTON_COLOR,
            textStyle: const TextStyle(fontSize: BUTTON_FONT_SIZE)),
        onPressed: () => {
          Navigator.of(context).pop(),
        },
        child: const Text('Cancel'),
      ),
    );

    return EventDetailsDialog(
      event: event,
      widgetsAtTheEnd: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            sendOfferButton,
            cancelButton,
          ],
        ),
      ],
    );
  }
}
