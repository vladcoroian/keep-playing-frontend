import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/app_coach/coach_home_page.dart';
import 'package:keep_playing_frontend/app_organiser/organiser_home_page.dart';
import 'package:keep_playing_frontend/models/user.dart';
import 'package:keep_playing_frontend/stored_data.dart';
import 'package:keep_playing_frontend/widgets/loading_widgets.dart';

class LoginRedirect extends StatefulWidget {
  final UserLogin userLogin;

  const LoginRedirect({Key? key, required this.userLogin}) : super(key: key);

  @override
  State<LoginRedirect> createState() => _LoginRedirectState();
}

class _LoginRedirectState extends State<LoginRedirect> {
  User? _currentUser;
  bool _invalid = false;

  @override
  void initState() {
    _login();
    super.initState();
  }

  Future<void> _login() async {
    Response response = await API.user.login(userLogin: widget.userLogin);
    if (response.statusCode == HTTP_200_OK) {
      /* Save the token to shared preferences. */
      final body = jsonDecode(response.body);
      await StoredData.setLoginToken(body['token']);

      /* Retrieve current user information. */
      await StoredData.setCurrentUser();
      setState(() {
        _currentUser = StoredData.getCurrentUser();
      });
    } else {
      setState(() {
        _invalid = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_invalid) {
      Navigator.of(context).pop();
    }

    if (_currentUser == null) {
      return const LoadingScreen();
    }

    if (_currentUser!.isCoachUser()) {
      return const CoachHomePage();
    }

    return const OrganiserHomePage();
  }
}
