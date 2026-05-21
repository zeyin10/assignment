import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Pulsing circular loader with optional label.
class PulseLoadingIndicator extends StatefulWidget {
  const PulseLoadingIndicator({
    super.key,
    this.size = 48,
    this.label,
  });

  final double size;
  final String? label;

  @override
  State<PulseLoadingIndicator> createState() => _PulseLoadingIndicatorState();
}

class _PulseLoadingIndicatorState extends State<PulseLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _pulse,
          builder: (context, child) => Transform.scale(
            scale: _pulse.value,
            child: child,
          ),
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: color,
            ),
          ),
        ),
        if (widget.label != null) ...[
          const SizedBox(height: 16),
          Text(
            widget.label!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ],
    );
  }
}

/// Lottie-based loader (bundled asset).
class LottieLoadingIndicator extends StatelessWidget {
  const LottieLoadingIndicator({
    super.key,
    this.size = 120,
    this.assetPath = 'assets/animations/loading.json',
  });

  final double size;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Lottie.asset(
        assetPath,
        fit: BoxFit.contain,
        repeat: true,
        errorBuilder: (_, __, ___) => PulseLoadingIndicator(size: size * 0.4),
      ),
    );
  }
}

/// Full-screen or inline loading with Lottie + fallback pulse.
class CinemaScopeLoader extends StatelessWidget {
  const CinemaScopeLoader({
    super.key,
    this.message = 'Loading…',
    this.useLottie = true,
    this.compact = false,
  });

  final String message;
  final bool useLottie;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (useLottie && !compact)
            const LottieLoadingIndicator()
          else
            const PulseLoadingIndicator(size: 40),
          const SizedBox(height: 20),
          Text(
            message,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}

/// Shimmer placeholder for list loading states.
class ShimmerBox extends StatefulWidget {
  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme.surfaceContainerHighest;
    final highlight = Theme.of(context).colorScheme.surface;
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(-1.0 + 2 * _ctrl.value, 0),
              end: Alignment(1.0 + 2 * _ctrl.value, 0),
              colors: [base, highlight, base],
            ),
          ),
        );
      },
    );
  }
}
