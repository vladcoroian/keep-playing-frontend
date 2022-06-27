import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/app_coach/home_page.dart';
import 'package:keep_playing_frontend/models/user.dart';
import 'package:keep_playing_frontend/stored_data.dart';
import 'package:keep_playing_frontend/widgets/loading_widgets.dart';
import 'package:keep_playing_frontend/widgets/log_in.dart';

class CoachLoginRedirect extends StatefulWidget {
  final UserLogin userLogin;

  const CoachLoginRedirect({Key? key, required this.userLogin})
      : super(key: key);

  @override
  State<CoachLoginRedirect> createState() => _CoachLoginRedirectState();
}

class _CoachLoginRedirectState extends State<CoachLoginRedirect> {
  User? _currentUser;
  bool _invalidCredentials = false;

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
        _invalidCredentials = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_invalidCredentials) {
      Navigator.of(context).pop(LoginStatus.INVALID_CREDENTIALS);
    }

    if (_currentUser == null) {
      return const LoadingScreen();
    }

    if (!_currentUser!.isCoachUser()) {
      Navigator.of(context).pop(LoginStatus.NOT_COACH_CREDENTIALS);
    }

    return const CoachHomePage();
  }
}
