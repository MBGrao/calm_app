import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import 'dart:math' as math;
import '../widgets/theme_aware_components.dart';
import '../widgets/interactive_feedback.dart';
import '../core/controllers/theme_controller.dart';
import '../services/speech_service.dart';
import '../services/ai_response_service.dart';

enum RecordingState {
  idle,
  recording,
  processing,
  completed,
  error,
}

class VoiceInputWidget extends StatefulWidget {
  final Function(String)? onVoiceInput;
  final Function(String)? onError;
  final Function(AIResponse)? onAIResponse;
  final Duration maxRecordingDuration;
  final bool showVisualization;
  final String? placeholderText;

  const VoiceInputWidget({
    Key? key,
    this.onVoiceInput,
    this.onError,
    this.onAIResponse,
    this.maxRecordingDuration = const Duration(seconds: 60),
    this.showVisualization = true,
    this.placeholderText,
  }) : super(key: key);

  @override
  State<VoiceInputWidget> createState() => _VoiceInputWidgetState();
}

class _VoiceInputWidgetState extends State<VoiceInputWidget>
    with TickerProviderStateMixin {
  RecordingState _recordingState = RecordingState.idle;
  String _currentTranscription = '';
  String _errorMessage = '';
  Duration _recordingDuration = Duration.zero;
  List<double> _audioLevels = [];
  
  // Animation controllers
  late AnimationController _waveAnimation;
  late AnimationController _pulseAnimation;
  late Animation<double> _pulseAnimationValue;
  
  // Timers
  Timer? _recordingTimer;
  Timer? _audioLevelTimer;
  
  // Speech service integration
  final SpeechService _speechService = SpeechService.instance;
  final AIResponseService _aiResponseService = AIResponseService.instance;
  StreamSubscription<SpeechResult>? _transcriptionSubscription;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeSpeechService();
  }

  void _initializeAnimations() {
    _waveAnimation = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _pulseAnimation = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _pulseAnimationValue = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseAnimation,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _initializeSpeechService() async {
    try {
      await _speechService.initialize();
    } catch (e) {
      // Handle initialization errors silently to avoid blocking the UI
      debugPrint('Speech service initialization failed: $e');
    }
  }

  @override
  void dispose() {
    _waveAnimation.dispose();
    _pulseAnimation.dispose();
    _recordingTimer?.cancel();
    _audioLevelTimer?.cancel();
    _transcriptionSubscription?.cancel();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      setState(() {
        _recordingState = RecordingState.recording;
        _currentTranscription = '';
        _errorMessage = '';
        _recordingDuration = Duration.zero;
        _audioLevels = List.generate(20, (index) => 0.1 + (index * 0.02));
      });

      // Start animations
      _waveAnimation.repeat();
      _pulseAnimation.repeat();

      // Start recording timer
      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _recordingDuration += const Duration(seconds: 1);
        });

        // Stop recording if max duration reached
        if (_recordingDuration >= widget.maxRecordingDuration) {
          _stopRecording();
        }
      });

      // Start audio level simulation
      _audioLevelTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        setState(() {
          _audioLevels = _audioLevels.map((level) {
            return 0.1 + (math.Random().nextDouble() * 0.9);
          }).toList();
        });
      });

      // Start speech recognition
      await _speechService.startListening();
      
      // Listen for transcription results
      _transcriptionSubscription = _speechService.transcriptionStream.listen(
        (result) {
          setState(() {
            _currentTranscription = result.text;
          });
        },
        onError: (error) {
          _handleError('Speech recognition error: $error');
        },
      );

      HapticFeedbackHelper.mediumImpact();
    } catch (e) {
      _handleError('Failed to start recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      // Stop timers
      _recordingTimer?.cancel();
      _audioLevelTimer?.cancel();
      
      // Stop animations
      _waveAnimation.stop();
      _pulseAnimation.stop();
      
      // Stop speech recognition
      await _speechService.stopListening();
      _transcriptionSubscription?.cancel();

      // Process the final transcription
      final finalText = _currentTranscription.isNotEmpty ? _currentTranscription : _generateSimulatedText();
      
      setState(() {
        _recordingState = RecordingState.processing;
      });

      // Generate AI response
      try {
        final aiResponse = await _aiResponseService.generateResponse(finalText);
        
        setState(() {
          _recordingState = RecordingState.completed;
        });

        HapticFeedbackHelper.selectionChanged();
        
        // Call the callbacks
        widget.onVoiceInput?.call(finalText);
        widget.onAIResponse?.call(aiResponse);
        
      } catch (e) {
        _handleError('Failed to generate AI response: $e');
      }
      
      // Reset after a delay
      Timer(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _recordingState = RecordingState.idle;
            _currentTranscription = '';
            _audioLevels = [];
          });
        }
      });
    } catch (e) {
      _handleError('Failed to stop recording: $e');
    }
  }

  String _generateSimulatedText() {
    final simulatedTexts = [
      'I need help with meditation',
      'Can you guide me through breathing exercises',
      'I want to relax and reduce stress',
      'Play some calming music for me',
      'I feel anxious and need support',
      'Help me focus and concentrate',
      'I want to improve my sleep',
      'Guide me through a mindfulness session',
    ];
    
    return simulatedTexts[math.Random().nextInt(simulatedTexts.length)];
  }

  void _handleError(String error) {
    setState(() {
      _recordingState = RecordingState.error;
      _errorMessage = error;
    });

    // Stop animations
    _waveAnimation.stop();
    _pulseAnimation.stop();
    
    // Cancel timers
    _recordingTimer?.cancel();
    _audioLevelTimer?.cancel();
    
    // Call error callback
    widget.onError?.call(error);
    
    // Reset after delay
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _recordingState = RecordingState.idle;
          _errorMessage = '';
          _audioLevels = [];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          // Recording button
          GestureDetector(
            onTapDown: (_) => _startRecording(),
            onTapUp: (_) => _stopRecording(),
            onTapCancel: () => _stopRecording(),
            child: AnimatedBuilder(
              animation: _pulseAnimationValue,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimationValue.value,
                  child: Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: _recordingState == RecordingState.recording
                            ? [
                                Colors.red.withOpacity(0.8),
                                Colors.orange.withOpacity(0.8),
                              ]
                            : [
                                themeController.getPrimaryColor().withOpacity(0.8),
                                themeController.getPrimaryColor().withOpacity(0.6),
                              ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (_recordingState == RecordingState.recording
                                  ? Colors.red
                                  : themeController.getPrimaryColor())
                              .withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      _getRecordingIcon(),
                      color: Colors.white,
                      size: 32.sp,
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16.h),

          // Recording status
          _buildRecordingStatus(themeController),

          // Error message
          if (_recordingState == RecordingState.error)
            _buildErrorMessage(themeController),
        ],
      ),
    );
  }

  IconData _getRecordingIcon() {
    switch (_recordingState) {
      case RecordingState.idle:
        return Icons.mic;
      case RecordingState.recording:
        return Icons.stop;
      case RecordingState.processing:
        return Icons.hourglass_empty;
      case RecordingState.completed:
        return Icons.check;
      case RecordingState.error:
        return Icons.error;
    }
  }

  Widget _buildRecordingStatus(ThemeController themeController) {
    return Column(
      children: [
        // Status text
        ThemeAwareText(
          _getStatusText(),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        
        // Recording duration
        if (_recordingState == RecordingState.recording)
          ThemeAwareText(
            _formatDuration(_recordingDuration),
            style: TextStyle(
              fontSize: 14.sp,
              color: themeController.getSecondaryTextColor(),
            ),
          ),
        
        // Audio visualization
        if (widget.showVisualization && _audioLevels.isNotEmpty)
          _buildAudioVisualization(themeController),
      ],
    );
  }

  String _getStatusText() {
    switch (_recordingState) {
      case RecordingState.idle:
        return widget.placeholderText ?? 'Tap to start recording';
      case RecordingState.recording:
        return 'Recording... Tap to stop';
      case RecordingState.processing:
        return 'Processing your voice...';
      case RecordingState.completed:
        return 'Voice input received!';
      case RecordingState.error:
        return 'Recording failed';
    }
  }

  Widget _buildAudioVisualization(ThemeController themeController) {
    return Container(
      height: 60.h,
      margin: EdgeInsets.symmetric(vertical: 16.h),
      child: AnimatedBuilder(
        animation: _waveAnimation,
        builder: (context, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _audioLevels.map((level) {
              return Container(
                width: 3.w,
                margin: EdgeInsets.symmetric(horizontal: 1.w),
                decoration: BoxDecoration(
                  color: themeController.getPrimaryColor(),
                  borderRadius: BorderRadius.circular(2),
                ),
                height: (level * 50).h,
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildErrorMessage(ThemeController themeController) {
    return Container(
      padding: EdgeInsets.all(12.w),
      margin: EdgeInsets.only(top: 8.h),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.red.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 20.sp,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: ThemeAwareText(
              _errorMessage,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
} 