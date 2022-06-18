import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:keep_playing_frontend/models/user.dart';

class UpcomingJobsCubit extends Cubit<List<Event>> {
  UpcomingJobsCubit() : super([]);

  void retrieveUpcomingJobs({required User withCoachUser}) async {
    List<Event> retrievedEvents = await API.events.retrieveEvents(
      allowPastEvents: false,
      allowPendingEvents: false,
      withCoachUser: withCoachUser,
    );
    emit(retrievedEvents);
  }
}