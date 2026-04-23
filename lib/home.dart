import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'constants.dart';
import '../components/components.dart';
import '../models/models.dart';
import '../screens/screens.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
    required this.auth,
    required this.cartManager,
    required this.ordersManager,
    required this.favoriteManager,
    required this.changeTheme,
    required this.changeColor,
    required this.colorSelected,
    required this.tab,
  });

  final CinemaScopeAuth auth;
  final int tab;
  final CartManager cartManager;
  final OrderManager ordersManager;
  final FavoriteManager favoriteManager;
  final ColorSelection colorSelected;
  final void Function(bool useLightMode) changeTheme;
  final void Function(int value) changeColor;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    widget.favoriteManager.addListener(_refresh);
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.favoriteManager.removeListener(_refresh);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final favCount = widget.favoriteManager.count;

    final pages = [
      ExplorePage(
        cartManager: widget.cartManager,
        orderManager: widget.ordersManager,
        favoriteManager: widget.favoriteManager,
      ),
      MyOrdersPage(orderManager: widget.ordersManager),
      AccountPage(
        onLogOut: (logout) async {
          widget.auth.signOut();
        },
        favoriteManager: widget.favoriteManager,
        user: User(
          firstName: 'Zeyin',
          lastName: 'A',
          role: 'Cinema Enthusiast',
          profileImageUrl: 'assets/profile_pics/person_kevin.jpeg',
          points: 250,
          darkMode: true,
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: colorScheme.surface,
        actions: [
          ThemeButton(changeThemeMode: widget.changeTheme),
          ColorButton(
            changeColor: widget.changeColor,
            colorSelected: widget.colorSelected,
          ),
        ],
      ),
      body: IndexedStack(index: widget.tab, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.tab,
        animationDuration: const Duration(milliseconds: 400),
        onDestinationSelected: (index) {
          context.go('/$index');
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.movie_outlined),
            label: 'Discover',
            selectedIcon: Icon(Icons.movie),
          ),
          const NavigationDestination(
            icon: Icon(Icons.confirmation_number_outlined),
            label: 'My Tickets',
            selectedIcon: Icon(Icons.confirmation_number),
          ),
          NavigationDestination(
            icon: favCount > 0
                ? Badge(
              label: Text('$favCount'),
              child: const Icon(Icons.person_2_outlined),
            )
                : const Icon(Icons.person_2_outlined),
            label: 'Account',
            selectedIcon: favCount > 0
                ? Badge(
              label: Text('$favCount'),
              child: const Icon(Icons.person),
            )
                : const Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}