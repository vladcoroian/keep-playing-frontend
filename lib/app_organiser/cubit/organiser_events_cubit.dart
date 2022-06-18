import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/models/event.dart';

class OrganiserEventsCubit extends Cubit<List<Event>> {
  bool past = true;
  bool future = true;
  bool pending = true;
  bool scheduled = true;
  DateTime? onDay;

  OrganiserEventsCubit() : super([]);

  void retrieveEvents() async {
    List<Event> retrievedEvents =
    await API.events.retrieveEvents(past: false, pending: true);
    emit(retrievedEvents);
  }
}
