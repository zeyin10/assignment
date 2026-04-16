import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'constants.dart';
import '../screens/screens.dart';
import '../models/models.dart';
import 'home.dart';

void main() {
  runApp(const CinemaScope());
}

/// Allows the ability to scroll by dragging with touch, mouse, and trackpad.
class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad
      };
}

class CinemaScope extends StatefulWidget {
  const CinemaScope({super.key});

  @override
  State<CinemaScope> createState() => _CinemaScopeState();
}

class _CinemaScopeState extends State<CinemaScope> {
  ThemeMode themeMode = ThemeMode.light;
  ColorSelection colorSelected = ColorSelection.deepPurple;

  /// Authentication to manage user login session
  final CinemaScopeAuth _auth = CinemaScopeAuth();

  /// Manage user's ticket cart for the movies they want to book.
  final CartManager _cartManager = CartManager();

  /// Manage user's orders submitted
  final OrderManager _orderManager = OrderManager();

  late final _router = GoRouter(
    initialLocation: '/login',
    refreshListenable: _auth,
    redirect: _appRedirect,
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) =>
          LoginPage(
              onLogIn: (Credentials credentials) async {
            _auth.signIn(credentials.username, credentials.password);
          })),
      GoRoute(
          path: '/:tab',
          builder: (context, state) {
            return Home(
              auth: _auth,
              cartManager: _cartManager,
              ordersManager: _orderManager,
              changeTheme: changeThemeMode,
              changeColor: changeColor,
              colorSelected: colorSelected,
              tab: int.tryParse(
                state.pathParameters['tab'] ?? '') ?? 0);
          },
          routes: [
            GoRoute(
                path: 'cinema/:id',
                builder: (context, state) {
                  final id =
                      int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
                  final cinema = cinemas[id];
                  return CinemaPage(
                    cinema: cinema,
                    cartManager: _cartManager,
                    ordersManager: _orderManager,
                  );
                }),
          ]),
    ],
    errorPageBuilder: (context, state) {
      return MaterialPage(
        key: state.pageKey,
        child: Scaffold(
          body: Center(
            child: Text(
              state.error.toString(),
            ),
          ),
        ),
      );
    },
  );

  Future<String?> _appRedirect(
      BuildContext context, GoRouterState state) async {
    final loggedIn = await _auth.loggedIn;
    final isOnLoginPage = state.matchedLocation == '/login';

    // Go to /login if the user is not signed in
    if (!loggedIn) {
      return '/login';
    }
    // Go to root of app / if the user is already signed in
    else if (loggedIn && isOnLoginPage) {
      return '/${CinemaScopeTab.home.value}';
    }

    // no redirect
    return null;
  }

  void changeThemeMode(bool useLightMode) {
    setState(() {
      themeMode = useLightMode
          ? ThemeMode.light //
          : ThemeMode.dark;
    });
  }

  void changeColor(int value) {
    setState(() {
      colorSelected = ColorSelection.values[value];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      scrollBehavior: CustomScrollBehavior(),
      themeMode: themeMode,
      theme: ThemeData(
        colorSchemeSeed: colorSelected.color,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: colorSelected.color,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
    );
  }
}
