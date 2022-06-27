import 'package:flutter/material.dart';
import 'package:keep_playing_frontend/constants.dart';
import 'package:keep_playing_frontend/models/user.dart';
import 'package:keep_playing_frontend/widgets/buttons.dart';
import 'package:keep_playing_frontend/widgets/images.dart';
import 'package:keep_playing_frontend/widgets/log_in.dart';

import 'login_redirect.dart';
import 'sign_up.dart';

class OrganiserLoginPage extends StatefulWidget {
  const OrganiserLoginPage({Key? key}) : super(key: key);

  @override
  State<OrganiserLoginPage> createState() => _OrganiserLoginPageState();
}

class _OrganiserLoginPageState extends State<OrganiserLoginPage> {
  TextStyle style = const TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  String _username = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    final Widget appLogo = APP_LOGO;

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
          Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (_) => OrganiserLoginRedirect(
                    userLogin: userLogin,
                  ),
                ),
              )
              .then(
                (value) {
              switch (value) {
                case LoginStatus.INVALID_CREDENTIALS:
                  showDialog(
                      context: context,
                      builder: (_) {
                        return const InvalidCredentialsDialog();
                      });
                  break;
                case LoginStatus.NOT_ORGANISER_CREDENTIALS:
                  showDialog(
                      context: context,
                      builder: (_) {
                        return const NotOrganiserCredentialsDialog();
                      });
                  break;
              }
            },
          );
        },
        child: Text(
          "Log In as Organiser",
          textAlign: TextAlign.center,
          style: style.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    final Widget signUpAsOrganiserButton = Container(
      padding: const EdgeInsets.fromLTRB(0, BUTTON_PADDING, 0, 0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: SIGN_UP_BUTTON_COLOR,
            textStyle: const TextStyle(fontSize: BUTTON_FONT_SIZE)),
        onPressed: () async {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const OrganiserSignUpPage(),
            ),
          );
        },
        child: const Text('Sign Up as Organiser'),
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
                appLogo,
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
                signUpAsOrganiserButton,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
