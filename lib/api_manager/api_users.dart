import 'dart:convert';

import 'package:http/http.dart';
import 'package:keep_playing_frontend/models/user.dart';
import 'package:keep_playing_frontend/stored_data.dart';

import 'api.dart';

class _ApiUserLinks {
  static const String COACH = "${API.PREFIX}coach/";

  static Uri allUsersLink() => Uri.parse("${API.PREFIX}users/");

  static Uri loginLink() => Uri.parse('${API.PREFIX}login/');

  static Uri userInformationLink() => Uri.parse("${API.PREFIX}user/");

  static Uri coachInformationLink({required int pk}) => Uri.parse("$COACH$pk/");
}

class ApiUsers {
  final Client client;

  ApiUsers({required this.client});

  Future<Response> login({required UserLogin userLogin}) {
    return client.post(
      _ApiUserLinks.loginLink(),
      body: userLogin.toJson(),
    );
  }

  Future<User> getCurrentUser() async {
    String token = await StoredData.getLoginTokenFromStorage();

    Response response = await client.get(
      _ApiUserLinks.userInformationLink(),
      headers: <String, String>{
        'Authorization': 'Token $token',
      },
    );
    final body = jsonDecode(response.body);

    return User.fromModel(userModel: UserModel.fromJson(body));
  }

  Future<UserModel> getCurrentUserModel() async {
    String token = await StoredData.getLoginTokenFromStorage();

    Response response = await client.get(
      _ApiUserLinks.userInformationLink(),
      headers: <String, String>{
        'Authorization': 'Token $token',
      },
    );
    final body = jsonDecode(response.body);

    return UserModel.fromJson(body);
  }

  Future<User> getUser(int pk) async {
    Response response =
        await client.get(_ApiUserLinks.coachInformationLink(pk: pk));
    final body = jsonDecode(response.body);

    return User.fromModel(userModel: UserModel.fromJson(body));
  }

  Future<List<User>> retrieveAllUsers() async {
    List<User> users = [];
    final Response response = await client.get(
      _ApiUserLinks.allUsersLink(),
    );
    final List body = json.decode(response.body);
    for (var element in body) {
      users.add(User.fromModel(userModel: UserModel.fromJson(element)));
    }
    return users;
  }
}
