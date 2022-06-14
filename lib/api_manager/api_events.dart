import 'dart:convert';

import 'package:http/http.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class _ApiLinks {
  static const String PREFIX = "https://keep-playing.herokuapp.com/";
  static const String EVENTS = "${PREFIX}events/";
  static const String COACH = "${PREFIX}coach/";

  static Uri eventsLink() {
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

  static Uri takeJobLink(int pk) {
    return Uri.parse("$EVENTS$pk/coach");
  }

  static Uri cancelJobLink(int pk) {
    return Uri.parse("$EVENTS$pk/coach");
  }

  static Uri retrieveCoachLink(int pk) {
    return Uri.parse("$COACH$pk/");
  }
}

class ApiEvents {
  final Client client;

  ApiEvents({required this.client});

  Future<Response> addNewEvent({required NewEvent newEvent}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

    return client.post(_ApiLinks.addEventLink(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token $token',
        },
        body: jsonEncode(newEvent.toJson()));
  }

  Future<Response> changeEvent(
      {required Event event, required NewEvent newEvent}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

    return client.patch(_ApiLinks.updateEventLink(event.pk),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token $token',
        },
        body: jsonEncode(newEvent.toJson()));
  }

  void cancelEvent({required Event event}) {
    client.delete(_ApiLinks.deleteEventLink(event.pk));
  }

  Future<Response> takeJob({required Event event}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

    return client.patch(_ApiLinks.takeJobLink(event.pk),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token $token',
        },
        body: jsonEncode(<String, dynamic>{"coach": true}));
  }

  Future<Response> cancelJob({required Event event}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

    return client.patch(_ApiLinks.cancelJobLink(event.pk),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token $token',
        },
        body: jsonEncode(<String, dynamic>{"coach": false}));
  }

  Future<List<Event>> retrieveEvents() async {
    List<Event> events = [];
    List response =
        json.decode((await client.get(_ApiLinks.eventsLink())).body);
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
