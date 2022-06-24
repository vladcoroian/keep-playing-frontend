import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:keep_playing_frontend/models/user.dart';
import 'package:keep_playing_frontend/models/user/user_sign_in.dart';
import 'package:keep_playing_frontend/stored_data.dart';

import 'api.dart';

class _ApiUserLinks {
  static const String COACH = "${API.PREFIX}coach/";

  static Uri allUsersLink() => Uri.parse("${API.PREFIX}users/");

  static Uri loginLink() => Uri.parse('${API.PREFIX}login/');

  static Uri userInformationLink() => Uri.parse("${API.PREFIX}user/");

  static Uri coachInformationLink({required int pk}) => Uri.parse("$COACH$pk/");

  static Uri signInAsCoachLink() => Uri.parse("${API.PREFIX}new_coach/");
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
    String token = StoredData.getLoginToken();

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
    String token = StoredData.getLoginToken();

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
    final body = json.decode(response.body);
    for (var element in body) {
      users.add(User.fromModel(userModel: UserModel.fromJson(element)));
    }
    return users;
  }

  Future<StreamedResponse> signInAsCoach({
    required CoachSignIn coachSignIn,
    required File? file,
  }) async {
    MultipartRequest multiPartRequest = http.MultipartRequest(
      'POST',
      _ApiUserLinks.signInAsCoachLink(),
    );

    // multiPartRequest.headers.addAll(<String, String>{
    //   'Content-Type': 'multipart/form-data',
    //   'Content-Type': 'application/x-www-form-urlencoded',
    //   // 'Accept': 'application/json',
    // });

    // if (file != null) {
    //   multiPartRequest.files.add(
    //     http.MultipartFile.fromBytes(
    //       'qualification',
    //       File(file.path).readAsBytesSync(),
    //       filename: file.path,
    //     ),
    //   );
    // }

    if (file != null) {
      http.MultipartFile multipartFile =
          await http.MultipartFile.fromPath('qualification', file.path);
      multiPartRequest.files.add(multipartFile);
    }

    multiPartRequest.fields['username'] = coachSignIn.username;
    multiPartRequest.fields['password'] = coachSignIn.password;

    StreamedResponse streamedResponse = await multiPartRequest.send();
    return streamedResponse;
  }
}
