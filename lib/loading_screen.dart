import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/app_coach/coach_home_page.dart';
import 'package:keep_playing_frontend/app_organiser/organiser_home_page.dart';
import 'package:keep_playing_frontend/models/user.dart';
import 'package:keep_playing_frontend/stored_data.dart';

class LoadingScreenPage extends StatefulWidget {
  final UserLogin userLogin;

  const LoadingScreenPage({Key? key, required this.userLogin})
      : super(key: key);

  @override
  State<LoadingScreenPage> createState() => _LoadingScreenPageState();
}

class _LoadingScreenPageState extends State<LoadingScreenPage>
    with TickerProviderStateMixin {
  User? _currentUser;
  bool _invalid = false;

  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: true);
    _login();
    super.initState();
  }

  Future<void> _login() async {
    Response response = await API.users.login(userLogin: widget.userLogin);
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
      _invalid = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingScreen = Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.center,
        child: SizedBox(
          height: 50.0,
          width: 50.0,
          child: CircularProgressIndicator(
            value: controller.value,
            semanticsLabel: 'Linear progress indicator',
          ),
        ),
      ),
    );

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
