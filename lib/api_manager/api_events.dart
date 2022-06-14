import 'dart:convert';

import 'package:http/http.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:table_calendar/table_calendar.dart';

class _ApiLinks {
  static const String PREFIX = "https://keep-playing.herokuapp.com/";
  static const String EVENTS = "${PREFIX}events/";

  static Uri getEventsLink() {
    return Uri.parse(EVENTS);
  }

  static Uri addEventLink() {
    return Uri.parse(EVENTS);
  }

  static Uri updateEventLink(int pk) {
    return Uri.parse("$EVENTS$pk/");
  }

  static Uri deleteEventLink(int pk) {
    return Uri.parse("$EVENTS$pk/");
  }
}

class ApiEvents {
  final Client client;

  ApiEvents({required this.client});

  void updateEvent({required Event event, Object? body}) {
    client.patch(_ApiLinks.updateEventLink(event.pk), body: body);
  }

  void eventHasCoach({required Event event}) {
    updateEvent(event: event, body: {"coach": "true"});
  }

  void eventHasNoCoach({required Event event}) {
    updateEvent(event: event, body: {"coach": "false"});
  }

  Future<Response> addNewEvent({required NewEvent newEvent}) {
    return client.post(_ApiLinks.addEventLink(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: newEvent.toJson());
  }

  Future<Response> changeEvent(
      {required Event event, required NewEvent newEvent}) {
    return client.patch(_ApiLinks.updateEventLink(event.pk),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: newEvent.toJson());
  }

  void cancelEvent({required Event event}) {
    client.delete(_ApiLinks.deleteEventLink(event.pk));
  }

  Future<List<Event>> retrieveEvents() async {
    List<Event> events = [];
    List response =
        json.decode((await client.get(_ApiLinks.getEventsLink())).body);
    for (var element in response) {
      events.add(Event(eventModel: EventModel.fromJson(element)));
    }
    return events;
  }

  Future<List<Event>> retrievePendingEvents() async {
    List<Event> events = await retrieveEvents();
    events.retainWhere((event) => !event.coach);
    return events;
  }

  Future<List<Event>> retrievePendingEventsForThisDay(DateTime day) async {
    List<Event> events = await retrieveEvents();
    events.retainWhere((event) => !event.coach && isSameDay(event.date, day));
    return events;
  }

  Future<List<Event>> retrieveScheduledEvents() async {
    List<Event> events = await retrieveEvents();
    events.retainWhere((event) => event.coach);
    return events;
  }

  retrieveScheduledEventsForDay(DateTime day) async {
    List<Event> events = await retrieveEvents();
    events.retainWhere((event) => event.coach && isSameDay(event.date, day));
    return events;
  }
}
