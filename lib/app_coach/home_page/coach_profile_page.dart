import 'package:flutter/material.dart';

import 'package:keep_playing_frontend/constants.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
      ),
      body: Center(
          child: ListView(
            children: [
              _showName(),
              _showEmail(),
              _showHomeBase(),
              _showSportSelections(),
              _showPhoneNumber(),
            ]
          ),
      ));
  }

  Widget _showName() {
    return Container(
      padding: const EdgeInsets.all(DEFAULT_PADDING),
      child: Column(
          children: [
            TextFormField(
            initialValue: "<name in DB>",
            readOnly: false,
            decoration: const InputDecoration(
              icon: Icon(Icons.account_box),
              hintText: 'Enter your first name',
              labelText: 'First Name',
              ),
            ),
            const SizedBox(
              height: 20
            ),
            TextFormField(
              initialValue: "<name in DB>",
              readOnly: false,
              decoration: const InputDecoration(
                icon: Visibility(
                    child: Icon(Icons.account_box),
                    maintainSize: true,
                    maintainState: true,
                    maintainAnimation: true,
                    visible: false,
                ),
                hintText: 'Enter your last name',
                labelText: 'Last Name',
              ),
            ),
          ]
      ),
    );
  }

  Widget _showPhoneNumber() {
    return Container(
        padding: const EdgeInsets.all(DEFAULT_PADDING),
        child: InternationalPhoneNumberInput(
          hintText: 'Phone Number',
          errorMessage: 'Invalid Phone Number',
          onInputChanged: (PhoneNumber number) {
            print('1111111');
          },
          maxLength: 15,
          spaceBetweenSelectorAndTextField: 8,
          autoValidateMode: AutovalidateMode.always,
          keyboardType: TextInputType.number
        )
    );
  }

  Widget _showHomeBase() {
    return Container(
        padding: const EdgeInsets.all(DEFAULT_PADDING),
        child: TextFormField(
          initialValue: "<homebase from DB>",
          readOnly: false,
          decoration: const InputDecoration(
            icon: Icon(Icons.home),
            hintText: 'Enter your base address',
            labelText: 'Homebase Address',
          ),
        ));
  }

  Widget _showEmail() {
    return Container(
        padding: const EdgeInsets.all(DEFAULT_PADDING),
        child: TextFormField(
          initialValue: "<email from DB>",
          readOnly: false,
          decoration: const InputDecoration(
            icon: Icon(Icons.email),
            hintText: 'Enter your Email',
            labelText: 'Email',
          ),
        ));
  }

}

