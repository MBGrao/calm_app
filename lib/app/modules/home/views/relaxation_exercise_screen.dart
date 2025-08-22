import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import '../../../widgets/interactive_feedback.dart';

class RelaxationExerciseScreen extends StatefulWidget {
  final Map<String, dynamic>? exerciseData;

  const RelaxationExerciseScreen({
    Key? key,
    this.exerciseData,
  }) : super(key: key);

  @override
  State<RelaxationExerciseScreen> createState() => _RelaxationExerciseScreenState();
}

class _RelaxationExerciseScreenState extends State<RelaxationExerciseScreen>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _pulseController;
  late Animation<double> _progressAnimation;
  late Animation<double> _pulseAnimation;

  bool _isPlaying = false;
  bool _isCompleted = false;
  int _currentStep = 0;
  int _totalSteps = 8;
  int _stepDuration = 10; // seconds per step
  Timer? _timer;
  int _remainingTime = 0;

  final List<Map<String, dynamic>> _relaxationSteps = [
    {
      'title': 'Face & Head',
      'instruction': 'Tense your facial muscles, then relax completely',
      'bodyPart': 'Face',
      'icon': Icons.face,
    },
    {
      'title': 'Neck & Shoulders',
      'instruction': 'Tense your neck and shoulders, then release',
      'bodyPart': 'Neck',
      'icon': Icons.accessibility_new,
    },
    {
      'title': 'Arms & Hands',
      'instruction': 'Tense your arms and hands, then let go',
      'bodyPart': 'Arms',
      'icon': Icons.pan_tool,
    },
    {
      'title': 'Chest & Back',
      'instruction': 'Tense your chest and back muscles, then relax',
      'bodyPart': 'Chest',
      'icon': Icons.accessibility,
    },
    {
      'title': 'Stomach',
      'instruction': 'Tense your stomach muscles, then release',
      'bodyPart': 'Stomach',
      'icon': Icons.favorite,
    },
    {
      'title': 'Legs',
      'instruction': 'Tense your leg muscles, then let go',
      'bodyPart': 'Legs',
      'icon': Icons.directions_walk,
    },
    {
      'title': 'Feet',
      'instruction': 'Tense your feet and toes, then relax',
      'bodyPart': 'Feet',
      'icon': Icons.sports_soccer,
    },
    {
      'title': 'Full Body',
      'instruction': 'Feel the complete relaxation throughout your body',
      'bodyPart': 'Full Body',
      'icon': Icons.self_improvement,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _remainingTime = _stepDuration;
  }

  void _initializeAnimations() {
    _progressController = AnimationController(
      duration: Duration(seconds: _stepDuration),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _pulseController.repeat(reverse: true);
  }

  void _startRelaxation() {
    HapticFeedbackHelper.mediumImpact();
    setState(() {
      _isPlaying = true;
      _currentStep = 0;
    });
    _nextStep();
  }

  void _nextStep() {
    if (_currentStep >= _totalSteps) {
      _completeExercise();
      return;
    }

    setState(() {
      _remainingTime = _stepDuration;
    });

    _progressController.reset();
    _progressController.forward();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingTime--;
      });

      if (_remainingTime <= 0) {
        timer.cancel();
        setState(() {
          _currentStep++;
        });
        if (_currentStep < _totalSteps) {
          _nextStep();
        } else {
          _completeExercise();
        }
      }
    });
  }

  void _pauseRelaxation() {
    setState(() {
      _isPlaying = false;
    });
    _timer?.cancel();
    _progressController.stop();
  }

  void _resumeRelaxation() {
    setState(() {
      _isPlaying = true;
    });
    _progressController.forward();
    _nextStep();
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
      _currentStep = 0;
      _remainingTime = _stepDuration;
    });
    _timer?.cancel();
    _progressController.reset();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _progressController.dispose();
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
                      'Progressive Muscle Relaxation',
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
              child: _isCompleted ? _buildCompletionView() : _buildRelaxationView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRelaxationView() {
    final currentStepData = _relaxationSteps[_currentStep];

    return Column(
      children: [
        // Progress indicator
        Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Step ${_currentStep + 1}/$_totalSteps',
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
              SizedBox(height: 8.h),
              LinearProgressIndicator(
                value: (_currentStep + 1) / _totalSteps,
                backgroundColor: Colors.white24,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),

        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Body part icon
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _isPlaying ? 1.0 : _pulseAnimation.value,
                    child: Container(
                      width: 120.w,
                      height: 120.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        currentStepData['icon'],
                        color: Colors.white,
                        size: 60.sp,
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 32.h),

              // Step title
              Text(
                currentStepData['title'],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 16.h),

              // Instruction
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Text(
                  currentStepData['instruction'],
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: 40.h),

              // Step progress
              if (_isPlaying)
                AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return Container(
                      width: 200.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: _progressAnimation.value,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    );
                  },
                ),

              SizedBox(height: 60.h),

              // Control buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (!_isPlaying)
                    ElevatedButton(
                      onPressed: _currentStep == 0 ? _startRelaxation : _resumeRelaxation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF1B4B6F),
                        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        _currentStep == 0 ? 'Start' : 'Resume',
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                  if (_isPlaying)
                    ElevatedButton(
                      onPressed: _pauseRelaxation,
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
          ),
        ),
      ],
    );
  }

  Widget _buildCompletionView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.self_improvement,
          color: Colors.green,
          size: 80.sp,
        ),
        SizedBox(height: 24.h),
        Text(
          'Relaxation Complete!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          'You completed all $_totalSteps relaxation steps',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(height: 24.h),
        Text(
          'Take a moment to enjoy the feeling\nof complete relaxation',
          style: TextStyle(
            color: Colors.white60,
            fontSize: 14.sp,
          ),
          textAlign: TextAlign.center,
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
} 