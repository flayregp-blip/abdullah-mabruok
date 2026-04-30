import 'package:flutter/material.dart';

class DoubleTapDetector extends StatefulWidget {
  const DoubleTapDetector({
    super.key,
    required Widget child,
    required GestureTapDownCallback onDoubleTap,
    this.onTap,
  })  : _child = child,
        _onDoubleTap = onDoubleTap;

  final Widget _child;
  final GestureTapDownCallback _onDoubleTap;
  final VoidCallback? onTap;

  @override
  State<DoubleTapDetector> createState() => _DoubleTapDetectorState();
}

class _DoubleTapDetectorState extends State<DoubleTapDetector> {
  TapDownDetails? _tapDownDetails;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onDoubleTapCancel: () => _tapDownDetails = null,
      onDoubleTapDown: (details) => _tapDownDetails = details,
      onDoubleTap: () {
        if (_tapDownDetails == null) return;
        widget._onDoubleTap(_tapDownDetails!);
      },
      child: widget._child,
    );
  }
}
