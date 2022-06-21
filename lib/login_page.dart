import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/constants.dart';
import 'package:keep_playing_frontend/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'loading_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextStyle style = const TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  User? currentUser;

  String _username = '';
  String _password = '';

  void _retrieveCurrentUserInformation() async {
    User user = await API.users.getCurrentUser();
    setState(() {
      currentUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Widget appTitle = FittedBox(
        fit: BoxFit.fitWidth,
        child: Text('Keep\nPlaying',
            textAlign: TextAlign.center,
            style: TextStyle(color: APP_COLOR, fontSize: 400.0)));

    final Widget usernameField = TextField(
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Username",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      onChanged: (text) {
        _username = text;
      },
    );

    final Widget passwordField = TextField(
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      onChanged: (text) {
        _password = text;
      },
    );

    final Widget loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: APP_COLOR,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          UserLogin userLogin =
              UserLogin(username: _username, password: _password);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => LoadingScreenPage(
                userLogin: userLogin,
              ),
            ),
          );
        },
        child: Text(
          "Login",
          textAlign: TextAlign.center,
          style: style.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                appTitle,
                const SizedBox(height: 45.0),
                usernameField,
                const SizedBox(height: 25.0),
                passwordField,
                const SizedBox(
                  height: 35.0,
                ),
                loginButton,
                const SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
