import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:table_calendar/table_calendar.dart';

import 'models/event.dart';

class API {
  static const String PREFIX = "https://keep-playing.herokuapp.com/";
  static const String EVENTS = "${PREFIX}events/";

  static Client client = http.Client();

  static Uri addEventLink() {
    return Uri.parse(EVENTS);
  }

  static Uri updateEventLink(int pk) {
    return Uri.parse("$EVENTS$pk/");
  }

  static Uri deleteEventLink(int pk) {
    return Uri.parse("$EVENTS$pk/");
  }

  static void updateEvent({required Event event, Object? body}) {
    client.patch(API.updateEventLink(event.pk), body: body);
  }

  static void eventHasCoach({required Event event}) {
    updateEvent(event: event, body: {"coach": "true"});
  }

  static void eventHasNoCoach({required Event event}) {
    updateEvent(event: event, body: {"coach": "false"});
  }

  static Future<Response> addNewEvent({required NewEvent newEvent}) {
    return client.post(API.addEventLink(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: newEvent.toJson());
  }

  static Future<Response> changeEvent(
      {required Event event, required NewEvent newEvent}) {
    return client.patch(API.updateEventLink(event.pk),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: newEvent.toJson());
  }

  static void cancelEvent({required Event event}) {
    client.delete(API.deleteEventLink(event.pk));
  }

  static Future<List<Event>> retrieveEvents() async {
    List<Event> events = [];
    List response = json.decode((await client.get(Uri.parse(API.EVENTS))).body);
    for (var element in response) {
      events.add(Event(eventModel: EventModel.fromJson(element)));
    }
    return events;
  }

  static Future<List<Event>> retrievePendingEvents() async {
    List<Event> events = await retrieveEvents();
    events.retainWhere((event) => !event.coach);
    return events;
  }

  static Future<List<Event>> retrievePendingEventsForThisDay(
      DateTime day) async {
    List<Event> events = await retrieveEvents();
    events.retainWhere((event) => !event.coach && isSameDay(event.date, day));
    return events;
  }

  static Future<List<Event>> retrieveScheduledEvents() async {
    List<Event> events = await retrieveEvents();
    events.retainWhere((event) => event.coach);
    return events;
  }

  static retrieveScheduledEventsForDay(DateTime day) async {
    List<Event> events = await retrieveEvents();
    events.retainWhere((event) => event.coach && isSameDay(event.date, day));
    return events;
  }
}
