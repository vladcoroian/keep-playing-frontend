import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import '../../../constants.dart';
import '../../../widgets/buttons.dart';

class NewEventPage extends StatefulWidget {
  const NewEventPage({Key? key}) : super(key: key);

  @override
  State<NewEventPage> createState() => _NewEventPageState();
}

class _NewEventPageState extends State<NewEventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Event')),
      body: ListView(children: [
        _selectSportForm(),
        _selectDateForm(),
        Center(
            child: SubmitButton(
          onPressed: () {},
        )),
      ]),
    );
  }

  Widget _selectSportForm() {
    return Container(
        padding: const EdgeInsets.all(DEFAULT_PADDING),
        child: TextFormField(
          decoration: const InputDecoration(
            icon: Icon(Icons.sports),
            hintText: 'Enter the sport',
            labelText: 'Sport',
          ),
        ));
  }

  Widget _selectDateForm() {
    return Container(
        padding: const EdgeInsets.all(DEFAULT_PADDING),
        child: DateTimeField(
          decoration: const InputDecoration(
            icon: Icon(Icons.date_range),
            hintText: 'Enter the date',
            labelText: 'Date',
          ),
          format: DateFormat("dd-MMMM-yyyy"),
          onShowPicker: (context, currentValue) {
            return showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                initialDate: currentValue ?? DateTime.now(),
                lastDate: DateTime(2100));
          },
        ));
  }
}

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(DEFAULT_PADDING),
      title: const Center(child: Text('Confirmation')),
      children: <Widget>[
        const Text('Are you sure that you want to post this job?'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CancelButton(onPressed: () => {Navigator.pop(context)}),
            AcceptButton(onPressed: () => {})
          ],
        ),
      ],
    );
  }
}
