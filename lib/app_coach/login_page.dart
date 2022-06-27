import 'package:flutter/material.dart';
import 'package:keep_playing_frontend/constants.dart';
import 'package:keep_playing_frontend/models/user.dart';
import 'package:keep_playing_frontend/widgets/buttons.dart';

import 'login_redirect.dart';
import 'sign_up.dart';

class CoachLoginPage extends StatefulWidget {
  const CoachLoginPage({Key? key}) : super(key: key);

  @override
  State<CoachLoginPage> createState() => _CoachLoginPageState();
}

class _CoachLoginPageState extends State<CoachLoginPage> {
  TextStyle style = const TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  String _username = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    const Widget appTitle = FittedBox(
      fit: BoxFit.fitWidth,
      child: Text(
        'Keep\nPlaying',
        textAlign: TextAlign.center,
        style: TextStyle(color: APP_COLOR, fontSize: 400.0),
      ),
    );

    final Widget usernameField = TextFormField(
      obscureText: false,
      style: style,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Username",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
      onChanged: (text) {
        _username = text;
      },
    );

    final Widget passwordField = TextFormField(
      obscureText: true,
      style: style,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
      onChanged: (text) {
        _password = text;
      },
    );

    final Widget loginButton = Container(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: APP_COLOR,
          textStyle: const TextStyle(fontSize: BUTTON_FONT_SIZE),
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
        ),
        onPressed: () async {
          UserLogin userLogin =
          UserLogin(username: _username, password: _password);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CoachLoginRedirect(
                userLogin: userLogin,
              ),
            ),
          );
        },
        child: Text(
          "Log In",
          textAlign: TextAlign.center,
          style: style.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    final Widget signUpAsCoachButton = Container(
      padding: const EdgeInsets.all(BUTTON_PADDING),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: BUTTON_GRAY_COLOR,
            textStyle: const TextStyle(fontSize: BUTTON_FONT_SIZE)),
        onPressed: () async {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const CoachSignUpPage(),
            ),
          );
        },
        child: const Text('Sign Up as Coach'),
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
                  height: 50.0,
                ),
                signUpAsCoachButton,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
