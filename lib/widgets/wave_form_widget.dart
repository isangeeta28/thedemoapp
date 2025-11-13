import 'package:flutter/material.dart';
import 'dart:math' as math;

class WaveformWidget extends StatefulWidget {
  final bool isRecording;
  final int barCount;
  final Color color;

  const WaveformWidget({
    super.key,
    required this.isRecording,
    this.barCount = 40,
    this.color = Colors.blue,
  });

  @override
  State<WaveformWidget> createState() => _WaveformWidgetState();
}

class _WaveformWidgetState extends State<WaveformWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<double> _heights = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _initializeHeights();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    )..addListener(() {
      if (widget.isRecording) {
        setState(() {
          _updateHeights();
        });
      }
    });

    if (widget.isRecording) {
      _controller.repeat();
    }
  }

  void _initializeHeights() {
    _heights.clear();
    for (int i = 0; i < widget.barCount; i++) {
      _heights.add(_getRandomHeight());
    }
  }

  double _getRandomHeight() {
    return 20.0 + _random.nextDouble() * 60.0;
  }

  void _updateHeights() {
    for (int i = 0; i < _heights.length; i++) {
      if (_random.nextDouble() > 0.7) {
        _heights[i] = _getRandomHeight();
      }
    }
  }

  @override
  void didUpdateWidget(WaveformWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording && !oldWidget.isRecording) {
      _controller.repeat();
    } else if (!widget.isRecording && oldWidget.isRecording) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(widget.barCount, (index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 3,
            height: _heights[index],
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
      ),
    );
  }
}