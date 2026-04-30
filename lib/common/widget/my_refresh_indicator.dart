import 'package:flutter/material.dart';
import 'package:shortzz/utilities/theme_res.dart';

class MyRefreshIndicator extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;
  final bool shouldRefresh;
  final int depth;
  final GlobalKey? refreshKey;

  const MyRefreshIndicator(
      {super.key,
      required this.onRefresh,
      required this.child,
      this.shouldRefresh = true,
      this.depth = 0,
      this.refreshKey});

  @override
  Widget build(BuildContext context) {
    if (shouldRefresh) {
      return RefreshIndicator(
        key: refreshKey,
        onRefresh: onRefresh,
        notificationPredicate: (notification) {
          return notification.depth == depth;
        },
        color: themeAccentSolid(context),
        backgroundColor: whitePure(context),
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        child: child,
      );
    } else {
      return child;
    }
  }
}
