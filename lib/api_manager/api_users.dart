import 'dart:convert';

import 'package:http/http.dart';
import 'package:keep_playing_frontend/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api.dart';

class _ApiLinks {
  static const String COACH = "${API.PREFIX}coach/";

  static Uri loginLink() {
    return Uri.parse('${API.PREFIX}login/');
  }

  static Uri userInformationLink() {
    return Uri.parse("${API.PREFIX}user/");
  }

  static Uri coachInformationLink({required int pk}) {
    return Uri.parse("$COACH$pk/");
  }
}

class ApiUsers {
  final Client client;

  ApiUsers({required this.client});

  Future<Response> login({required UserLogin userLogin}) {
    return client.post(_ApiLinks.loginLink(), body: userLogin.toJson());
  }

  Future<User> getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

    Response response = await client.get(
      _ApiLinks.userInformationLink(),
      headers: <String, String>{'Authorization': 'Token $token'},
    );
    final body = jsonDecode(response.body);

    return User.fromModel(userModel: UserModel.fromJson(body));
  }

  Future<User> getUser(int pk) async {
    Response response =
        await client.get(_ApiLinks.coachInformationLink(pk: pk));
    final body = jsonDecode(response.body);

    return User.fromModel(userModel: UserModel.fromJson(body));
  }
}
