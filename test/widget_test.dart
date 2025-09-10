import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cnh_n/screens/splash_screen.dart';

void main() {
  testWidgets('Splash screen shows app title', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: SplashScreen(
        onFinished: () {},
        isFirstLaunch: false,
      ),
    ));
    await tester.pump(const Duration(milliseconds: 1600));
    expect(find.text('Fly Journey'), findsOneWidget);
  });
}
