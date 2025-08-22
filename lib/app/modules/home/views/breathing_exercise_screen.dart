import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import '../../../widgets/interactive_feedback.dart';

class BreathingExerciseScreen extends StatefulWidget {
  final Map<String, dynamic>? exerciseData;

  const BreathingExerciseScreen({
    Key? key,
    this.exerciseData,
  }) : super(key: key);

  @override
  State<BreathingExerciseScreen> createState() => _BreathingExerciseScreenState();
}

class _BreathingExerciseScreenState extends State<BreathingExerciseScreen>
    with TickerProviderStateMixin {
  late AnimationController _breathingController;
  late AnimationController _pulseController;
  late Animation<double> _breathingAnimation;
  late Animation<double> _pulseAnimation;

  bool _isPlaying = false;
  bool _isCompleted = false;
  int _currentCycle = 0;
  int _totalCycles = 10;
  int _inhaleTime = 4;
  int _holdTime = 4;
  int _exhaleTime = 6;
  String _currentPhase = 'Inhale';
  Timer? _timer;
  int _remainingTime = 0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _remainingTime = _inhaleTime;
  }

  void _initializeAnimations() {
    _breathingController = AnimationController(
      duration: Duration(seconds: _inhaleTime + _holdTime + _exhaleTime),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _breathingAnimation = Tween<double>(
      begin: 0.5,
      end: 1.5,
    ).animate(CurvedAnimation(
      parent: _breathingController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _pulseController.repeat(reverse: true);
  }

  void _startBreathing() {
    HapticFeedbackHelper.mediumImpact();
    setState(() {
      _isPlaying = true;
      _currentCycle = 0;
    });
    _nextBreathingPhase();
  }

  void _nextBreathingPhase() {
    if (_currentCycle >= _totalCycles) {
      _completeExercise();
      return;
    }

    if (_currentPhase == 'Inhale') {
      setState(() {
        _currentPhase = 'Hold';
        _remainingTime = _holdTime;
      });
      _breathingController.forward();
      _timer = Timer(Duration(seconds: _holdTime), _nextBreathingPhase);
    } else if (_currentPhase == 'Hold') {
      setState(() {
        _currentPhase = 'Exhale';
        _remainingTime = _exhaleTime;
      });
      _breathingController.reverse();
      _timer = Timer(Duration(seconds: _exhaleTime), _nextBreathingPhase);
    } else if (_currentPhase == 'Exhale') {
      setState(() {
        _currentPhase = 'Inhale';
        _remainingTime = _inhaleTime;
        _currentCycle++;
      });
      _breathingController.reset();
      _timer = Timer(Duration(seconds: _inhaleTime), _nextBreathingPhase);
    }
  }

  void _pauseBreathing() {
    setState(() {
      _isPlaying = false;
    });
    _timer?.cancel();
    _breathingController.stop();
  }

  void _completeExercise() {
    setState(() {
      _isPlaying = false;
      _isCompleted = true;
    });
    _timer?.cancel();
    _pulseController.stop();
  }

  void _resetExercise() {
    setState(() {
      _isPlaying = false;
      _isCompleted = false;
      _currentCycle = 0;
      _currentPhase = 'Inhale';
      _remainingTime = _inhaleTime;
    });
    _timer?.cancel();
    _breathingController.reset();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _pulseController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B4B6F),
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  Expanded(
                    child: Text(
                      'Breathing Exercise',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // TODO: Show settings
                    },
                    icon: const Icon(Icons.settings, color: Colors.white),
                  ),
                ],
              ),
            ),

            Expanded(
              child: _isCompleted ? _buildCompletionView() : _buildBreathingView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreathingView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Progress indicator
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cycle ${_currentCycle + 1}/$_totalCycles',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16.sp,
                ),
              ),
              Text(
                '$_remainingTime s',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 40.h),

        // Breathing circle
        AnimatedBuilder(
          animation: Listenable.merge([_breathingAnimation, _pulseAnimation]),
          builder: (context, child) {
            return Transform.scale(
              scale: _isPlaying ? _breathingAnimation.value : _pulseAnimation.value,
              child: Container(
                width: 200.w,
                height: 200.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withOpacity(0.3),
                      Colors.white.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    _currentPhase,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        SizedBox(height: 40.h),

        // Instructions
        Text(
          _getInstructionText(),
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16.sp,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 60.h),

        // Control buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (!_isPlaying)
              ElevatedButton(
                onPressed: _startBreathing,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF1B4B6F),
                  padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Start',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
              ),
            if (_isPlaying)
              ElevatedButton(
                onPressed: _pauseBreathing,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Pause',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
              ),
            ElevatedButton(
              onPressed: _resetExercise,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: const BorderSide(color: Colors.white),
                ),
              ),
              child: Text(
                'Reset',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCompletionView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 80.sp,
        ),
        SizedBox(height: 24.h),
        Text(
          'Exercise Complete!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          'You completed $_totalCycles breathing cycles',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(height: 40.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: _resetExercise,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF1B4B6F),
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Do Again',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: const BorderSide(color: Colors.white),
                ),
              ),
              child: Text(
                'Finish',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getInstructionText() {
    switch (_currentPhase) {
      case 'Inhale':
        return 'Breathe in slowly through your nose\nFeel your lungs expand';
      case 'Hold':
        return 'Hold your breath\nFeel the stillness';
      case 'Exhale':
        return 'Breathe out slowly through your mouth\nRelease all tension';
      default:
        return 'Get ready to begin\nFind a comfortable position';
    }
  }
} 