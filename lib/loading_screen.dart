import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/app_coach/coach_home_page.dart';
import 'package:keep_playing_frontend/app_organiser/organiser_home_page.dart';
import 'package:keep_playing_frontend/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingScreenPage extends StatefulWidget {
  final UserLogin userLogin;

  const LoadingScreenPage({Key? key, required this.userLogin})
      : super(key: key);

  @override
  State<LoadingScreenPage> createState() => _LoadingScreenPageState();
}

class _LoadingScreenPageState extends State<LoadingScreenPage> {
  User? _currentUser;
  bool _invalid = false;

  @override
  void initState() {
    _login();
    super.initState();
  }

  Future<void> _login() async {
    Response response = await API.users.login(userLogin: widget.userLogin);
    if (response.statusCode == HTTP_200_OK) {
      /* Save the token to shared preferences. */
      final body = jsonDecode(response.body);
      await _saveLoginTokenToSharedPreferences(body['token']);

      /* Retrieve current user information. */
      User user = await API.users.getCurrentUser();
      setState(() {
        _currentUser = user;
      });
    } else {
      _invalid = true;
    }
  }

  Future<String> _saveLoginTokenToSharedPreferences(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    return prefs.getString('token') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    // TODO: loadingScreen
    const Widget loadingScreen = Text('Loading');

    if (_invalid) {
      Navigator.of(context).pop();
    }

    if (_currentUser == null) {
      return loadingScreen;
    }

    if (_currentUser!.isCoach()) {
      return const CoachHomePage();
    }

    return const OrganiserHomePage();
  }
}
