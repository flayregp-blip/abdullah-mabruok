import 'package:flutter/material.dart';

class CustomShimmerFillText extends StatefulWidget {
  final String text;
  final TextStyle textStyle;
  final Color shimmerColor;
  final Color baseColor;
  final Color finalColor;
  final Duration duration;

  const CustomShimmerFillText({
    super.key,
    required this.text,
    required this.textStyle,
    this.shimmerColor = Colors.white,
    this.baseColor = Colors.grey,
    this.finalColor = Colors.blue,
    this.duration = const Duration(seconds: 4),
  });

  @override
  State<CustomShimmerFillText> createState() => _CustomShimmerFillTextState();
}

class _CustomShimmerFillTextState extends State<CustomShimmerFillText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool animationEnded = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            animationEnded = true;
          });
        }
      });

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return animationEnded
        ? Text(
            widget.text,
            style: widget.textStyle.copyWith(color: widget.finalColor),
          )
        : AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: const [0.0, 0.5, 1.0],
                    colors: [
                      widget.baseColor,
                      widget.shimmerColor,
                      widget.baseColor,
                    ],
                    transform: _SlidingGradientTransform(
                        slidePercent: _animation.value),
                  ).createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                  );
                },
                blendMode: BlendMode.srcIn,
                child: Text(
                  widget.text,
                  style: widget.textStyle,
                ),
              );
            },
          );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;

  const _SlidingGradientTransform({required this.slidePercent});

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}
