import 'package:flutter/widgets.dart';

class DragToCartAnimationOptions {
  /// What Should the given widget's jump duration on jump
  final Duration duration;

  /// Should the given widget rotate while dragging to the cart
  final bool isScalable;

  /// What Should the given widget's curve while jump to the cart
  final Curve curve;

  const DragToCartAnimationOptions({
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.decelerate,
    this.isScalable = true,
  });
}
