import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
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
  File? _qualification;

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

    final Widget uploadQualificationButton = MaterialButton(
      color: Colors.blue,
      child: Text(
        "Upload qualification",
        style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
      ),
      onPressed: () async {
        _qualification = await _getImage();
      },
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

          final StreamedResponse streamedResponse =
              await API.user.signInAsCoach(
            coachSignIn: coachSignIn,
            file: _qualification,
          );
          print(streamedResponse.statusCode);
          if (streamedResponse.statusCode == HTTP_202_ACCEPTED) {
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
          uploadQualificationButton,
          Center(child: signInButton),
        ],
      ),
    );
  }

  Future<File> _getImage() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);

    File file = File(image!.path);
    return file;
  }
}
