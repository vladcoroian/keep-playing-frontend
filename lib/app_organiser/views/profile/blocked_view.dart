import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/app_organiser/cubit/organiser_cubit.dart';
import 'package:keep_playing_frontend/constants.dart';
import 'package:keep_playing_frontend/models/organiser.dart';
import 'package:keep_playing_frontend/models/user.dart';
import 'package:keep_playing_frontend/widgets/dialogs.dart';

class BlockedView extends StatefulWidget {
  const BlockedView({Key? key}) : super(key: key);

  @override
  State<BlockedView> createState() => _BlockedViewState();
}

class _BlockedViewState extends State<BlockedView> {
  List<User> coaches = [];
  List<int> blocked = [];

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
    final Widget sliverBlockedCheckboxes =
        BlocBuilder<OrganiserCubit, Organiser>(
      builder: (context, state) {
        blocked = state.blocked;

        List<Widget> blockedCheckboxes = [];
        for (User coach in coaches) {
          blockedCheckboxes.add(
            CheckboxListTile(
              value: blocked.contains(coach.pk),
              onChanged: (bool? newValue) => setState(
                () {
                  if (newValue!) {
                    blocked.add(coach.pk);
                  } else {
                    blocked.remove(coach.pk);
                  }
                },
              ),
              title: Text('${coach.firstName} ${coach.lastName}'),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildListDelegate(
            blockedCheckboxes,
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
          Response response = await API.organiser.updateBlockedList(blocked);
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
          title: const Text('Blocked Coaches'),
        ),
        body: CustomScrollView(
          slivers: [
            sliverBlockedCheckboxes,
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
