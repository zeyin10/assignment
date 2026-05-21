import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yummy/screens/login_page.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoginPage(onLogIn: (_) async {}),
      ),
    );
    expect(find.text('CinemaScope'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
  });
}
