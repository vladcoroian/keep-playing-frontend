import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import 'models/event.dart';
import 'models/user.dart';

class _API_LINKS {
  static const String PREFIX = "https://keep-playing.herokuapp.com/";
  static const String EVENTS = "${PREFIX}events/";

  static Uri addEventLink() {
    return Uri.parse(EVENTS);
  }

  static Uri updateEventLink(int pk) {
    return Uri.parse("$EVENTS$pk/");
  }

  static Uri deleteEventLink(int pk) {
    return Uri.parse("$EVENTS$pk/");
  }

  static Uri getEventsLink() {
    return Uri.parse(EVENTS);
  }

  static Uri loginLink() {
    return Uri.parse('${PREFIX}login/');
  }

  static Uri userInformationLink() {
    return Uri.parse("${PREFIX}user/");
  }
}

class API {
  static Client client = http.Client();

  static void updateEvent({required Event event, Object? body}) {
    client.patch(_API_LINKS.updateEventLink(event.pk), body: body);
  }

  static void eventHasCoach({required Event event}) {
    updateEvent(event: event, body: {"coach": "true"});
  }

  static void eventHasNoCoach({required Event event}) {
    updateEvent(event: event, body: {"coach": "false"});
  }

  static Future<Response> addNewEvent({required NewEvent newEvent}) {
    return client.post(_API_LINKS.addEventLink(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: newEvent.toJson());
  }

  static Future<Response> changeEvent(
      {required Event event, required NewEvent newEvent}) {
    return client.patch(_API_LINKS.updateEventLink(event.pk),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: newEvent.toJson());
  }

  static void cancelEvent({required Event event}) {
    client.delete(_API_LINKS.deleteEventLink(event.pk));
  }

  static Future<Response> login({required UserLogin userLogin}) {
    return client.post(_API_LINKS.loginLink(), body: userLogin.toJson());
  }

  static Future<Response> getInformationAboutCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    return client.get(
      _API_LINKS.userInformationLink(),
      headers: <String, String>{'Authorization': 'Token $token'},
    );
  }

  static Future<User> getCurrentUser() async {
    Response response = await getInformationAboutCurrentUser();
    final body = jsonDecode(response.body);
    return User.fromModel(userModel: UserModel.fromJson(body));
  }

  static Future<List<Event>> retrieveEvents() async {
    List<Event> events = [];
    List response =
        json.decode((await client.get(_API_LINKS.getEventsLink())).body);
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
