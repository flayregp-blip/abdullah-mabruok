import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shortzz/common/extensions/string_extension.dart';
import 'package:shortzz/common/widget/custom_image.dart';
import 'package:shortzz/model/user_model/user_model.dart';

class ProfilePreviewInteractiveScreen extends StatefulWidget {
  final User? user;

  const ProfilePreviewInteractiveScreen({super.key, this.user});

  @override
  State<ProfilePreviewInteractiveScreen> createState() =>
      _ProfilePreviewInteractiveScreenState();
}

class _ProfilePreviewInteractiveScreenState
    extends State<ProfilePreviewInteractiveScreen>
    with TickerProviderStateMixin {
  Offset _dragOffset = Offset.zero;

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta;
    });
  }

  void _onDragEnd(DragEndDetails details) {
    final shouldPop = _dragOffset.distance > 120 ||
        (details.primaryVelocity?.abs() ?? 0) > 300;

    if (shouldPop) {
      HapticFeedback.selectionClick();
      Navigator.of(context).pop();
    } else {
      // Animate back to original position
      final controller = AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      );

      final animation = Tween<Offset>(
        begin: _dragOffset,
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

      animation.addListener(() {
        setState(() => _dragOffset = animation.value);
      });

      controller.forward().then((_) {
        controller.dispose();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final dragPercent =
        (_dragOffset.distance / screenSize.shortestSide).clamp(0.0, 1.0);
    final bgOpacity = (1 - dragPercent * 0.7).clamp(0.0, 1.0);
    final scale = (1 - dragPercent * 0.3).clamp(0.85, 1.0);

    return GestureDetector(
      onPanUpdate: _onDragUpdate, // ⬅️ drag any direction
      onPanEnd: _onDragEnd,
      onTap: () => Navigator.pop(context),
      child: Stack(
        children: [
          // Blurred background with opacity
          Opacity(
            opacity: bgOpacity,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(color: Colors.black.withValues(alpha: 0.5)),
            ),
          ),

          // Center content (image with drag, scale, fade)
          Center(
            child: Transform.translate(
              offset: _dragOffset,
              child: Transform.scale(
                scale: scale,
                child: Hero(
                  tag: 'profile-${widget.user?.id}',
                  child: CustomImage(
                    size: const Size(250, 250),
                    image: widget.user?.profilePhoto?.addBaseURL(),
                    fullName: widget.user?.fullname,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
