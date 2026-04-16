import 'package:flutter/material.dart';
import '../models/models.dart';

/// --- Animation 4: Genre cards slide in + fade on first render ---
class GenreCard extends StatefulWidget {
  final MovieGenre genre;
  final int index;

  const GenreCard({
    super.key,
    required this.genre,
    this.index = 0,
  });

  @override
  State<GenreCard> createState() => _GenreCardState();
}

class _GenreCardState extends State<GenreCard>
    with TickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _enterCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  // Hover scale
  late AnimationController _hoverCtrl;
  late Animation<double> _hoverScale;

  @override
  void initState() {
    super.initState();

    // Staggered entrance: each card delays based on its index
    _enterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOut));

    // Delay based on card index for stagger effect
    Future.delayed(Duration(milliseconds: 80 * widget.index), () {
      if (mounted) _enterCtrl.forward();
    });

    _hoverCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _hoverScale = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _hoverCtrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _enterCtrl.dispose();
    _hoverCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: MouseRegion(
          onEnter: (_) {
            setState(() => _isHovered = true);
            _hoverCtrl.forward();
          },
          onExit: (_) {
            setState(() => _isHovered = false);
            _hoverCtrl.reverse();
          },
          child: AnimatedBuilder(
            animation: _hoverScale,
            builder: (context, child) =>
                Transform.scale(scale: _hoverScale.value, child: child),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: _isHovered
                    ? [
                        BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.25),
                          blurRadius: 16,
                          spreadRadius: 2,
                        )
                      ]
                    : [],
              ),
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8.0)),
                          child: Image.asset(genre.imageUrl),
                        ),
                      ],
                    ),
                    ListTile(
                      title:
                          Text(genre.name, style: textTheme.titleSmall),
                      subtitle: Text('${genre.numberOfMovies} movies',
                          style: textTheme.bodySmall),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  MovieGenre get genre => widget.genre;
}
