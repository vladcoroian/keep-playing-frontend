import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:keep_playing_frontend/constants.dart';

import 'dialogs.dart';

const Widget _loadingCircle = SpinKitCircle(
  color: APP_COLOR,
  size: 50.0,
);

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _loadingCircle,
    );
  }
}

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SimpleDialog(
      contentPadding: EdgeInsets.all(DIALOG_PADDING),
      children: [_loadingCircle],
    );
  }
}
