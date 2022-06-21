import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/app_organiser/cubit/organiser_cubit.dart';
import 'package:keep_playing_frontend/models/organiser.dart';

import 'profile_view.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Organiser? organiser;

  @override
  void initState() {
    _retrieveOrganiserInformation();
    super.initState();
  }

  void _retrieveOrganiserInformation() async {
    Organiser currentOrganiser = await API.organiser.getOrganiser();

    setState(() {
      organiser = currentOrganiser;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (organiser == null) {
      return const Text('Loading');
    }

    return BlocProvider<OrganiserCubit>(
      create: (BuildContext context) => OrganiserCubit(organiser: organiser!),
      child: const ProfileView(),
    );
  }
}
