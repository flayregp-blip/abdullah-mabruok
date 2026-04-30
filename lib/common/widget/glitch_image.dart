import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shortzz/common/manager/logger.dart';

class GlitchImage extends StatefulWidget {
  final String imageUrl;
  final BoxFit fit;
  final double width;
  final double height;
  final VoidCallback onCompletion;

  const GlitchImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    required this.width,
    required this.height,
    required this.onCompletion,
  });

  @override
  State<GlitchImage> createState() => _GlitchImageState();
}

class _GlitchImageState extends State<GlitchImage>
    with SingleTickerProviderStateMixin {
  final _random = Random();
  List<Offset> _offsets = [];
  bool _showGlitch = true;
  Timer? _timer;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _offsets = _generateOffsets();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() {
        if (_showGlitch) {
          setState(() {
            _offsets = _generateOffsets();
          });
        }
      });

    _startGlitchTimer();
  }

  void _startGlitchTimer() async {
    // Delay glitch start
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _showGlitch = true;
      });
      _controller.repeat();

      // Stop glitch
      Future.delayed(const Duration(milliseconds: 600), () {
        _controller.stop();
        setState(() {
          _showGlitch = false;
          widget.onCompletion();
        });
      });
    });
  }

  List<Offset> _generateOffsets() {
    return List.generate(2, (_) {
      double dx = (_random.nextDouble() - 0.5) * 2.5;
      double dy = (_random.nextDouble() - 0.5) * 2.5;
      return Offset(dx, dy);
    });
  }

  @override
  void dispose() {
    Loggers.info('Glitch Dispose');
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Widget _buildLayer({required Offset offset, required Color color}) {
    return Positioned(
      left: offset.dx,
      top: offset.dy,
      child: Image.asset(
        widget.imageUrl,
        width: widget.width,
        height: widget.height,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: [
          if (_showGlitch) _buildLayer(offset: _offsets[0], color: Colors.red),
          if (_showGlitch) _buildLayer(offset: _offsets[1], color: Colors.blue),
          Positioned(
            left: 0,
            top: 0,
            child: Image.asset(
              widget.imageUrl,
              width: widget.width,
              height: widget.height,
            ),
          ),
        ],
      ),
    );
  }
}
