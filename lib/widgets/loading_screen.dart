import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:keep_playing_frontend/constants.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  static const Widget loadingCircle = SpinKitCircle(
    color: APP_COLOR,
    size: 50.0,
  );

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: loadingCircle,
    );
  }
}
