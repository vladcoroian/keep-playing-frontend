import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:keep_playing_frontend/app_organiser/cubit/organiser_cubit.dart';
import 'package:keep_playing_frontend/constants.dart';
import 'package:keep_playing_frontend/models/organiser.dart';
import 'package:keep_playing_frontend/widgets/buttons.dart';
import 'package:keep_playing_frontend/widgets/dialogs.dart';

class DefaultsView extends StatefulWidget {
  const DefaultsView({Key? key}) : super(key: key);

  @override
  State<DefaultsView> createState() => _DefaultsViewState();
}

class _DefaultsViewState extends State<DefaultsView> {
  String _sport = '';
  String _role = '';
  String _location = '';
  int? _price;
  bool initialised = false;

  @override
  Widget build(BuildContext context) {
    if (!initialised) {
      _sport = BlocProvider.of<OrganiserCubit>(context).state.defaultSport;
      _role = BlocProvider.of<OrganiserCubit>(context).state.defaultRole;
      _location =
          BlocProvider.of<OrganiserCubit>(context).state.defaultLocation;
      _price = BlocProvider.of<OrganiserCubit>(context).state.defaultPrice;

      initialised = true;
    }

    final Widget sportForm = ListTile(
      leading: const Icon(Icons.sports_soccer),
      title: DropdownButton<String>(
        value: _sport == "" ? null : _sport,
        items: SPORTS.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        hint: const Text('Enter sport'),
        onChanged: (String? newValue) {
          setState(() {
            _sport = newValue!;
          });
        },
      ),
    );

    final Widget roleForm = ListTile(
      leading: const Icon(Icons.sports),
      title: DropdownButton<String>(
        value: _role == "" ? null : _role,
        items: ROLES.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        hint: const Text('Enter role'),
        onChanged: (String? newValue) {
          setState(() {
            _role = newValue!;
          });
        },
      ),
    );

    final Widget locationForm = ListTile(
      title: TextFormField(
        initialValue: _location,
        readOnly: false,
        decoration: const InputDecoration(
          icon: Icon(Icons.location_on),
          hintText: 'Enter the location',
          labelText: 'Location',
        ),
        onChanged: (text) {
          _location = text;
        },
      ),
    );

    final Widget priceForm = ListTile(
      title: TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        initialValue: _price?.toString(),
        readOnly: false,
        decoration: const InputDecoration(
          icon: Icon(Icons.price_change),
          hintText: 'Enter the price',
          labelText: 'Price',
        ),
        onChanged: (text) {
          _price = int.parse(text);
        },
      ),
    );

    final Widget sliverListOfForms = BlocBuilder<OrganiserCubit, Organiser>(
      builder: (context, state) {
        return SliverList(
          delegate: SliverChildListDelegate(
            [
              sportForm,
              roleForm,
              locationForm,
              priceForm,
            ],
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
          OrganiserDefaults organiserDefaults = OrganiserDefaults(
            defaultSport: _sport,
            defaultRole: _role,
            defaultLocation: _location,
            defaultPrice: _price,
          );

          NavigatorState navigator = Navigator.of(context);
          final OrganiserCubit organiserCubit =
              BlocProvider.of<OrganiserCubit>(context);
          Response response = await API.organiser
              .changeDefaults(organiserDefaults: organiserDefaults);
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
          title: const Text('Defaults'),
        ),
        body: CustomScrollView(
          slivers: [
            sliverListOfForms,
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
              text: 'You haven\'t saved your changes.'),
        )) ??
        false;
  }
}
