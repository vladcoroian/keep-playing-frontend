import 'dart:convert';

import 'package:http/http.dart';
import 'package:keep_playing_frontend/models/event.dart';
import 'package:keep_playing_frontend/models/organiser.dart';
import 'package:keep_playing_frontend/models/organiser/organiser_model.dart';
import 'package:keep_playing_frontend/models/user.dart';
import 'package:keep_playing_frontend/stored_data.dart';

import 'api.dart';

class _ApiOrganiserLinks {
  static const String ORGANISER = "${API.PREFIX}organiser/";

  static Uri organiserLink() => Uri.parse(ORGANISER);

  static Uri eventsLink() => Uri.parse("${ORGANISER}events/");

  static Uri addEventLink() => Uri.parse("${ORGANISER}events/");

  static Uri changeEventLink(int pk) => Uri.parse("${ORGANISER}events/$pk/");

  static Uri deleteEventLink(int pk) => Uri.parse("${ORGANISER}events/$pk/");

  static Uri acceptCoachLink({
    required int eventPK,
    required int coachPK,
  }) =>
      Uri.parse("${ORGANISER}events/$eventPK/accept/$coachPK/");

  static Uri updateFavouritesLink() => Uri.parse(ORGANISER);

  static Uri updateBlockedLink() => Uri.parse(ORGANISER);
}

class ApiOrganiser {
  final Client client;

  ApiOrganiser({required this.client});

  Future<Organiser> getOrganiser() async {
    String token = StoredData.getLoginToken();

    Response response = await client.get(
      _ApiOrganiserLinks.organiserLink(),
      headers: <String, String>{
        'Authorization': 'Token $token',
      },
    );
    final body = jsonDecode(response.body);

    return Organiser.fromModel(organiserModel: OrganiserModel.fromJson(body));
  }

  Future<Response> addNewEvent({required NewEvent newEvent}) {
    String token = StoredData.getLoginToken();

    return client.post(
      _ApiOrganiserLinks.addEventLink(),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token $token',
      },
      body: jsonEncode(
        newEvent.toJson(),
      ),
    );
  }

  Future<Response> changeEvent({
    required Event event,
    required NewEvent newEvent,
  }) {
    String token = StoredData.getLoginToken();

    return client.patch(
      _ApiOrganiserLinks.changeEventLink(event.pk),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token $token',
      },
      body: jsonEncode(
        newEvent.toJson(),
      ),
    );
  }

  Future<Response> cancelEvent({
    required Event event,
  }) {
    return client.delete(_ApiOrganiserLinks.deleteEventLink(event.pk));
  }

  Future<Response> acceptCoach({
    required Event event,
    required User coach,
  }) {
    return client.patch(
      _ApiOrganiserLinks.acceptCoachLink(
        eventPK: event.pk,
        coachPK: coach.pk,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{"coach": true},
      ),
    );
  }

  Future<List<Event>> retrieveEvents() async {
    return API.retrieveEvents(_ApiOrganiserLinks.eventsLink());
  }

  Future<Response> updateFavouritesList(List<int> favourites) {
    String token = StoredData.getLoginToken();

    return client.patch(
      _ApiOrganiserLinks.updateFavouritesLink(),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token $token',
      },
      body: jsonEncode(
        <String, dynamic>{"favourites_ids": favourites},
      ),
    );
  }

  Future<Response> updateBlockedList(List<int> blocked) {
    String token = StoredData.getLoginToken();

    return client.patch(
      _ApiOrganiserLinks.updateBlockedLink(),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Token $token',
      },
      body: jsonEncode(
        <String, dynamic>{"blocked_ids": blocked},
      ),
    );
  }
}
