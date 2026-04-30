import 'package:flutter/material.dart';

class HighlightWrapper extends StatefulWidget {
  final Widget child;
  final bool highlight;
  final Duration duration;
  final Color highlightColor;

  const HighlightWrapper({
    super.key,
    required this.child,
    this.highlight = false,
    this.duration = const Duration(milliseconds: 500),
    required this.highlightColor,
  });

  @override
  State<HighlightWrapper> createState() => _HighlightWrapperState();
}

class _HighlightWrapperState extends State<HighlightWrapper> {
  bool _showHighlight = false;

  @override
  void initState() {
    Future.delayed(
      const Duration(milliseconds: 200),
      () {
        if (widget.highlight && !_showHighlight) {
          setState(() {
            _showHighlight = true;
          });

          Future.delayed(widget.duration, () {
            if (mounted) {
              setState(() {
                _showHighlight = false;
              });
            }
          });
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: widget.duration,
      curve: Curves.easeInOut,
      foregroundDecoration: BoxDecoration(
        color: _showHighlight ? widget.highlightColor : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: widget.child,
    );
  }
}
