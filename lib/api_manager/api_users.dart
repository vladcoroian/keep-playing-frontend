import 'dart:convert';

import 'package:http/http.dart';
import 'package:keep_playing_frontend/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _ApiLinks {
  static const String PREFIX = "https://keep-playing.herokuapp.com/";

  static Uri loginLink() {
    return Uri.parse('${PREFIX}login/');
  }

  static Uri userInformationLink() {
    return Uri.parse("${PREFIX}user/");
  }
}

class ApiUsers {
  final Client client;

  ApiUsers({required this.client});

  Future<Response> login({required UserLogin userLogin}) {
    return client.post(_ApiLinks.loginLink(), body: userLogin.toJson());
  }

  Future<Response> getInformationAboutCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    return client.get(
      _ApiLinks.userInformationLink(),
      headers: <String, String>{'Authorization': 'Token $token'},
    );
  }

  Future<User> getCurrentUser() async {
    Response response = await getInformationAboutCurrentUser();
    final body = jsonDecode(response.body);
    return User.fromModel(userModel: UserModel.fromJson(body));
  }
}
