import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'constants.dart';
import 'components/components.dart';
import 'models/models.dart';
import 'screens/screens.dart';
import 'repositories/auth_repository.dart';
import 'repositories/favorites_repository.dart';
import 'repositories/chat_repository.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
    required this.authRepository,
    required this.cartManager,
    required this.ordersManager,
    required this.favoritesRepository,
    required this.chatRepository,
    required this.changeTheme,
    required this.changeColor,
    required this.colorSelected,
    required this.tab,
  });

  final AuthRepository authRepository;
  final FavoritesRepository favoritesRepository;
  final ChatRepository chatRepository;
  final int tab;
  final CartManager cartManager;
  final OrderManager ordersManager;
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
    widget.favoritesRepository.addListener(_refresh);
    widget.authRepository.addListener(_refresh);
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.favoritesRepository.removeListener(_refresh);
    widget.authRepository.removeListener(_refresh);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final favCount = widget.favoritesRepository.count;
    final appUser = widget.authRepository.currentUser;

    final fullName = appUser?.displayName ?? '';
    final nameParts = fullName.trim().split(RegExp(r'\s+'));
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName =
    nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

    final pages = [
      ExplorePage(
        cartManager:     widget.cartManager,
        orderManager:    widget.ordersManager,
        favoriteManager: widget.favoritesRepository,
      ),
      MyOrdersPage(orderManager: widget.ordersManager),
      ChatListPage(
        chatRepository: widget.chatRepository,
        authRepository: widget.authRepository,
      ),
      AccountPage(
        onLogOut: (logout) async {
          await widget.authRepository.signOut();
        },
        favoriteManager: widget.favoritesRepository,
        user: User(
          firstName:       firstName,
          lastName:        lastName,
          role:            'Cinema Enthusiast',
          profileImageUrl: 'assets/profile_pics/person_kevin.jpeg',
          points:          appUser?.points ?? 0,
          darkMode:        true,
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
            changeColor:   widget.changeColor,
            colorSelected: widget.colorSelected,
          ),
        ],
      ),
      body: IndexedStack(index: widget.tab, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.tab,
        animationDuration: const Duration(milliseconds: 400),
        onDestinationSelected: (index) => context.go('/$index'),
        destinations: [
          const NavigationDestination(
            icon:         Icon(Icons.movie_outlined),
            label:        'Discover',
            selectedIcon: Icon(Icons.movie),
          ),
          const NavigationDestination(
            icon:         Icon(Icons.confirmation_number_outlined),
            label:        'My Tickets',
            selectedIcon: Icon(Icons.confirmation_number),
          ),
          const NavigationDestination(
            icon:         Icon(Icons.chat_bubble_outline),
            label:        'Chat',
            selectedIcon: Icon(Icons.chat_bubble),
          ),
          NavigationDestination(
            icon: favCount > 0
                ? Badge(
                label: Text('$favCount'),
                child: const Icon(Icons.person_2_outlined))
                : const Icon(Icons.person_2_outlined),
            label: 'Account',
            selectedIcon: favCount > 0
                ? Badge(
                label: Text('$favCount'),
                child: const Icon(Icons.person))
                : const Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}