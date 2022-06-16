// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:keep_playing_frontend/main.dart';
import 'package:keep_playing_frontend/app_organiser/home_page/events_pending_page.dart';

void main() {
  testWidgets('Landing Page shows two buttons ', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    expect(find.text('Enter as organiser'), findsOneWidget);
    expect(find.text('Enter as coach'), findsOneWidget);
  });
}
