import 'dart:convert';

import 'package:http/http.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:keep_playing_frontend/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class _ApiLinks {
  static const String PREFIX = "https://keep-playing.herokuapp.com/";
  static const String EVENTS = "${PREFIX}events/";

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

  static Uri applyToJobLink(int pk) {
    return Uri.parse("$EVENTS$pk/apply/");
  }

  static Uri cancelJobLink(int pk) {
    return Uri.parse("$EVENTS$pk/coach");
  }

  static Uri acceptOfferFromCoach(
      {required int eventPK, required int coachPK}) {
    return Uri.parse("$EVENTS$eventPK/accept/$coachPK/");
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

  Future<Response> applyToJob({required Event event}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

    print(_ApiLinks.applyToJobLink(event.pk));

    return client.patch(_ApiLinks.applyToJobLink(event.pk),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token $token',
        },
        body: jsonEncode(<String, dynamic>{}));
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

  Future<Response> acceptCoach(
      {required Event event, required User coach}) async {
    return client.patch(
        _ApiLinks.acceptOfferFromCoach(eventPK: event.pk, coachPK: coach.pk),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{"coach": true}));
  }

  bool _checkEvent(
      {required Event event, bool? pending, bool? sameDay, DateTime? day}) {
    bool result = true;
    switch (pending) {
      case true:
        {
          result = result && !event.coach;
        }
        break;
      case false:
        {
          result = result && event.coach;
        }
        break;
      case null:
    }
    switch (sameDay) {
      case true:
        {
          result = result && isSameDay(event.date, day);
        }
        break;
      case false:
      case null:
    }
    return result;
  }

  Future<List<Event>> retrieveEvents(
      {bool? pending, bool? sameDay, DateTime? day}) async {
    List<Event> events = [];
    List response =
        json.decode((await client.get(_ApiLinks.eventsLink())).body);
    for (var element in response) {
      events.add(Event(eventModel: EventModel.fromJson(element)));
    }
    events.retainWhere((event) => _checkEvent(
        event: event, pending: pending, sameDay: sameDay, day: day));
    return events;
  }
}
