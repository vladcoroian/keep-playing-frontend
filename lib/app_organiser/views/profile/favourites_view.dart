import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/app_organiser/cubit/organiser_cubit.dart';
import 'package:keep_playing_frontend/constants.dart';
import 'package:keep_playing_frontend/models/organiser.dart';
import 'package:keep_playing_frontend/models/user.dart';
import 'package:keep_playing_frontend/widgets/dialogs.dart';
import 'package:keep_playing_frontend/widgets/loading_widgets.dart';

class FavouritesView extends StatefulWidget {
  const FavouritesView({Key? key}) : super(key: key);

  @override
  State<FavouritesView> createState() => _FavouritesViewState();
}

class _FavouritesViewState extends State<FavouritesView> {
  List<User> coaches = [];
  List<int> favourites = [];

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
    if (coaches.isEmpty) {
      return const LoadingScreen();
    }

    final Widget sliverFavouritesList = BlocBuilder<OrganiserCubit, Organiser>(
      builder: (context, state) {
        favourites = state.favourites;

        List<Widget> favouritesCheckboxes = [];
        for (User coach in coaches) {
          favouritesCheckboxes.add(
            CheckboxListTile(
              value: favourites.contains(coach.pk),
              onChanged: (bool? newValue) => setState(
                () {
                  if (newValue!) {
                    favourites.add(coach.pk);
                  } else {
                    favourites.remove(coach.pk);
                  }
                },
              ),
              title: Text('${coach.firstName} ${coach.lastName}'),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildListDelegate(
            favouritesCheckboxes,
          ),
        );
      },
    );

    final Widget saveChangesButton = Container(
      padding: const EdgeInsets.all(BUTTON_PADDING),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: APP_COLOR,
            textStyle: const TextStyle(fontSize: BUTTON_FONT_SIZE)),
        onPressed: () async {
          NavigatorState navigator = Navigator.of(context);
          final OrganiserCubit organiserCubit =
              BlocProvider.of<OrganiserCubit>(context);
          Response response =
              await API.organiser.updateFavouritesList(favourites);
          if (response.statusCode == HTTP_202_ACCEPTED) {
            organiserCubit.retrieveOrganiserInformation();
          } else {
            // TODO
          }
          navigator.pop();
        },
        child: const Text('Save Changes'),
      ),
    );

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Favourites'),
        ),
        body: CustomScrollView(
          slivers: [
            sliverFavouritesList,
            SliverList(
              delegate:
                  SliverChildListDelegate([Center(child: saveChangesButton)]),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => ExitDialog(
              context: context,
              title: 'Are you sure that you want to exit?',
              text: 'You haven\'t saved your changes.'),
        )) ??
        false;
  }
}
