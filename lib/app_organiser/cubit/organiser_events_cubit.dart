import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_playing_frontend/app_organiser/cubit/all_events_cubit.dart';
import 'package:keep_playing_frontend/models/event.dart';

class OrganiserEventsCubit extends Cubit<List<Event>> {
  final AllEventsCubit allEventsCubit;

  bool allowPastEvents = true;
  bool allowFutureEvents = true;
  bool allowPendingEvents = true;
  bool allowScheduledEvents = true;

  OrganiserEventsCubit({required this.allEventsCubit}) : super([]);

  void updateEventsUsingPreferences() {
    List<Event> events = [...allEventsCubit.state];
    events.retainWhere(
      (event) => event.check(
        allowPastEvents: allowPastEvents,
        allowFutureEvents: allowFutureEvents,
        allowPendingEvents: allowPendingEvents,
        allowScheduledEvents: allowScheduledEvents,
      ),
    );
    emit(events);
  }

  void retrieveEvents() async {
    await allEventsCubit.retrieveEvents();
    updateEventsUsingPreferences();
  }
}
