import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BreathingBubble extends StatefulWidget {
  final double size;
  final Color bubbleColor;
  final Color textColor;
  final Duration breathDuration;
  final int totalBreaths;

  const BreathingBubble({
    Key? key,
    this.size = 200,
    this.bubbleColor = Colors.blue,
    this.textColor = Colors.white,
    this.breathDuration = const Duration(seconds: 4),
    this.totalBreaths = 10,
  }) : super(key: key);

  @override
  State<BreathingBubble> createState() => _BreathingBubbleState();
}

class _BreathingBubbleState extends State<BreathingBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String _breathText = 'Inhale';
  bool _isPlaying = true;
  int _currentBreath = 0;
  late int _remainingTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.totalBreaths * widget.breathDuration.inSeconds;
    
    _controller = AnimationController(
      duration: widget.breathDuration,
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.addListener(() {
      if (_controller.value < 0.5) {
        setState(() {
          _breathText = 'Exhale';
        });
        HapticFeedback.lightImpact();
      } else {
        setState(() {
          _breathText = 'Inhale';
        });
        HapticFeedback.mediumImpact();
      }

      // Track breaths
      if (_controller.value == 0.0) {
        setState(() {
          _currentBreath++;
          if (_currentBreath >= widget.totalBreaths) {
            _completeSession();
          }
        });
      }
    });

    // Start timer
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isPlaying) {
        setState(() {
          if (_remainingTime > 0) {
            _remainingTime--;
          } else {
            _completeSession();
          }
        });
      }
    });
  }

  void _completeSession() {
    _timer?.cancel();
    _controller.stop();
    setState(() {
      _isPlaying = false;
    });
    // Show completion dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blue.shade900,
        title: const Text(
          'Session Complete!',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'You\'ve completed ${widget.totalBreaths} breaths.',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Return to previous screen
            },
            child: const Text(
              'Done',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _controller.repeat(reverse: true);
        _startTimer(); // Restart timer when resuming
      } else {
        _controller.stop();
        _timer?.cancel(); // Pause timer when pausing
      }
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _animation.value,
                    child: Container(
                      width: widget.size,
                      height: widget.size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.bubbleColor.withOpacity(0.3),
                        border: Border.all(
                          color: widget.bubbleColor,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _breathText,
                          style: TextStyle(
                            color: widget.textColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                bottom: -40,
                child: Text(
                  '${_currentBreath}/${widget.totalBreaths} breaths',
                  style: TextStyle(
                    color: widget.textColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),
          Text(
            _formatTime(_remainingTime),
            style: TextStyle(
              color: widget.textColor,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _togglePlayPause,
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.bubbleColor,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              _isPlaying ? 'Pause' : 'Resume',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 