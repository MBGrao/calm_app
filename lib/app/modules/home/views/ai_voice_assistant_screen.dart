import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'breathing_exercise_screen.dart';

class AIVoiceAssistantScreen extends StatefulWidget {
  const AIVoiceAssistantScreen({Key? key}) : super(key: key);

  @override
  State<AIVoiceAssistantScreen> createState() => _AIVoiceAssistantScreenState();
}

class _AIVoiceAssistantScreenState extends State<AIVoiceAssistantScreen>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _pulseController;
  late AnimationController _rippleController;
  late Animation<double> _waveAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rippleAnimation;

  bool _isListening = false;
  bool _isProcessing = false;
  bool _isSpeaking = false;
  bool _showVoiceVisualizer = false;
  
  String _currentResponse = '';
  String _recognitionText = '';
  double _voiceLevel = 0.0;
  double _confidence = 0.0;
  
  List<String> _conversationHistory = [];
  List<double> _voiceLevels = [];
  Timer? _voiceTimer;
  Timer? _processingTimer;

  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startVoiceAssistant();
  }

  void _initializeAnimations() {
    _waveController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _waveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _rippleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeOut),
    );

    _pulseController.repeat(reverse: true);
  }

  void _startVoiceAssistant() async {
    setState(() {
      _isProcessing = true;
      _currentResponse = "Initializing voice assistant...";
    });

    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _currentResponse = "Calibrating microphone...";
    });

    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _currentResponse = "Voice assistant ready! Tap the microphone to start.";
      _isProcessing = false;
    });

    _conversationHistory.add("Voice Assistant: Hello! I'm your AI voice assistant. How can I help you today?");
  }

  void _startVoiceRecognition() async {
    setState(() {
      _isListening = true;
      _showVoiceVisualizer = true;
      _recognitionText = "Listening...";
      _voiceLevel = 0.0;
      _voiceLevels.clear();
    });

    _waveController.repeat();
    _rippleController.repeat();

    // Simulate voice level changes
    _voiceTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_isListening) {
        setState(() {
          _voiceLevel = 0.3 + (_random.nextDouble() * 0.7);
          _voiceLevels.add(_voiceLevel);
          if (_voiceLevels.length > 50) {
            _voiceLevels.removeAt(0);
          }
        });
      } else {
        timer.cancel();
      }
    });

    // Simulate speech recognition
    await Future.delayed(const Duration(seconds: 3));

    // Random realistic voice inputs
    final voiceInputs = [
      "I need help with meditation",
      "I'm feeling stressed today",
      "Can you guide me through breathing exercises",
      "I want to relax and sleep better",
      "I'm anxious and need calming techniques",
      "Help me focus and concentrate",
      "I want to practice mindfulness",
      "I need energy and motivation",
    ];

    final selectedInput = voiceInputs[_random.nextInt(voiceInputs.length)];
    
    // Simulate real-time speech recognition
    final words = selectedInput.split(' ');
    String recognizedText = '';
    
    for (int i = 0; i < words.length; i++) {
      await Future.delayed(Duration(milliseconds: 200 + _random.nextInt(300)));
      recognizedText += (recognizedText.isEmpty ? '' : ' ') + words[i];
      setState(() {
        _recognitionText = recognizedText;
      });
    }

    setState(() {
      _isListening = false;
      _confidence = 0.85 + (_random.nextDouble() * 0.15);
    });

    _waveController.stop();
    _rippleController.stop();
    _voiceTimer?.cancel();

    _conversationHistory.add("You: $recognizedText");
    _processVoiceInput(recognizedText);
  }

  void _processVoiceInput(String input) async {
    setState(() {
      _isProcessing = true;
    });

    // Simulate AI processing
    final processingSteps = [
      "Processing your request...",
      "Analyzing voice patterns...",
      "Understanding your needs...",
      "Generating personalized response...",
    ];

    for (int i = 0; i < processingSteps.length; i++) {
      await Future.delayed(Duration(milliseconds: 800 + _random.nextInt(400)));
      setState(() {
        _currentResponse = processingSteps[i];
      });
    }

    // Generate AI response based on input
    final response = _generateAIResponse(input);
    
    setState(() {
      _currentResponse = response;
      _isProcessing = false;
    });

    _conversationHistory.add("AI Assistant: $response");

    // Simulate AI speaking
    await Future.delayed(const Duration(seconds: 1));
    _simulateAISpeaking(response);
  }

  String _generateAIResponse(String input) {
    final lowerInput = input.toLowerCase();
    
    if (lowerInput.contains('meditation')) {
      return "I'd be happy to guide you through a meditation session. I can offer different types like mindfulness, loving-kindness, or body scan meditation. Which would you prefer?";
    } else if (lowerInput.contains('stress') || lowerInput.contains('stressed')) {
      return "I understand stress can be overwhelming. Let me help you with some stress relief techniques. I can guide you through deep breathing, progressive muscle relaxation, or a quick stress relief meditation.";
    } else if (lowerInput.contains('breathing') || lowerInput.contains('breathe')) {
      return "Breathing exercises are excellent for relaxation. I can guide you through box breathing, 4-7-8 breathing, or diaphragmatic breathing. Which technique would you like to try?";
    } else if (lowerInput.contains('sleep') || lowerInput.contains('sleep better')) {
      return "Sleep is crucial for well-being. I can help you with sleep meditation, breathing techniques for sleep, or relaxation exercises. Would you like to try a sleep-inducing meditation?";
    } else if (lowerInput.contains('anxious') || lowerInput.contains('anxiety')) {
      return "Anxiety can be challenging. I have several techniques that can help: grounding exercises, anxiety relief breathing, or a calming meditation. What feels most helpful right now?";
    } else if (lowerInput.contains('focus') || lowerInput.contains('concentrate')) {
      return "Focus and concentration are skills we can develop. I can guide you through focus meditation, attention training, or mindfulness exercises. Which would you prefer?";
    } else if (lowerInput.contains('relax') || lowerInput.contains('relaxation')) {
      return "Relaxation is essential for your well-being. I can offer guided relaxation, progressive muscle relaxation, or calming breathing exercises. What sounds most appealing?";
    } else if (lowerInput.contains('mindfulness')) {
      return "Mindfulness is a wonderful practice. I can guide you through mindful breathing, body scan meditation, or present moment awareness. Which mindfulness practice interests you?";
    } else if (lowerInput.contains('energy') || lowerInput.contains('motivation')) {
      return "Sometimes we need a boost of energy and motivation. I can guide you through energizing breathing, motivation meditation, or uplifting practices. What would help you most?";
    } else {
      return "I'm here to help you with meditation, breathing exercises, stress relief, and mindfulness practices. What would you like to work on today?";
    }
  }

  void _simulateAISpeaking(String response) async {
    setState(() {
      _isSpeaking = true;
    });

    // Simulate text-to-speech processing
    final words = response.split(' ');
    String spokenText = '';
    
    for (int i = 0; i < words.length; i++) {
      await Future.delayed(Duration(milliseconds: 150 + _random.nextInt(100)));
      spokenText += (spokenText.isEmpty ? '' : ' ') + words[i];
      setState(() {
        _currentResponse = spokenText;
      });
    }

    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      _isSpeaking = false;
    });

    // Show action buttons after speaking
    _showActionOptions();
  }

  void _showActionOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1B4B6F),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'What would you like to do?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _startBreathingExercise();
                    },
                    icon: Icon(Icons.air, color: Colors.white),
                    label: Text('Start Breathing'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _startVoiceRecognition();
                    },
                    icon: Icon(Icons.mic, color: Colors.white),
                    label: Text('Ask More'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.close, color: Colors.white),
              label: Text('Close'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startBreathingExercise() {
    Get.to(() => const BreathingExerciseScreen());
  }

  @override
  void dispose() {
    _waveController.dispose();
    _pulseController.dispose();
    _rippleController.dispose();
    _voiceTimer?.cancel();
    _processingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B4B6F),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _buildMainContent(),
            ),
            _buildVoiceControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.transparent,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          SizedBox(width: 12.w),
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: 20.r,
                  child: Icon(Icons.mic, color: Colors.white, size: 20.sp),
                ),
              );
            },
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Voice Assistant',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _isListening ? 'Listening...' : _isProcessing ? 'Processing...' : 'Ready to help',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          if (_isListening)
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          // Voice Visualizer
          if (_showVoiceVisualizer) _buildVoiceVisualizer(),
          
          // Recognition Text
          if (_recognitionText.isNotEmpty) _buildRecognitionText(),
          
          // AI Response
          if (_currentResponse.isNotEmpty) _buildAIResponse(),
          
          // Conversation History
          Expanded(
            child: _buildConversationHistory(),
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceVisualizer() {
    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      height: 120.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ripple effect
          if (_isListening)
            AnimatedBuilder(
              animation: _rippleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.0 + (_rippleAnimation.value * 0.5),
                  child: Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.3 - (_rippleAnimation.value * 0.3)),
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
          
          // Voice level bars
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(20, (index) {
              final level = _voiceLevels.isNotEmpty && index < _voiceLevels.length
                  ? _voiceLevels[index]
                  : 0.0;
              
              return Container(
                width: 3.w,
                height: 20.h + (level * 60.h),
                margin: EdgeInsets.symmetric(horizontal: 1.w),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              );
            }),
          ),
          
          // Center microphone
          AnimatedBuilder(
            animation: _waveAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (_waveAnimation.value * 0.2),
                child: Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.mic,
                    color: Colors.white,
                    size: 30.sp,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecognitionText() {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.blue.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.mic, color: Colors.blue, size: 16.sp),
              SizedBox(width: 8.w),
              Text(
                'Recognized',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '${(_confidence * 100).toInt()}%',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            _recognitionText,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIResponse() {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue,
            radius: 16.r,
            child: Icon(Icons.psychology, color: Colors.white, size: 16.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'AI Assistant',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (_isSpeaking) ...[
                      SizedBox(width: 8.w),
                      SizedBox(
                        width: 12.w,
                        height: 12.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  _currentResponse,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationHistory() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: _conversationHistory.length,
        itemBuilder: (context, index) {
          final message = _conversationHistory[index];
          final isAI = message.startsWith('AI Assistant:');
          
          return Container(
            margin: EdgeInsets.only(bottom: 12.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: isAI ? MainAxisAlignment.start : MainAxisAlignment.end,
              children: [
                if (isAI) ...[
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 12.r,
                    child: Icon(Icons.psychology, color: Colors.white, size: 12.sp),
                  ),
                  SizedBox(width: 8.w),
                ],
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: isAI 
                          ? Colors.white.withOpacity(0.1)
                          : Colors.blue.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isAI 
                            ? Colors.white.withOpacity(0.2)
                            : Colors.blue.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      message,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ),
                if (!isAI) ...[
                  SizedBox(width: 8.w),
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 12.r,
                    child: Icon(Icons.person, color: Colors.white, size: 12.sp),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildVoiceControls() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _isListening ? null : _startVoiceRecognition,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                color: _isListening ? Colors.red : Colors.blue,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (_isListening ? Colors.red : Colors.blue).withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                _isListening ? Icons.stop : Icons.mic,
                color: Colors.white,
                size: 32.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 