import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/app_organiser/cubit/organiser_cubit.dart';
import 'package:keep_playing_frontend/models/organiser.dart';
import 'package:keep_playing_frontend/models/user.dart';

class FavouritesView extends StatefulWidget {
  const FavouritesView({Key? key}) : super(key: key);

  @override
  State<FavouritesView> createState() => _FavouritesViewState();
}

class _FavouritesViewState extends State<FavouritesView> {
  List<User> coaches = [];

  @override
  void initState() {
    _retrieveUsers();
    super.initState();
  }

  Future<void> _retrieveUsers() async {
    List<User> retrievedUsers = await API.user.retrieveAllUsers();
    retrievedUsers.retainWhere((user) => user.isCoachUser());
    setState(() {
      coaches = retrievedUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourites'),
      ),
      body: BlocBuilder<OrganiserCubit, Organiser>(builder: (context, state) {
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) => CheckboxListTile(
            value: state.favourites.contains(coaches[index].pk),
            onChanged: (bool? value) => {},
            title:
                Text('${coaches[index].firstName} ${coaches[index].lastName}'),
          ),
          itemCount: coaches.length,
        );
      }),
    );
  }
}
