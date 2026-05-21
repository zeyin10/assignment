import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'constants.dart';
import 'home.dart';
import 'screens/screens.dart';
import 'models/models.dart';
import 'firebase/local_database.dart';
import 'firebase/database_connection.dart';
import 'repositories/auth_repository.dart';
import 'repositories/favorites_repository.dart';
import 'repositories/chat_repository.dart';
import 'animations/animations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final db = AppDatabase(await openConnection());
  runApp(CinemaScope(db: db));
}

class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}

class CinemaScope extends StatefulWidget {
  const CinemaScope({super.key, required this.db});
  final AppDatabase db;

  @override
  State<CinemaScope> createState() => _CinemaScopeState();
}

class _CinemaScopeState extends State<CinemaScope> {
  ThemeMode themeMode = ThemeMode.light;
  ColorSelection colorSelected = ColorSelection.deepPurple;

  late final _authRepo = AuthRepository();
  late final _favRepo  = FavoritesRepository(db: widget.db);
  final _chatRepo      = ChatRepository();
  final _cartManager   = CartManager();
  final _orderManager  = OrderManager();

  @override
  void initState() {
    super.initState();
    // Listen to auth changes — when user logs in, init favorites with their uid
    _authRepo.addListener(_onAuthChanged);
  }

  void _onAuthChanged() {
    final uid = _authRepo.currentUser?.uid;
    if (uid != null) {
      _favRepo.setCurrentUser(uid);
      _favRepo.init(uid);
    } else {
      _favRepo.setCurrentUser(null);
    }
  }

  @override
  void dispose() {
    _authRepo.removeListener(_onAuthChanged);
    super.dispose();
  }

  late final _router = GoRouter(
    initialLocation: '/login',
    refreshListenable: _authRepo,
    redirect: _appRedirect,
    routes: [
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => scaleFadePage(
          key: state.pageKey,
          child: LoginPage(
            onLogIn: (Credentials credentials) async {
              await _authRepo.signIn(
                email: credentials.username,
                password: credentials.password,
              );
            },
          ),
        ),
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) => fadeSlidePage(
          key: state.pageKey,
          child: RegisterPage(
            authRepository: _authRepo,
            onNavigateToLogin: () => context.go('/login'),
          ),
        ),
      ),
      GoRoute(
        path: '/:tab',
        pageBuilder: (context, state) => fadeSlidePage(
          key: state.pageKey,
          child: Home(
            authRepository: _authRepo,
            cartManager: _cartManager,
            ordersManager: _orderManager,
            favoritesRepository: _favRepo,
            chatRepository: _chatRepo,
            changeTheme: changeThemeMode,
            changeColor: changeColor,
            colorSelected: colorSelected,
            tab: int.tryParse(state.pathParameters['tab'] ?? '') ?? 0,
          ),
        ),
        routes: [
          GoRoute(
            path: 'cinema/:id',
            pageBuilder: (context, state) {
              final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
              final cinema = cinemas[id];
              return slideUpPage(
                key: state.pageKey,
                child: CinemaPage(
                  cinema: cinema,
                  cartManager: _cartManager,
                  ordersManager: _orderManager,
                  favoriteManager: _favRepo,
                ),
              );
            },
          ),
          GoRoute(
            path: 'room/:roomId',
            pageBuilder: (context, state) {
              final roomId = state.pathParameters['roomId'] ?? '';
              final title = state.uri.queryParameters['title'] ?? 'Chat';
              return fadeSlidePage(
                key: state.pageKey,
                child: ChatRoomPage(
                  roomId: roomId,
                  roomTitle: title,
                  chatRepository: _chatRepo,
                  currentUser: _authRepo.currentUser!,
                ),
              );
            },
          ),
        ],
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: Scaffold(body: Center(child: Text(state.error.toString()))),
    ),
  );

  String? _appRedirect(BuildContext context, GoRouterState state) {
    final loggedIn = _authRepo.isLoggedIn;
    final location = state.matchedLocation;

    if (!loggedIn && location != '/login' && location != '/register') {
      return '/login';
    }
    if (loggedIn && (location == '/login' || location == '/register')) {
      return '/${CinemaScopeTab.home.value}';
    }
    return null;
  }

  void changeThemeMode(bool useLightMode) {
    setState(() => themeMode = useLightMode ? ThemeMode.light : ThemeMode.dark);
  }

  void changeColor(int value) {
    setState(() => colorSelected = ColorSelection.values[value]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.authStateChanges().first,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return MaterialApp(
            home: Scaffold(
              body: CinemaScopeLoader(
                message: 'Starting CinemaScope…',
                useLottie: true,
              ),
            ),
          );
        }
        return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: _authRepo),
            ChangeNotifierProvider.value(value: _favRepo),
            Provider.value(value: _chatRepo),
          ],
          child: MaterialApp.router(
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
          ),
        );
      },
    );
  }
}