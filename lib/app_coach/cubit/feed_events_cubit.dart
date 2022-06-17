import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/models/event.dart';

class FeedEventsCubit extends Cubit<List<Event>> {
  FeedEventsCubit() : super([]);

  void addNewEvent(Event newEvent) {
    state.add(newEvent);
    emit(List.of(state));
  }

  void removeEvent(Event event) {
    state.remove(event);
    emit(List.of(state));
  }

  void retrieveFeedEvents() async {
    List<Event> retrievedEvents =
        await API.events.retrieveEvents(past: false, pending: true);
    emit(List.of(retrievedEvents));
  }
}
