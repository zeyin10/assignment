import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../components/components.dart';
import '../constants.dart';
import '../models/models.dart';
import 'checkout_page.dart';

class CinemaPage extends StatefulWidget {
  final Cinema cinema;
  final CartManager cartManager;
  final OrderManager ordersManager;
  final FavoriteManager favoriteManager;

  const CinemaPage({
    super.key,
    required this.cinema,
    required this.cartManager,
    required this.ordersManager,
    required this.favoriteManager,
  });

  @override
  State<CinemaPage> createState() => _CinemaPageState();
}

class _CinemaPageState extends State<CinemaPage> {
  static const double largeScreenPercentage = 0.9;
  static const double maxWidth = 1000;
  static const desktopThreshold = 700;
  static const double drawerWidth = 375.0;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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

  double _calculateConstrainedWidth(double screenWidth) {
    return (screenWidth > desktopThreshold
        ? screenWidth * largeScreenPercentage
        : screenWidth)
        .clamp(0.0, maxWidth);
  }

  int calculateColumnCount(double screenWidth) {
    return screenWidth > desktopThreshold ? 2 : 1;
  }

  CustomScrollView _buildCustomScrollView() {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(),
        _buildInfoSection(),
        _buildGridViewSection('Now Showing'),
      ],
    );
  }

  SliverAppBar _buildSliverAppBar() {
    final isFavorited = widget.favoriteManager.isFavorite(widget.cinema);
    final colorScheme = Theme.of(context).colorScheme;

    return SliverAppBar(
      pinned: true,
      expandedHeight: 300.0,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: _AnimatedFavoriteButton(
            isFavorited: isFavorited,
            onToggle: () => widget.favoriteManager.toggleFavorite(widget.cinema),
            colorScheme: colorScheme,
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 64.0),
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 30.0),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(16.0),
                    image: DecorationImage(
                      image: AssetImage(widget.cinema.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Positioned(
                  bottom: 0.0,
                  left: 16.0,
                  child: CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.local_movies, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildInfoSection() {
    final textTheme = Theme.of(context).textTheme;
    final cinema = widget.cinema;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(cinema.name, style: textTheme.headlineLarge),
            Text(cinema.address, style: textTheme.bodySmall),
            Text(cinema.getRatingAndDistance(), style: textTheme.bodySmall),
            Text(cinema.attributes, style: textTheme.labelSmall),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(int index) {
    final item = widget.cinema.items[index];
    return InkWell(
      onTap: () => _showBottomSheet(item),
      child: CinemaItem(item: item),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  GridView _buildGridView(int columns) {
    return GridView.builder(
      padding: const EdgeInsets.all(0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 3.5,
        crossAxisCount: columns,
      ),
      itemBuilder: (context, index) => _buildGridItem(index),
      itemCount: widget.cinema.items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  SliverToBoxAdapter _buildGridViewSection(String title) {
    final columns = calculateColumnCount(MediaQuery.of(context).size.width);
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle(title),
            _buildGridView(columns),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(MovieTicket item) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      constraints: const BoxConstraints(maxWidth: 480),
      builder: (context) => ItemDetails(
        item: item,
        cartManager: widget.cartManager,
        quantityUpdated: () {
          setState(() {});
        },
      ),
    );
  }

  Widget _buildEndDrawer() {
    return SizedBox(
      width: drawerWidth,
      child: Drawer(
        child: CheckoutPage(
          cartManager: widget.cartManager,
          didUpdate: () {
            setState(() {});
          },
          onSubmit: (order) {
            widget.ordersManager.addOrder(order);
            context.pop();
            context.go('/${CinemaScopeTab.orders.value}');
          },
        ),
      ),
    );
  }

  void openDrawer() {
    scaffoldKey.currentState!.openEndDrawer();
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: openDrawer,
      tooltip: 'Ticket Cart',
      icon: const Icon(Icons.confirmation_number),
      label: Text('${widget.cartManager.items.length} Tickets in cart'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final constrainedWidth = _calculateConstrainedWidth(screenWidth);

    return Scaffold(
      key: scaffoldKey,
      endDrawer: _buildEndDrawer(),
      floatingActionButton: _buildFloatingActionButton(),
      body: Center(
        child: SizedBox(
          width: constrainedWidth,
          child: _buildCustomScrollView(),
        ),
      ),
    );
  }
}

class _AnimatedFavoriteButton extends StatefulWidget {
  final bool isFavorited;
  final VoidCallback onToggle;
  final ColorScheme colorScheme;

  const _AnimatedFavoriteButton({
    required this.isFavorited,
    required this.onToggle,
    required this.colorScheme,
  });

  @override
  State<_AnimatedFavoriteButton> createState() =>
      _AnimatedFavoriteButtonState();
}

class _AnimatedFavoriteButtonState extends State<_AnimatedFavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _anim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.5), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.5, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, child) => Transform.scale(
        scale: _anim.value,
        child: child,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: widget.colorScheme.surface.withOpacity(0.85),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(
            widget.isFavorited ? Icons.bookmark : Icons.bookmark_border,
            color: widget.isFavorited
                ? widget.colorScheme.primary
                : widget.colorScheme.onSurface,
          ),
          tooltip: widget.isFavorited
              ? 'Remove from favorites'
              : 'Add to favorites',
          onPressed: () {
            _ctrl.forward(from: 0);
            widget.onToggle();
          },
        ),
      ),
    );
  }
}