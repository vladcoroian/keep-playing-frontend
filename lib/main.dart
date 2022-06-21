import 'package:flutter/material.dart';

import 'constants.dart';
import 'login_page.dart';

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
        primarySwatch: APP_COLOR,
      ),
      home: const LogInPage(title: 'Log In Page'),
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
          _EnterAsOrganiserButton(context: context),
          const SizedBox(height: 50),
          _EnterAsCoachButton(context: context),
        ],
      )),
    );
  }
}

class _EnterAsCoachButton extends StatelessWidget {
  const _EnterAsCoachButton({
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 50.0,
        width: 300.0,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 25)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            child: const Text('Enter as coach')));
  }
}

class _EnterAsOrganiserButton extends StatelessWidget {
  const _EnterAsOrganiserButton({
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 50.0,
        width: 300.0,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 25)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            child: const Text('Enter as organiser')));
  }
}
