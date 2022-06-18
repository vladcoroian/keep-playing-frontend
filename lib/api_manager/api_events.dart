import 'dart:convert';

import 'package:http/http.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:keep_playing_frontend/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import 'api.dart';

class _ApiEventsLinks {
  static const String EVENTS = "${API.PREFIX}events/";

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
    return Uri.parse("$EVENTS$pk/cancel/");
  }

  static Uri acceptOfferFromCoach(
      {required int eventPK, required int coachPK}) {
    return Uri.parse("$EVENTS$eventPK/accept/$coachPK/");
  }
}

class ApiEvents {
  final Client client;

  ApiEvents({required this.client});

  Future<Response> addNewEvent({required NewEvent newEvent}) {
    return client.post(_ApiEventsLinks.addEventLink(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(newEvent.toJson()));
  }

  Future<Response> changeEvent(
      {required Event event, required NewEvent newEvent}) {
    return client.patch(_ApiEventsLinks.updateEventLink(event.pk),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(newEvent.toJson()));
  }

  void cancelEvent({required Event event}) {
    client.delete(_ApiEventsLinks.deleteEventLink(event.pk));
  }

  Future<Response> acceptCoach({required Event event, required User coach}) {
    return client.patch(
        _ApiEventsLinks.acceptOfferFromCoach(
            eventPK: event.pk, coachPK: coach.pk),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{"coach": true}));
  }

  Future<Response> applyToJob({required Event event}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

    return client.patch(_ApiEventsLinks.applyToJobLink(event.pk),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token $token',
        },
        body: jsonEncode(<String, dynamic>{}));
  }

  Future<Response> cancelJob({required Event event}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

    return client.patch(_ApiEventsLinks.cancelJobLink(event.pk),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token $token',
        },
        body: jsonEncode(<String, dynamic>{"coach": false}));
  }

  Future<List<Event>> retrieveEvents({
    bool? past,
    bool? pending,
    DateTime? onDay,
    User? withCoachUser,
  }) async {
    List<Event> events = [];
    List response =
        json.decode((await client.get(_ApiEventsLinks.eventsLink())).body);
    for (var element in response) {
      events.add(Event(eventModel: EventModel.fromJson(element)));
    }
    events.retainWhere((event) => _checkEvent(
          event: event,
          past: past,
          pending: pending,
          onDay: onDay,
          withCoachUser: withCoachUser,
        ));
    return events;
  }

  bool _checkEvent({
    required Event event,
    bool? past,
    bool? pending,
    DateTime? onDay,
    User? withCoachUser,
  }) {
    bool result = true;
    switch (past) {
      case true:
        result = result && event.isInThePast();
        break;
      case false:
        result = result && !event.isInThePast();
        break;
      case null:
    }
    switch (pending) {
      case true:
        result = result && !event.hasCoach();
        break;
      case false:
        result = result && event.hasCoach();
        break;
      case null:
    }
    switch (onDay) {
      case null:
        break;
      default:
        result = result && isSameDay(event.date, onDay!);
    }
    switch (withCoachUser) {
      case null:
        break;
      default:
        result = result && event.coachPK == withCoachUser!.pk;
    }
    return result;
  }
}
