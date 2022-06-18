import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:keep_playing_frontend/models/user.dart';

class OrganiserEventsCubit extends Cubit<List<Event>> {
  bool allowPastEvents = true;
  bool allowFutureEvents = true;
  bool allowPendingEvents = true;
  bool allowScheduledEvents = true;
  DateTime? onDay;
  User? withCoachUser;

  OrganiserEventsCubit() : super([]);

  void retrieveEvents() async {
    List<Event> retrievedEvents = await API.events.retrieveEvents(
      allowPastEvents: allowPastEvents,
      allowFutureEvents: allowFutureEvents,
      allowPendingEvents: allowPendingEvents,
      allowScheduledEvents: allowScheduledEvents,
    );
    emit(retrievedEvents);
  }
}
