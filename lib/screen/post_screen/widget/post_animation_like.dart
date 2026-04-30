import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shortzz/common/functions/debounce_action.dart';
import 'package:shortzz/common/manager/haptic_manager.dart';
import 'package:shortzz/common/widget/gradient_icon.dart';
import 'package:shortzz/model/post_story/post_model.dart';
import 'package:shortzz/utilities/asset_res.dart';
import 'package:shortzz/utilities/style_res.dart';

class PostAnimationLike extends StatefulWidget {
  const PostAnimationLike(
      {super.key,
      required Offset position,
      required Offset endPosition,
      required Size size,
      double leftRightPosition = 0.0,
      required VoidCallback onLikeCalled,
      required OverlayEntry overlayEntry})
      : _position = position,
        _endPosition = endPosition,
        _leftRightPosition = leftRightPosition,
        _onLikeCalled = onLikeCalled,
        _size = size,
        _overlayEntry = overlayEntry;

  final Offset _position; // Starting point (tap)
  final Offset _endPosition; // End point (like button)
  final Size _size;
  final double _leftRightPosition;
  final OverlayEntry _overlayEntry;
  final VoidCallback _onLikeCalled;

  @override
  State<PostAnimationLike> createState() => _PostAnimationLikeState();
}

class _PostAnimationLikeState extends State<PostAnimationLike>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  double _opacity = 1.0;
  late final Animation<double> _scale;
  late final Animation<double> _rotation;

  late final Tween<Offset> _positionTween;
  late final Animation<Offset> _position;

  @override
  void initState() {
    super.initState();
    HapticManager.shared.light();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));

    _controller.addListener(() {
      if (_controller.isCompleted) {
        _opacity = 0.0;
        setState(() {});
        widget._onLikeCalled.call();
        DebounceAction.shared.call(() {
          widget._overlayEntry.remove();
        }, milliseconds: 100);
      } else {
        setState(() {});
      }
    });

    _scale = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween(begin: 0.0, end: 1.5)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 30),
      TweenSequenceItem(
        tween: Tween(begin: 1.5, end: 0.7)
            .chain(CurveTween(curve: Curves.bounceIn)),
        weight: 100,
      ),
    ]).animate(_controller);

    final random = Random();
    final xAxisValue = random.nextDouble() * 0.5 * (random.nextBool() ? 1 : -1);

    _rotation = _controller.drive(TweenSequence([
      TweenSequenceItem(
          tween: Tween<double>(begin: 0.0, end: xAxisValue), weight: 20),
      TweenSequenceItem(
          tween: Tween<double>(begin: xAxisValue, end: 0.0), weight: 20),
    ]));

    _positionTween = Tween<Offset>(begin: const Offset(0, -50));

    _position = TweenSequence<Offset>([
      TweenSequenceItem(tween: ConstantTween(const Offset(0, -50)), weight: 50),
      TweenSequenceItem(tween: _positionTween, weight: 50),
    ]).animate(_controller);

    _controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final dx = widget._endPosition.dx - widget._position.dx;
    final dy = widget._endPosition.dy - widget._position.dy;

    _positionTween.end = Offset(dx, dy); // 🔁 Move from tap to like
    print(_positionTween.end);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Positioned(
        left: widget._position.dx - widget._leftRightPosition,
        top: widget._position.dy - widget._leftRightPosition,
        child: Transform.translate(
          offset: _position.value,
          child: Transform.scale(
            scale: _scale.value,
            child: Transform.rotate(
              angle: _rotation.value,
              child: AnimatedOpacity(
                opacity: _opacity,
                duration: const Duration(milliseconds: 250),
                child: Heart(
                  width: widget._size.width,
                  height: widget._size.height,
                ),
              ),
            ),
          ),
        ),
      );
}

class Heart extends StatelessWidget {
  const Heart({
    super.key,
    double? width,
    double? height,
  })  : _width = width,
        _height = height;

  final double? _width;
  final double? _height;

  @override
  Widget build(BuildContext context) => GradientIcon(
        gradient: StyleRes.themeGradient,
        child: Image.asset(
          AssetRes.icFillHeart,
          width: _width,
          height: _height,
        ),
      );
}

class PhotoLikeService {
  PhotoLikeService._();

  static final instance = PhotoLikeService._();

  like(TapDownDetails details,
      {required GlobalKey likeKey,
      required BuildContext context,
      required Post post,
      required Size size,
      required double leftRightPosition,
      required Function(Post) onLike}) {
    final RenderBox? box =
        likeKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;

    final Offset likeButtonPosition = box.localToGlobal(Offset.zero);

    late final OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => PostAnimationLike(
        size: size,
        position: details.globalPosition,
        endPosition: likeButtonPosition,
        overlayEntry: entry,
        leftRightPosition: leftRightPosition,
        onLikeCalled: () {
          if (post.isLiked == false) {
            HapticManager.shared.light();
            onLike.call(post);
          }
        },
      ),
    );

    Overlay.of(context).insert(entry);
  }
}
