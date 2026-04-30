import 'package:flutter/material.dart';

import 'add_to_cart_icon.dart';
import 'drag_to_cart_animation_options.dart';
import 'globalkeyext.dart';
import 'jump_animation_options.dart';

export 'add_to_cart_icon.dart';
export 'drag_to_cart_animation_options.dart';
export 'jump_animation_options.dart';

class _PositionedAnimationModel {
  bool showAnimation = false;
  bool animationActive = false;
  Offset imageSourcePoint = Offset.zero;
  Offset imageDestPoint = Offset.zero;
  Size imageSourceSize = Size.zero;
  Size imageDestSize = Size.zero;
  bool rotation = false;
  double opacity = 0.85;
  late SizedBox container;
  double scale = 1.0; // 🔹 ADD THIS
  Curve scaleCurve = Curves.linear;
  bool bouncePhase = false;
  Duration duration = Duration.zero;
  Curve curve = Curves.easeIn;
}

/// An add to cart animation which provide you an animation by sliding the product to cart in the Flutter app
class AddToCartAnimation extends StatefulWidget {
  final Widget child;

  /// The Global Key of the [AddToCartIcon] element. We need it because we need to know where is the cart icon is located in the screen. Based on the location, we are dragging given widget to the cart.
  final GlobalKey<CartIconKey> cartKey;

  /// you can receive [runAddToCartAnimation] animation method on [createAddToCartAnimation].
  /// [runAddToCartAnimation] animation method runs the add to cart animation based on the given parameters.
  /// Add to cart animation drags the given widget to the cart based on their location via global keys
  final Function(Future<void> Function(GlobalKey)) createAddToCartAnimation;

  /// What Should the given widget's height while dragging to the cart
  final double height;

  /// What Should the given widget's width while dragging to the cart
  final double width;

  /// What Should the given widget's opacity while dragging to the cart
  final double opacity;

  /// Should the given widget jump before the dragging
  final JumpAnimationOptions jumpAnimation;

  /// The animation options while given widget sliding to cart
  final DragToCartAnimationOptions dragAnimation;

  const AddToCartAnimation({
    super.key,
    required this.child,
    required this.cartKey,
    required this.createAddToCartAnimation,
    this.height = 30,
    this.width = 30,
    this.opacity = 1,
    this.jumpAnimation = const JumpAnimationOptions(),
    this.dragAnimation = const DragToCartAnimationOptions(),
  });

  @override
  State<AddToCartAnimation> createState() => _AddToCartAnimationState();
}

class _AddToCartAnimationState extends State<AddToCartAnimation> {
  List<_PositionedAnimationModel> animationModels = [];

  @override
  void initState() {
    widget.createAddToCartAnimation(runAddToCartAnimation);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: Stack(
            children: animationModels.map<Widget>((model) {
              if (model.showAnimation) {
                return AnimatedPositioned(
                  top: model.animationActive
                      ? model.imageDestPoint.dx + 9
                      : model.imageSourcePoint.dx,
                  left: model.animationActive
                      ? model.imageDestPoint.dy + 5
                      : model.imageSourcePoint.dy,
                  duration: model.duration,
                  curve: model.curve,
                  child: model.rotation
                      ? TweenAnimationBuilder(
                          tween: Tween<double>(
                              begin: 1.0, // Start at full size
                              end: model.scale // 🔹 animate scale
                              ),
                          duration: model.duration,
                          child: model.container,
                          builder: (context, double value, widget) {
                            return Transform.scale(
                                scale: value,
                                child: AnimatedOpacity(
                                    opacity: model.opacity,
                                    duration: const Duration(milliseconds: 500),
                                    child: widget));
                          },
                        )
                      : AnimatedOpacity(
                          opacity: model.opacity,
                          duration: const Duration(milliseconds: 500),
                          child: model.container),
                );
              } else {
                return const SizedBox();
              }
            }).toList(),
          ),
        ),
      ],
    );
  }

  Future<void> runAddToCartAnimation(GlobalKey widgetKey) async {
    _PositionedAnimationModel animationModel = _PositionedAnimationModel()
      ..rotation = false
      ..opacity = widget.opacity
      ..scale = 1.0
      ..duration = widget.dragAnimation.duration;
    // Start full size

    // Step 1: Get current widget position
    Rect? widgetBounds = widgetKey.globalPaintBounds;
    if (widgetBounds == null) return;

    int topMargin = 40;
    int leftMargin = 25;
    animationModel.imageSourcePoint =
        Offset(widgetBounds.top - topMargin, widgetBounds.left + leftMargin);

    animationModel.container =
        SizedBox(child: (widgetKey.currentWidget! as Container).child);

    animationModel.showAnimation = true;
    animationModels.add(animationModel);
    setState(() {});

    await Future.delayed(const Duration(milliseconds: 75));

    // Step 2: Jump animation (move slightly up)
    animationModel
      ..imageDestPoint =
          Offset(widgetBounds.top - 80, widgetBounds.left + leftMargin)
      ..curve = widget.jumpAnimation.curve
      ..duration = widget.jumpAnimation.duration
      ..animationActive = true;
    setState(() {});
    await Future.delayed(animationModel.duration);

    // Step 3: Drag to cart
    animationModel
      ..curve = widget.dragAnimation.curve
      ..rotation = widget.dragAnimation.isScalable
      ..duration = widget.dragAnimation.duration
      ..imageDestPoint = Offset(
        widget.cartKey.globalPaintBounds!.top - 85,
        widget.cartKey.globalPaintBounds!.left - 0,
      );
    setState(() {});
    await Future.delayed(animationModel.duration);

    // Fade + shrink
    animationModel
      ..opacity = 0.0
      ..scale = 0.0
      ..bouncePhase = false
      ..scaleCurve = Curves.easeIn
      ..duration = const Duration(milliseconds: 400);
    setState(() {});
    await Future.delayed(animationModel.duration);

    // Step 5: Hide
    animationModel.showAnimation = false;
    animationModel.animationActive = false;
    setState(() {});
  }
}
