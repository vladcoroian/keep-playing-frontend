import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keep_playing_frontend/constants.dart';
import 'package:keep_playing_frontend/models/user/user_sign_in.dart';
import 'package:keep_playing_frontend/widgets/buttons.dart';
import 'package:keep_playing_frontend/widgets/dialogs.dart';

import '../api_manager/api.dart';

class CoachSignUpPage extends StatefulWidget {
  const CoachSignUpPage({Key? key}) : super(key: key);

  @override
  State<CoachSignUpPage> createState() => _CoachSignUpPageState();
}

class _CoachSignUpPageState extends State<CoachSignUpPage> {
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

    final uploadQualificationButton = Container(
      padding: const EdgeInsets.all(BUTTON_PADDING),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: APP_COLOR,
            textStyle: const TextStyle(fontSize: BUTTON_FONT_SIZE)),
        onPressed: () async {
          _qualification = await _getImage();
        },
        child: const Text('Upload qualification'),
      ),
    );


    final Widget signUpButton = Container(
      padding: const EdgeInsets.all(BUTTON_PADDING),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: SIGN_UP_BUTTON_COLOR,
            textStyle: const TextStyle(fontSize: BUTTON_FONT_SIZE)),
        onPressed: () async {
          NavigatorState navigator = Navigator.of(context);
          CoachSignUp coachSignUp = CoachSignUp(
            username: _username,
            password: _password,
            qualificationFile: _qualification,
          );

          final StreamedResponse streamedResponse =
              await API.user.signUpAsCoach(
            coachSignUp: coachSignUp,
          );
          if (streamedResponse.statusCode == HTTP_200_OK) {
            navigator.pop();
          } else {
            showDialog(
              context: context,
              builder: (_) => const RequestFailedDialog(),
              barrierDismissible: false,
            );
          }
        },
        child: const Text('Sign Up as Coach'),
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
          const SizedBox(height: 50.0),
          Center(child: signUpButton),
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
