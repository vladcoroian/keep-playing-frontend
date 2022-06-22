import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:keep_playing_frontend/app_organiser/cubit/organiser_cubit.dart';
import 'package:keep_playing_frontend/models/user.dart';
import 'package:keep_playing_frontend/stored_data.dart';

import 'profile/blocked_page.dart';
import 'profile/favourites_page.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User currentUser = StoredData.getCurrentUser();

    final Widget usernameForm = ListTile(
      title: TextFormField(
        initialValue: currentUser.username,
        readOnly: true,
        decoration: const InputDecoration(
          icon: Icon(Icons.account_box),
          hintText: 'Enter your username',
          labelText: 'Username',
        ),
      ),
    );

    final Widget emailForm = ListTile(
      title: TextFormField(
        initialValue: currentUser.email,
        readOnly: false,
        decoration: const InputDecoration(
          icon: Icon(Icons.email),
          hintText: 'Enter your Email',
          labelText: 'Email',
        ),
      ),
    );

    final Widget firstNameForm = ListTile(
      title: TextFormField(
        initialValue: currentUser.firstName,
        readOnly: true,
        decoration: const InputDecoration(
          icon: Icon(Icons.account_box),
          hintText: 'Enter your first name',
          labelText: 'First Name',
        ),
      ),
    );

    final Widget lastNameForm = ListTile(
      title: TextFormField(
        initialValue: currentUser.lastName,
        readOnly: true,
        decoration: const InputDecoration(
          icon: Icon(Icons.account_box),
          hintText: 'Enter your last name',
          labelText: 'Last Name',
        ),
      ),
    );

    final Widget locationForm = ListTile(
      title: TextFormField(
        initialValue: currentUser.location,
        readOnly: false,
        decoration: const InputDecoration(
          icon: Icon(Icons.home),
          hintText: 'Enter your location',
          labelText: 'Location',
        ),
      ),
    );

    final Widget phoneNumberForm = ListTile(
      title: InternationalPhoneNumberInput(
        initialValue: PhoneNumber(isoCode: 'GB', phoneNumber: '07951273003'),
        hintText: 'Phone Number',
        errorMessage: 'Invalid Phone Number',
        onInputChanged: (PhoneNumber number) {},
        maxLength: 15,
        spaceBetweenSelectorAndTextField: 8,
        autoValidateMode: AutovalidateMode.always,
        keyboardType: TextInputType.number,
      ),
    );

    final Widget favouritesListTile = ListTile(
      title: const Text('Favourites'),
      trailing: const Icon(Icons.arrow_forward),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => FavouritesPage(
            organiserCubit: BlocProvider.of<OrganiserCubit>(context),
          ),
        ),
      ),
    );

    final Widget blockedListTile = ListTile(
      title: const Text('Blocked'),
      trailing: const Icon(Icons.arrow_forward),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BlockedPage(
            organiserCubit: BlocProvider.of<OrganiserCubit>(context),
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
      ),
      body: Center(
        child: ListView(
          children: [
            usernameForm,
            emailForm,
            firstNameForm,
            lastNameForm,
            locationForm,
            phoneNumberForm,
            favouritesListTile,
            blockedListTile,
          ],
        ),
      ),
    );
  }
}