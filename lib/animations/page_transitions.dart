import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Shared transition durations for route animations.
const kPageTransitionDuration = Duration(milliseconds: 400);
const kPageTransitionCurve = Curves.easeOutCubic;

/// Fade + horizontal slide (default forward navigation).
CustomTransitionPage<T> fadeSlidePage<T>({
  required LocalKey key,
  required Widget child,
  Axis axis = Axis.horizontal,
  bool reverse = false,
}) {
  return CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: kPageTransitionDuration,
    reverseTransitionDuration: kPageTransitionDuration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final begin = reverse
          ? Offset.zero
          : Offset(axis == Axis.horizontal ? 0.08 : 0, axis == Axis.vertical ? 0.08 : 0);
      final end = reverse
          ? Offset(axis == Axis.horizontal ? -0.08 : 0, axis == Axis.vertical ? -0.08 : 0)
          : Offset.zero;
      final slide = Tween<Offset>(begin: begin, end: end).animate(
        CurvedAnimation(parent: animation, curve: kPageTransitionCurve),
      );
      return SlideTransition(
        position: slide,
        child: FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: child,
        ),
      );
    },
  );
}

/// Scale-up fade (auth / modal-style routes).
CustomTransitionPage<T> scaleFadePage<T>({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 350),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final scale = Tween<double>(begin: 0.92, end: 1.0).animate(
        CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
      );
      return ScaleTransition(
        scale: scale,
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    },
  );
}

/// Vertical slide (detail / cinema pages).
CustomTransitionPage<T> slideUpPage<T>({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: kPageTransitionDuration,
    reverseTransitionDuration: kPageTransitionDuration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final slide = Tween<Offset>(
        begin: const Offset(0, 0.12),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: kPageTransitionCurve));
      return SlideTransition(
        position: slide,
        child: FadeTransition(opacity: animation, child: child),
      );
    },
  );
}

/// Material [PageRoute] with slide transition (Navigator.push).
Route<T> slidePageRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: kPageTransitionDuration,
    reverseTransitionDuration: kPageTransitionDuration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final slide = Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: kPageTransitionCurve));
      return SlideTransition(
        position: slide,
        child: FadeTransition(opacity: animation, child: child),
      );
    },
  );
}
