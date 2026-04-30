import 'package:flutter/material.dart';

class GradientBorder extends StatelessWidget {
  final _GradientPainter _painter;
  final Widget _child;
  final VoidCallback? _callback;
  final VoidCallback? _onDoubleTap;
  final double _radius;

  GradientBorder({
    super.key,
    required double strokeWidth,
    required double radius,
    required Gradient? gradient,
    required Widget child,
    VoidCallback? onDoubleTap,
    VoidCallback? onPressed,
  })  : _painter = _GradientPainter(
            strokeWidth: strokeWidth, radius: radius, gradient: gradient),
        _child = child,
        _callback = onPressed,
        _onDoubleTap = onDoubleTap,
        _radius = radius;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _painter,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _callback,
        onDoubleTap: _onDoubleTap,
        child: InkWell(
          borderRadius: BorderRadius.circular(_radius),
          onTap: _callback,
          child: _child,
        ),
      ),
    );
  }
}

class _GradientPainter extends CustomPainter {
  final double radius;
  final double strokeWidth;
  final Gradient? gradient;

  _GradientPainter(
      {required this.strokeWidth,
      required this.radius,
      required this.gradient});

  @override
  void paint(Canvas canvas, Size size) {
    // Outer rectangle with rounded corners
    Rect outerRect = Offset.zero & size;
    RRect outerRRect = RRect.fromRectAndRadius(
      outerRect,
      Radius.circular(radius),
    );

    // Inner rectangle, smaller by strokeWidth
    Rect innerRect = Rect.fromLTWH(
      strokeWidth,
      strokeWidth,
      size.width - strokeWidth * 2,
      size.height - strokeWidth * 2,
    );
    RRect innerRRect = RRect.fromRectAndRadius(
      innerRect,
      Radius.circular(radius - strokeWidth),
    );

    // Apply gradient shader
    Paint paint = Paint();
    if (gradient != null) {
      paint.shader = gradient!.createShader(outerRect);
    }

    // Create paths for outer and inner rounded rectangles
    Path outerPath = Path()..addRRect(outerRRect);
    Path innerPath = Path()..addRRect(innerRRect);

    // Combine paths to create a "stroke" effect
    Path combinedPath = Path.combine(
      PathOperation.difference,
      outerPath,
      innerPath,
    );

    // Draw the resulting path
    canvas.drawPath(combinedPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;
}
