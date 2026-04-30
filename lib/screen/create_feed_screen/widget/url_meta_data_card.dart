import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shortzz/common/service/url_extractor/parsers/base_parser.dart';
import 'package:shortzz/screen/create_feed_screen/create_feed_screen_controller.dart';
import 'package:shortzz/screen/post_screen/widget/url_card.dart';

class UrlMetaDataCard extends StatefulWidget {
  final CreateFeedScreenController controller;

  const UrlMetaDataCard({super.key, required this.controller});

  @override
  State<UrlMetaDataCard> createState() => _UrlMetaDataCardState();
}

class _UrlMetaDataCardState extends State<UrlMetaDataCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  UrlMetadata? previousMetadata;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.8, end: 1.05)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1.05, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 60,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _playForwardAnimation() {
    if (mounted && _controller.status != AnimationStatus.forward) {
      _controller.reset();
      _controller.forward();
    }
  }

  void _playReverseAnimation() {
    if (mounted && _controller.status != AnimationStatus.reverse) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final metadata = widget.controller.commentHelper.metaData.value;

      // Animation trigger logic
      if (metadata != previousMetadata) {
        if (metadata != null) {
          _playForwardAnimation();
        } else {
          _playReverseAnimation();
        }
        previousMetadata = metadata;
      }

      // Hide completely if metadata is null and animation is finished
      if (metadata == null || _controller.isDismissed) {
        return const SizedBox();
      }

      return ScaleTransition(
        scale: _scaleAnimation,
        child: UrlCard(
          metadata: metadata,
          margin: const EdgeInsets.all(15),
          onDelete: widget.controller.commentHelper.onClosePreview,
        ),
      );
    });
  }
}
