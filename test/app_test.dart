import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:yummy/models/app_user.dart';
import 'package:yummy/models/cart_manager.dart';
import 'package:yummy/screens/login_page.dart';

void main() {
  group('AppUser', () {
    test('default values are correct', () {
      const user = AppUser(uid: 'u1', email: 'test@test.com');
      expect(user.uid, 'u1');
      expect(user.email, 'test@test.com');
      expect(user.displayName, '');
      expect(user.points, 0);
    });

    test('fromMap creates user correctly', () {
      final map = {
        'uid': 'u2',
        'email': 'a@b.com',
        'displayName': 'Alice',
        'points': 100,
      };
      final user = AppUser.fromMap(map);
      expect(user.uid, 'u2');
      expect(user.email, 'a@b.com');
      expect(user.displayName, 'Alice');
      expect(user.points, 100);
    });

    test('toMap round-trips correctly', () {
      const user = AppUser(
        uid: 'u3',
        email: 'b@c.com',
        displayName: 'Bob',
        points: 50,
      );
      final map = user.toMap();
      expect(map['uid'], 'u3');
      expect(map['email'], 'b@c.com');
      expect(map['displayName'], 'Bob');
      expect(map['points'], 50);
    });

    test('fromMap handles missing fields gracefully', () {
      final user = AppUser.fromMap({});
      expect(user.uid, '');
      expect(user.email, '');
      expect(user.displayName, '');
      expect(user.points, 0);
    });
  });

  group('CartManager', () {
    late CartManager cart;

    setUp(() => cart = CartManager());

    test('starts empty', () {
      expect(cart.items, isEmpty);
      expect(cart.totalCost, 0.0);
    });

    test('addItem increases count', () {
      cart.addItem(CartItem(
        id: '1', name: 'IMAX Ticket', price: 22.99, quantity: 1,
      ));
      expect(cart.items.length, 1);
    });

    test('totalCost sums correctly', () {
      cart.addItem(CartItem(id: '1', name: 'A', price: 10.0, quantity: 2));
      cart.addItem(CartItem(id: '2', name: 'B', price: 5.0,  quantity: 1));
      expect(cart.totalCost, 25.0);
    });

    test('removeItem removes by id', () {
      cart.addItem(CartItem(id: '1', name: 'A', price: 10.0, quantity: 1));
      cart.addItem(CartItem(id: '2', name: 'B', price: 5.0,  quantity: 1));
      cart.removeItem('1');
      expect(cart.items.length, 1);
      expect(cart.items.first.id, '2');
    });

    test('resetCart clears everything', () {
      cart.addItem(CartItem(id: '1', name: 'A', price: 10.0, quantity: 1));
      cart.resetCart();
      expect(cart.items, isEmpty);
      expect(cart.totalCost, 0.0);
    });
  });

  group('LoginPage widget', () {
    testWidgets('shows email and password fields and Sign In button',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: LoginPage(
                onLogIn: (_) async {},
              ),
            ),
          );

          expect(find.text('CinemaScope'), findsOneWidget);
          expect(find.widgetWithText(TextField, 'Email'), findsOneWidget);
          expect(find.widgetWithText(TextField, 'Password'), findsOneWidget);
          expect(find.text('Sign In'), findsOneWidget);
        });

    testWidgets('shows error when fields are empty and Sign In tapped',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: LoginPage(
                onLogIn: (_) async {},
              ),
            ),
          );

          await tester.tap(find.text('Sign In'));
          await tester.pump();

          expect(
            find.text('Please enter your email and password.'),
            findsOneWidget,
          );
        });

    testWidgets('calls onLogIn with correct credentials',
            (WidgetTester tester) async {
          Credentials? captured;

          await tester.pumpWidget(
            MaterialApp(
              home: LoginPage(
                onLogIn: (creds) async {
                  captured = creds;
                },
              ),
            ),
          );

          await tester.enterText(
              find.widgetWithText(TextField, 'Email'), 'test@example.com');
          await tester.enterText(
              find.widgetWithText(TextField, 'Password'), 'secret123');
          await tester.tap(find.text('Sign In'));
          await tester.pump();

          expect(captured, isNotNull);
          expect(captured!.username, 'test@example.com');
          expect(captured!.password, 'secret123');
        });
  });

  group('Golden tests', () {
    testWidgets('LoginForm matches golden snapshot', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 600));

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorSchemeSeed: Colors.deepPurple,
            useMaterial3: true,
          ),
          home: LoginPage(
            onLogIn: (_) async {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      await expectLater(
        find.byType(LoginPage),
        matchesGoldenFile('goldens/login_page.png'),
      );

      addTearDown(() => tester.binding.setSurfaceSize(null));
    });
  });
}