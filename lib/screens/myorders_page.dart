import 'package:flutter/material.dart';
import '../models/models.dart';

class MyOrdersPage extends StatefulWidget {
  final OrderManager orderManager;
  const MyOrdersPage({super.key, required this.orderManager});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _emptyController;

  @override
  void initState() {
    super.initState();
    _emptyController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _emptyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);
    final orders = widget.orderManager.orders;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('My Tickets', style: textTheme.headlineMedium),
      ),
      body: orders.isEmpty
          ? _buildEmptyState(context)
          : ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return _AnimatedOrderTile(
            order: orders[index],
            index: index,
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Spinning + pulsing film reel graphic
          AnimatedBuilder(
            animation: _emptyController,
            builder: (context, child) {
              final spin = _emptyController.value * 2 * 3.14159;
              final pulse = 0.9 +
                  0.1 *
                      (0.5 +
                          0.5 *
                              (1 - ((_emptyController.value * 2 - 1).abs())));
              return Transform.scale(
                scale: pulse,
                child: Transform.rotate(
                  angle: spin,
                  child: child,
                ),
              );
            },
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primaryContainer,
              ),
              child: Icon(
                Icons.movie_filter_rounded,
                size: 52,
                color: colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No tickets yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Book a movie and your tickets\nwill appear here',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// Each ticket slides in with a staggered delay based on its index
class _AnimatedOrderTile extends StatefulWidget {
  final Order order;
  final int index;
  const _AnimatedOrderTile({required this.order, required this.index});

  @override
  State<_AnimatedOrderTile> createState() => _AnimatedOrderTileState();
}

class _AnimatedOrderTileState extends State<_AnimatedOrderTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0.25, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Stagger: each tile delays by 80ms × its index
    Future.delayed(Duration(milliseconds: widget.index * 80), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slide,
      child: FadeTransition(
        opacity: _fade,
        child: OrderTile(order: widget.order),
      ),
    );
  }
}

class OrderTile extends StatelessWidget {
  final Order order;
  const OrderTile({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: colorScheme.onSurface);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: colorScheme.primaryContainer,
          ),
          child: Icon(
            Icons.local_movies,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text('Booked', style: textTheme.bodyLarge),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(order.getFormattedOrderInfo()),
            Text('Tickets: ${order.items.length}'),
          ],
        ),
      ),
    );
  }
}