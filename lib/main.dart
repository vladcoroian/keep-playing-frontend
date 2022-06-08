import 'package:flutter/material.dart';

import 'constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Keep Playing',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Keep Playing'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _enterAsOrganiserButton(),
        _enterAsCoachButton(),
      ],
    )));
  }

  Widget _enterAsOrganiserButton() {
    return ElevatedButton(
        style:
            ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20)),
        onPressed: () {},
        child: const Text('Enter as organiser'));
  }

  Widget _enterAsCoachButton() {
    return ElevatedButton(
        style:
            ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20)),
        onPressed: () {},
        child: const Text('Enter as coach'));
  }
}
