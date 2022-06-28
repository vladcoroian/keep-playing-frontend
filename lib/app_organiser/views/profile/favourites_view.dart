import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/app_organiser/cubit/organiser_cubit.dart';
import 'package:keep_playing_frontend/constants.dart';
import 'package:keep_playing_frontend/models/organiser.dart';
import 'package:keep_playing_frontend/models/user.dart';
import 'package:keep_playing_frontend/widgets/buttons.dart';
import 'package:keep_playing_frontend/widgets/dialogs.dart';
import 'package:keep_playing_frontend/widgets/loading_widgets.dart';

class FavouritesView extends StatefulWidget {
  static const String _title = 'Favourites';

  const FavouritesView({Key? key}) : super(key: key);

  @override
  State<FavouritesView> createState() => _FavouritesViewState();
}

class _FavouritesViewState extends State<FavouritesView> {
  List<User>? _coaches;
  List<int> _favourites = [];

  @override
  void initState() {
    _retrieveUsers();

    super.initState();
  }

  Future<void> _retrieveUsers() async {
    List<User> retrievedUsers = await API.user.retrieveAllUsers();
    retrievedUsers.retainWhere((user) => user.isCoachUser());

    setState(() {
      _coaches = retrievedUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool coachesAreNotLoaded = _coaches == null;

    if (coachesAreNotLoaded) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(FavouritesView._title),
        ),
        body: LOADING_CIRCLE,
      );
    }

    final Widget sliverFavouritesList = BlocBuilder<OrganiserCubit, Organiser>(
      builder: (_, state) {
        _favourites = state.favourites;

        List<Widget> favouritesCheckboxes = [];
        for (User coach in _coaches!) {
          favouritesCheckboxes.add(
            CheckboxListTile(
              value: _favourites.contains(coach.pk),
              onChanged: (bool? newValue) => setState(
                () {
                  if (newValue!) {
                    _favourites.add(coach.pk);
                  } else {
                    _favourites.remove(coach.pk);
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
          textStyle: const TextStyle(fontSize: BUTTON_FONT_SIZE),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) {
              return BlocProvider<OrganiserCubit>.value(
                value: BlocProvider.of<OrganiserCubit>(context),
                child: _SaveChangesDialog(favourites: _favourites),
              );
            },
          );
        },
        child: const Text('Save Changes'),
      ),
    );

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(FavouritesView._title),
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
          builder: (_) => const ExitDialog(
            title: 'Are you sure that you want to exit?',
            text: 'You haven\'t saved your changes.',
          ),
        )) ??
        false;
  }
}

// **************************************************************************
// **************** DIALOGS
// **************************************************************************

class _SaveChangesDialog extends StatelessWidget {
  final List<int> favourites;

  const _SaveChangesDialog({
    required this.favourites,
  });

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialog(
      title: 'Are you sure that you want to save your changes?',
      onNoPressed: () => Navigator.of(context).pop(),
      onYesPressed: () async {
        NavigatorState navigator = Navigator.of(context);
        final OrganiserCubit organiserCubit =
            BlocProvider.of<OrganiserCubit>(context);

        Response response =
            await API.organiser.updateFavouritesList(favourites);
        if (response.statusCode == HTTP_202_ACCEPTED) {
          organiserCubit.retrieveOrganiserInformation();
          navigator.pop();
          navigator.pop();
        } else {
          showDialog(
            context: context,
            builder: (_) => const RequestFailedDialog(),
            barrierDismissible: false,
          );
        }
      },
    );
  }
}
