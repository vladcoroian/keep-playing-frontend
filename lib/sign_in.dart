import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:keep_playing_frontend/app_coach/coach_home_page.dart';
import 'package:keep_playing_frontend/constants.dart';
import 'package:keep_playing_frontend/models/user/user_sign_in.dart';

import 'api_manager/api.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String _username = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    final Widget usernameForm = ListTile(
      title: TextFormField(
        initialValue: _username,
        readOnly: false,
        decoration: const InputDecoration(
          hintText: 'Enter username',
          labelText: 'Username',
        ),
        onChanged: (text) {
          _username = text;
        },
      ),
    );

    final Widget passwordForm = ListTile(
      title: TextFormField(
        initialValue: _password,
        obscureText: true,
        readOnly: false,
        decoration: const InputDecoration(
          hintText: 'Enter password',
          labelText: 'Password',
        ),
        onChanged: (text) {
          _password = text;
        },
      ),
    );

    final Widget signInButton = Container(
      padding: const EdgeInsets.all(BUTTON_PADDING),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: APP_COLOR,
            textStyle: const TextStyle(fontSize: BUTTON_FONT_SIZE)),
        onPressed: () async {
          NavigatorState navigator = Navigator.of(context);
          CoachSignIn coachSignIn = CoachSignIn(
            username: _username,
            password: _password,
            qualification: 'qualification',
          );

          final Response response =
              await API.user.signInAsCoach(coachSignIn: coachSignIn);
          if (response.statusCode == HTTP_202_ACCEPTED) {
            navigator.push(
              MaterialPageRoute(
                builder: (context) => const CoachHomePage(),
              ),
            );
          } else {
            // TODO
          }
        },
        child: const Text('Sign In'),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: ListView(
        children: [
          usernameForm,
          passwordForm,
          Center(child: signInButton),
        ],
      ),
    );
  }
}
