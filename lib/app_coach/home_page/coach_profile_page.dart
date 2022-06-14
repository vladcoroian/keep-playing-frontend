import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/models/user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User currentUser;

  @override
  void initState() {
    _retrieveUserInformation();
    super.initState();
  }

  void _retrieveUserInformation() async {
    User user = await API.users.getCurrentUser();

    setState(() {
      currentUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget usernameForm = ListTile(
        title: TextFormField(
            initialValue: currentUser.username,
            readOnly: true,
            decoration: const InputDecoration(
              icon: Icon(Icons.account_box),
              hintText: 'Enter your first name',
              labelText: 'First Name',
            )));

    final Widget emailForm = ListTile(
        title: TextFormField(
      initialValue: currentUser.email,
      readOnly: false,
      decoration: const InputDecoration(
        icon: Icon(Icons.email),
        hintText: 'Enter your Email',
        labelText: 'Email',
      ),
    ));

    final Widget firstNameForm = ListTile(
        title: TextFormField(
            initialValue: currentUser.firstName,
            readOnly: true,
            decoration: const InputDecoration(
              icon: Icon(Icons.account_box),
              hintText: 'Enter your first name',
              labelText: 'First Name',
            )));

    final Widget lastNameForm = ListTile(
        title: TextFormField(
            initialValue: currentUser.lastName,
            readOnly: true,
            decoration: const InputDecoration(
              icon: Icon(Icons.account_box),
              hintText: 'Enter your last name',
              labelText: 'Last Name',
            )));

    final Widget locationForm = ListTile(
        title: TextFormField(
      initialValue: currentUser.location,
      readOnly: false,
      decoration: const InputDecoration(
        icon: Icon(Icons.home),
        hintText: 'Enter your location',
        labelText: 'Location',
      ),
    ));

    final Widget phoneNumberForm = ListTile(
        title: InternationalPhoneNumberInput(
            initialValue: PhoneNumber(isoCode: 'GB'),
            hintText: 'Phone Number',
            errorMessage: 'Invalid Phone Number',
            onInputChanged: (PhoneNumber number) {},
            maxLength: 15,
            spaceBetweenSelectorAndTextField: 8,
            autoValidateMode: AutovalidateMode.always,
            keyboardType: TextInputType.number));

    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Profile'),
        ),
        body: Center(
          child: ListView(children: [
            usernameForm,
            emailForm,
            firstNameForm,
            lastNameForm,
            locationForm,
            phoneNumberForm,
          ]),
        ));
  }
}
