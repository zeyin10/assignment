import 'package:flutter/material.dart';
import '../models/models.dart';

class CinemaLandscapeCard extends StatefulWidget {
  final Cinema cinema;
  final Function() onTap;

  const CinemaLandscapeCard({
    super.key,
    required this.cinema,
    required this.onTap,
  });

  @override
  State<CinemaLandscapeCard> createState() => _CinemaLandscapeCardState();
}

class _CinemaLandscapeCardState extends State<CinemaLandscapeCard>
    with SingleTickerProviderStateMixin {
  bool _isFavorited = false;
  bool _isHovered = false;

  // --- Animation 3: Card hover lift ---
  late AnimationController _liftCtrl;
  late Animation<double> _elevationAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _liftCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _elevationAnim = Tween<double>(begin: 2, end: 14).animate(
      CurvedAnimation(parent: _liftCtrl, curve: Curves.easeOut),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _liftCtrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _liftCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _liftCtrl.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _liftCtrl.reverse();
      },
      cursor: SystemMouseCursors.click,
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnim.value,
          child: child,
        ),
        child: AnimatedBuilder(
          animation: _elevationAnim,
          builder: (context, child) => Card(
            elevation: _elevationAnim.value,
            child: child,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(8.0)),
                child: AspectRatio(
                    aspectRatio: 2,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(widget.cinema.imageUrl, fit: BoxFit.cover),
                        Positioned(
                          top: 4.0,
                          right: 4.0,
                          child: _AnimatedBookmarkButton(
                            isFavorited: _isFavorited,
                            onToggle: () {
                              setState(() => _isFavorited = !_isFavorited);
                            },
                          ),
                        ),
                      ],
                    )),
              ),
              ListTile(
                title: Text(widget.cinema.name, style: textTheme.titleSmall),
                subtitle: Text(widget.cinema.attributes,
                    maxLines: 1, style: textTheme.bodySmall),
                onTap: widget.onTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bookmark button with a pop animation on press.
class _AnimatedBookmarkButton extends StatefulWidget {
  final bool isFavorited;
  final VoidCallback onToggle;

  const _AnimatedBookmarkButton({
    required this.isFavorited,
    required this.onToggle,
  });

  @override
  State<_AnimatedBookmarkButton> createState() =>
      _AnimatedBookmarkButtonState();
}

class _AnimatedBookmarkButtonState extends State<_AnimatedBookmarkButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _popCtrl;
  late Animation<double> _popAnim;

  @override
  void initState() {
    super.initState();
    _popCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _popAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _popCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _popCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _popAnim,
      builder: (context, child) => Transform.scale(
        scale: _popAnim.value,
        child: child,
      ),
      child: IconButton(
        icon: Icon(
            widget.isFavorited ? Icons.bookmark : Icons.bookmark_border),
        iconSize: 30.0,
        color: Theme.of(context).colorScheme.primary,
        onPressed: () {
          _popCtrl.forward(from: 0);
          widget.onToggle();
        },
      ),
    );
  }
}
