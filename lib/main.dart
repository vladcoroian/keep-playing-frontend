import 'package:flutter/material.dart';
import 'package:keep_playing_frontend/app_coach/coach_home_page.dart';

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
      home: const LogInPage(title: 'Keep Playing'),
    );
  }
}

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Text('TODO')),
          );
        },
        child: const Text('Enter as organiser'));
  }

  Widget _enterAsCoachButton() {
    return ElevatedButton(
        style:
            ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CoachHomePage()),
          );
        },
        child: const Text('Enter as coach'));
  }
}
