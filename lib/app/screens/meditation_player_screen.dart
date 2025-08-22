import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../data/models/content_model.dart';

class MeditationPlayerScreen extends StatefulWidget {
  final ContentModel content;
  final Function(int)? onSessionComplete;
  
  const MeditationPlayerScreen({
    Key? key,
    required this.content,
    this.onSessionComplete,
  }) : super(key: key);

  @override
  State<MeditationPlayerScreen> createState() => _MeditationPlayerScreenState();
}

class _MeditationPlayerScreenState extends State<MeditationPlayerScreen>
    with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late AnimationController _progressController;
  late Animation<double> _breathingAnimation;
  late Animation<double> _progressAnimation;
  
  bool _isPlaying = false;
  bool _isPaused = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  int _sessionDuration = 0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _totalDuration = Duration(minutes: widget.content.duration);
    _startSession();
  }

  void _initializeAnimations() {
    _breathingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    
    _progressController = AnimationController(
      duration: _totalDuration,
      vsync: this,
    );

    _breathingAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _breathingController,
      curve: Curves.easeInOut,
    ));

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.linear,
    ));

    _breathingController.repeat(reverse: true);
  }

  void _startSession() {
    _play();
  }

  void _play() {
    setState(() {
      _isPlaying = true;
      _isPaused = false;
    });
    
    _progressController.forward();
    _breathingController.repeat(reverse: true);
    
    // Simulate progress
    _progressController.addListener(() {
      if (mounted) {
        setState(() {
          _currentPosition = Duration(
            milliseconds: (_progressController.value * _totalDuration.inMilliseconds).round(),
          );
          _sessionDuration = _currentPosition.inSeconds;
        });
      }
    });
  }

  void _pause() {
    setState(() {
      _isPaused = true;
    });
    
    _progressController.stop();
    _breathingController.stop();
  }

  void _resume() {
    setState(() {
      _isPaused = false;
    });
    
    _progressController.forward();
    _breathingController.repeat(reverse: true);
  }

  void _stop() {
    _progressController.stop();
    _breathingController.stop();
    
    if (widget.onSessionComplete != null) {
      widget.onSessionComplete!(_sessionDuration);
    }
    
    Get.back();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            _buildAppBar(),
            
            // Main Content
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Breathing Circle
                  _buildBreathingCircle(),
                  SizedBox(height: 48.h),
                  
                  // Content Info
                  _buildContentInfo(),
                  SizedBox(height: 48.h),
                  
                  // Progress
                  _buildProgress(),
                  SizedBox(height: 48.h),
                  
                  // Controls
                  _buildControls(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          IconButton(
            onPressed: _stop,
            icon: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.close, color: Colors.white),
            ),
          ),
          const Spacer(),
          Text(
            'Meditation',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          SizedBox(width: 48.w), // Balance the layout
        ],
      ),
    );
  }

  Widget _buildBreathingCircle() {
    return AnimatedBuilder(
      animation: _breathingAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _isPlaying ? _breathingAnimation.value : 1.0,
          child: Container(
            width: 200.w,
            height: 200.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.blue.withOpacity(0.3),
                  Colors.blue.withOpacity(0.1),
                  Colors.transparent,
                ],
              ),
              border: Border.all(
                color: Colors.blue.withOpacity(0.5),
                width: 2,
              ),
            ),
            child: Center(
              child: Icon(
                _isPlaying && !_isPaused ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 48.sp,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContentInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        children: [
          Text(
            widget.content.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            widget.content.subtitle,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProgress() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        children: [
          // Progress Bar
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return Column(
                children: [
                  LinearProgressIndicator(
                    value: _progressAnimation.value,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                    minHeight: 4.h,
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(_currentPosition),
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        _formatDuration(_totalDuration),
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Skip Backward
        IconButton(
          onPressed: () {
            // Skip backward 30 seconds
            final newPosition = _currentPosition - const Duration(seconds: 30);
            if (newPosition.inSeconds >= 0) {
              final progress = newPosition.inMilliseconds / _totalDuration.inMilliseconds;
              _progressController.value = progress;
            }
          },
          icon: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.replay_30,
              color: Colors.white,
              size: 24.sp,
            ),
          ),
        ),
        SizedBox(width: 24.w),
        
        // Play/Pause
        GestureDetector(
          onTap: () {
            if (_isPaused) {
              _resume();
            } else {
              _pause();
            }
          },
          child: Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isPaused ? Icons.play_arrow : Icons.pause,
              color: Colors.white,
              size: 32.sp,
            ),
          ),
        ),
        SizedBox(width: 24.w),
        
        // Skip Forward
        IconButton(
          onPressed: () {
            // Skip forward 30 seconds
            final newPosition = _currentPosition + const Duration(seconds: 30);
            if (newPosition.inSeconds <= _totalDuration.inSeconds) {
              final progress = newPosition.inMilliseconds / _totalDuration.inMilliseconds;
              _progressController.value = progress;
            }
          },
          icon: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.forward_30,
              color: Colors.white,
              size: 24.sp,
            ),
          ),
        ),
      ],
    );
  }
} 