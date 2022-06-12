import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:table_calendar/table_calendar.dart';

import 'models/event.dart';

class URL {
  static const String PREFIX = "https://keep-playing.herokuapp.com/";
  static const String EVENTS = "${PREFIX}events/";

  static Client client = http.Client();

  static Uri addEvent() {
    return Uri.parse(EVENTS);
  }

  static Uri updateEvent(int pk) {
    return Uri.parse("$EVENTS$pk/");
  }

  static Uri deleteEvent(int pk) {
    return Uri.parse("$EVENTS$pk/");
  }

  static Future<List<Event>> retrieveEvents() async {
    List<Event> events = [];
    List response = json.decode((await client.get(Uri.parse(URL.EVENTS))).body);
    for (var element in response) {
      events.add(Event.fromJson(element));
    }
    return events;
  }

  static Future<List<Event>> retrievePendingEvents() async {
    List<Event> pendingEvents = [];
    List response = json.decode((await client.get(Uri.parse(URL.EVENTS))).body);
    for (var element in response) {
      Event event = Event.fromJson(element);
      if (!event.coach) {
        pendingEvents.add(Event.fromJson(element));
      }
    }
    return pendingEvents;
  }

  static Future<List<Event>> retrievePendingEventsForThisDay(
      DateTime day) async {
    List<Event> pendingEventsForThisDay = [];
    List response = json.decode((await client.get(Uri.parse(URL.EVENTS))).body);
    for (var element in response) {
      Event event = Event.fromJson(element);
      if (!event.coach && isSameDay(event.getDate(), day)) {
        pendingEventsForThisDay.add(Event.fromJson(element));
      }
    }
    return pendingEventsForThisDay;
  }

  static Future<List<Event>> retrieveScheduledEvents() async {
    List<Event> scheduledEvents = [];
    List response = json.decode((await client.get(Uri.parse(URL.EVENTS))).body);
    for (var element in response) {
      Event event = Event.fromJson(element);
      if (event.coach) {
        scheduledEvents.add(Event.fromJson(element));
      }
    }
    return scheduledEvents;
  }
}
