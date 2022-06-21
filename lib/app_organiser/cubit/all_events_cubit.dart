import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/models/event.dart';

class AllEventsCubit extends Cubit<List<Event>> {
  AllEventsCubit() : super([]);

  Future<void> retrieveEvents() async {
    List<Event> retrievedEvents = await API.organiser.retrieveEvents();
    emit(retrievedEvents);
  }
}
