import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/models/event.dart';

class FeedEventsCubit extends Cubit<List<Event>> {
  FeedEventsCubit() : super([]);

  void retrieveFeedEvents() async {
    List<Event> retrievedEvents = await API.coach.retrieveFeedEvents();
    retrievedEvents.retainWhere(
      (event) => event.check(
          allowPastEvents: false,
          allowPendingEvents: true,
          allowScheduledEvents: false),
    );
    emit(retrievedEvents);
  }
}
