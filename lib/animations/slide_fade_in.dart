import 'dart:async';

import 'package:flutter/material.dart';

/// Staggered slide-up + fade entrance for list / form children.
class SlideFadeIn extends StatefulWidget {
  const SlideFadeIn({
    super.key,
    required this.child,
    this.index = 0,
    this.delayPerIndex = const Duration(milliseconds: 60),
    this.duration = const Duration(milliseconds: 450),
    this.offset = const Offset(0, 0.15),
  });

  final Widget child;
  final int index;
  final Duration delayPerIndex;
  final Duration duration;
  final Offset offset;

  @override
  State<SlideFadeIn> createState() => _SlideFadeInState();
}

class _SlideFadeInState extends State<SlideFadeIn>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  Timer? _startTimer;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: widget.offset, end: Offset.zero).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic),
    );
    final delay = widget.delayPerIndex * widget.index;
    if (delay == Duration.zero) {
      _ctrl.forward();
    } else {
      _startTimer = Timer(delay, () {
        if (mounted) _ctrl.forward();
      });
    }
  }

  @override
  void dispose() {
    _startTimer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}

/// Pop scale animation (bookmark / favorite feedback).
class PopScaleAnimation extends StatefulWidget {
  const PopScaleAnimation({
    super.key,
    required this.child,
    required this.trigger,
    this.peakScale = 1.4,
  });

  final Widget child;
  final int trigger;
  final double peakScale;

  @override
  State<PopScaleAnimation> createState() => _PopScaleAnimationState();
}

class _PopScaleAnimationState extends State<PopScaleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _initAnim();
  }

  void _initAnim() {
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _anim = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: widget.peakScale),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: widget.peakScale, end: 1.0),
        weight: 50,
      ),
    ]).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(PopScaleAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger != oldWidget.trigger) {
      _ctrl.forward(from: 0);
    }
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
      child: widget.child,
    );
  }
}
