import 'dart:async';

import 'package:flutter/material.dart';

/// return true is refresh success
///
/// return false or null is fail

class LoadMoreWidget extends StatefulWidget {
  final Future<void> Function() loadMore;
  final Widget child;

  const LoadMoreWidget(
      {super.key, required this.loadMore, required this.child});

  @override
  State<LoadMoreWidget> createState() => _LoadMoreWidgetState();
}

class _LoadMoreWidgetState extends State<LoadMoreWidget> {
  bool isLoading = false;
  Timer? _scrollStopTimer;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification &&
            notification.metrics.axis == Axis.vertical) {
          final metrics = notification.metrics;
          // Cancel any existing timer since user is still scrolling
          _scrollStopTimer?.cancel();

          // Check if user has reached near the bottom
          if (metrics.pixels >= metrics.maxScrollExtent / 2) {
            _scrollStopTimer = Timer(const Duration(milliseconds: 250), () {
              if (!isLoading) {
                isLoading = true;
                widget.loadMore().then((_) {
                  isLoading = false;
                  if (mounted) {
                    setState(() {});
                  }
                });
              }
            });
          }
        }
        return false; // Allow other listeners to process the event
      },
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _scrollStopTimer?.cancel();
    super.dispose();
  }
}
