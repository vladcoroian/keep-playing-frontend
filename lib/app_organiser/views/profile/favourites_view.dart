import 'package:flutter/material.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/models/user.dart';

class FavouritesView extends StatefulWidget {
  const FavouritesView({Key? key}) : super(key: key);

  @override
  State<FavouritesView> createState() => _FavouritesViewState();
}

class _FavouritesViewState extends State<FavouritesView> {
  List<User> users = [];

  @override
  void initState() {
    _retrieveUsers();
    super.initState();
  }

  Future<void> _retrieveUsers() async {
    List<User> retrievedUsers = await API.user.retrieveAllUsers();
    setState(() {
      users = retrievedUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourites'),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) => CheckboxListTile(
          value: true,
          onChanged: (bool? value) => {},
          title: Text('${users[index].firstName} ${users[index].lastName}'),
        ),
        itemCount: users.length,
      ),
    );
  }
}
