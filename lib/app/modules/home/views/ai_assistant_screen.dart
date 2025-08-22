import 'dart:async';
import 'dart:math';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'breathing_exercise_screen.dart';

// Emotional state enum
enum EmotionalState {
  calm,
  anxious,
  stressed,
  happy,
  sad,
  excited,
  tired,
  focused,
  relaxed,
  neutral,
}

// Emotional analysis result
class EmotionalAnalysis {
  final EmotionalState primaryEmotion;
  final double confidence;
  final String reasoning;

  EmotionalAnalysis({
    required this.primaryEmotion,
    required this.confidence,
    required this.reasoning,
  });
}

class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({Key? key}) : super(key: key);

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late Animation<double> _pulseAnimation;

  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isListening = false;
  bool _isProcessing = false;
  String _currentResponse = '';
  List<Map<String, dynamic>> _conversationHistory = [];
  EmotionalState _currentEmotion = EmotionalState.neutral;
  double _confidence = 0.0;

  // AI Processing States
  bool _showEmotionAnalysis = false;
  bool _showRecommendations = false;
  bool _showActionButtons = false;
  List<String> _recommendations = [];

  // Realistic AI processing delays
  final List<String> _processingMessages = [
    "Analyzing your emotional state...",
    "Processing your request...",
    "Generating personalized response...",
    "Finding the perfect solution...",
    "Adapting to your preferences...",
    "Learning from our interaction...",
  ];

  @override
  void initState() {
    super.initState();
    developer.log('🎯 AI Assistant Screen - initState called', name: 'AIAssistantScreen');
    try {
      _initializeAnimations();
      _startAIInitialization();
      developer.log('🎯 AI Assistant Screen - initState completed successfully', name: 'AIAssistantScreen');
    } catch (e) {
      developer.log('🎯 AI Assistant Screen - Error in initState: $e', name: 'AIAssistantScreen');
    }
  }

  void _initializeAnimations() {
    developer.log('🎯 AI Assistant Screen - Initializing animations', name: 'AIAssistantScreen');
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _waveController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _pulseController.repeat(reverse: true);
    _waveController.repeat();
  }

  void _startAIInitialization() async {
    developer.log('🎯 AI Assistant Screen - Starting AI initialization', name: 'AIAssistantScreen');
    setState(() {
      _isProcessing = true;
      _currentResponse = "Initializing AI Assistant...";
    });

    // Simulate AI initialization
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _currentResponse = "Loading your personal profile...";
    });

    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _currentResponse = "Analyzing your meditation patterns...";
    });

    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _currentResponse = "Ready to assist you! How are you feeling today?";
      _isProcessing = false;
      _showActionButtons = true;
    });

    developer.log('🎯 AI Assistant Screen - AI initialization complete', name: 'AIAssistantScreen');
    _addToConversation("AI", _currentResponse, true);
  }

  EmotionalAnalysis analyzeEmotion(String input) {
    developer.log('🎯 AI Assistant Screen - Analyzing emotion for: $input', name: 'AIAssistantScreen');
    final lowerInput = input.toLowerCase();
    final emotionScores = <EmotionalState, double>{};
    
    // Initialize all emotions with neutral score
    for (final emotion in EmotionalState.values) {
      emotionScores[emotion] = 0.0;
    }

    // Analyze keywords and patterns
    if (lowerInput.contains('anxious') || lowerInput.contains('worry') || lowerInput.contains('nervous')) {
      emotionScores[EmotionalState.anxious] = 0.8;
      emotionScores[EmotionalState.stressed] = 0.6;
    }
    
    if (lowerInput.contains('stress') || lowerInput.contains('overwhelmed') || lowerInput.contains('pressure')) {
      emotionScores[EmotionalState.stressed] = 0.9;
      emotionScores[EmotionalState.anxious] = 0.7;
    }
    
    if (lowerInput.contains('tired') || lowerInput.contains('exhausted') || lowerInput.contains('sleepy')) {
      emotionScores[EmotionalState.tired] = 0.8;
      emotionScores[EmotionalState.sad] = 0.4;
    }
    
    if (lowerInput.contains('happy') || lowerInput.contains('joy') || lowerInput.contains('excited')) {
      emotionScores[EmotionalState.happy] = 0.9;
      emotionScores[EmotionalState.excited] = 0.7;
    }
    
    if (lowerInput.contains('sad') || lowerInput.contains('depressed') || lowerInput.contains('down')) {
      emotionScores[EmotionalState.sad] = 0.8;
      emotionScores[EmotionalState.tired] = 0.5;
    }
    
    if (lowerInput.contains('focus') || lowerInput.contains('concentrate') || lowerInput.contains('attention')) {
      emotionScores[EmotionalState.focused] = 0.8;
      emotionScores[EmotionalState.calm] = 0.6;
    }
    
    if (lowerInput.contains('calm') || lowerInput.contains('peaceful') || lowerInput.contains('relaxed')) {
      emotionScores[EmotionalState.calm] = 0.8;
      emotionScores[EmotionalState.relaxed] = 0.7;
    }

    // Find primary emotion
    EmotionalState primaryEmotion = EmotionalState.neutral;
    double maxScore = 0.0;
    
    for (final entry in emotionScores.entries) {
      if (entry.value > maxScore) {
        maxScore = entry.value;
        primaryEmotion = entry.key;
      }
    }

    // Generate reasoning
    String reasoning = _generateEmotionReasoning(lowerInput, primaryEmotion);

    developer.log('🎯 AI Assistant Screen - Detected emotion: $primaryEmotion (${(maxScore * 100).toInt()}%)', name: 'AIAssistantScreen');

    return EmotionalAnalysis(
      primaryEmotion: primaryEmotion,
      confidence: maxScore,
      reasoning: reasoning,
    );
  }

  String _generateEmotionReasoning(String input, EmotionalState emotion) {
    switch (emotion) {
      case EmotionalState.anxious:
        return "Detected anxiety-related keywords and patterns in your input.";
      case EmotionalState.stressed:
        return "Identified stress indicators and overwhelmed language patterns.";
      case EmotionalState.tired:
        return "Recognized fatigue-related expressions and tiredness indicators.";
      case EmotionalState.happy:
        return "Detected positive emotions and joyful language patterns.";
      case EmotionalState.sad:
        return "Identified sadness indicators and negative emotional patterns.";
      case EmotionalState.focused:
        return "Recognized concentration and focus-related language.";
      case EmotionalState.calm:
        return "Detected calm and peaceful language patterns.";
      case EmotionalState.relaxed:
        return "Identified relaxation and tranquility indicators.";
      default:
        return "Analyzed input for emotional patterns and context.";
    }
  }

  void _simulateVoiceInput() async {
    developer.log('🎯 AI Assistant Screen - Voice input button tapped', name: 'AIAssistantScreen');
    setState(() {
      _isListening = true;
    });

    // Simulate voice recognition
    await Future.delayed(const Duration(seconds: 2));
    
    // Random realistic inputs
    final inputs = [
      "I'm feeling really anxious today",
      "I need help with my breathing",
      "I want to meditate but I'm stressed",
      "I can't sleep well",
      "I'm feeling overwhelmed",
      "I want to relax and find peace",
      "I'm tired and need energy",
      "I want to focus better",
    ];

    final randomInput = inputs[Random().nextInt(inputs.length)];
    developer.log('🎯 AI Assistant Screen - Simulated voice input: $randomInput', name: 'AIAssistantScreen');
    setState(() {
      _isListening = false;
    });

    _addToConversation("You", randomInput, false);
    _processAIResponse(randomInput);
  }

  void _processAIResponse(String input) async {
    developer.log('🎯 AI Assistant Screen - Processing AI response for: $input', name: 'AIAssistantScreen');
    setState(() {
      _isProcessing = true;
      _showEmotionAnalysis = false;
      _showRecommendations = false;
      _showActionButtons = false;
    });

    // Simulate AI processing
    for (int i = 0; i < 3; i++) {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _currentResponse = _processingMessages[Random().nextInt(_processingMessages.length)];
      });
    }

    // Analyze emotion
    final emotionalAnalysis = analyzeEmotion(input);
    setState(() {
      _currentEmotion = emotionalAnalysis.primaryEmotion;
      _confidence = emotionalAnalysis.confidence;
      _showEmotionAnalysis = true;
      _currentResponse = "I can sense you're feeling ${_getEmotionDisplayName(emotionalAnalysis.primaryEmotion)} (${(emotionalAnalysis.confidence * 100).toInt()}% confidence)";
    });

    await Future.delayed(const Duration(seconds: 2));

    // Generate recommendations
    final recommendations = _generateRecommendations(emotionalAnalysis.primaryEmotion);
    setState(() {
      _recommendations = recommendations;
      _showRecommendations = true;
      _currentResponse = _generatePersonalizedResponse(input, emotionalAnalysis);
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isProcessing = false;
      _showActionButtons = true;
    });

    developer.log('🎯 AI Assistant Screen - AI response complete', name: 'AIAssistantScreen');
    _addToConversation("AI", _currentResponse, true);
  }

  String _getEmotionDisplayName(EmotionalState emotion) {
    switch (emotion) {
      case EmotionalState.anxious:
        return "anxious";
      case EmotionalState.stressed:
        return "stressed";
      case EmotionalState.tired:
        return "tired";
      case EmotionalState.happy:
        return "happy";
      case EmotionalState.sad:
        return "sad";
      case EmotionalState.calm:
        return "calm";
      case EmotionalState.relaxed:
        return "relaxed";
      case EmotionalState.focused:
        return "focused";
      case EmotionalState.excited:
        return "excited";
      default:
        return "neutral";
    }
  }

  List<String> _generateRecommendations(EmotionalState emotion) {
    final Map<EmotionalState, List<String>> emotionRecommendations = {
      EmotionalState.anxious: [
        "Deep breathing exercise (5 minutes)",
        "Anxiety relief meditation",
        "Progressive muscle relaxation",
        "Calming nature sounds",
        "Mindful walking session"
      ],
      EmotionalState.stressed: [
        "Stress relief breathing",
        "Body scan meditation",
        "Gentle yoga flow",
        "Soothing instrumental music",
        "Guided relaxation"
      ],
      EmotionalState.tired: [
        "Energizing breathing",
        "Light meditation",
        "Uplifting music",
        "Mindful stretching",
        "Power nap guidance"
      ],
      EmotionalState.happy: [
        "Joyful meditation",
        "Gratitude practice",
        "Celebration breathing",
        "Positive affirmations",
        "Mindful appreciation"
      ],
      EmotionalState.sad: [
        "Compassion meditation",
        "Gentle self-care",
        "Soothing sounds",
        "Loving-kindness practice",
        "Emotional healing session"
      ],
    };

    return emotionRecommendations[emotion] ?? [
      "Mindful breathing",
      "Guided meditation",
      "Relaxation music",
      "Body awareness",
      "Present moment practice"
    ];
  }

  String _generatePersonalizedResponse(String input, EmotionalAnalysis analysis) {
    final responses = {
      EmotionalState.anxious: [
        "I understand anxiety can be overwhelming. Let me help you find your center with a calming practice.",
        "Anxiety often responds well to gentle breathing and mindfulness. I'll guide you through something soothing.",
        "I can sense your anxiety. Let's work through this together with a peaceful meditation session."
      ],
      EmotionalState.stressed: [
        "Stress can be exhausting. Let's release some tension with a relaxing practice.",
        "I'll help you unwind and find peace with a stress-relief session.",
        "When stress builds up, taking time to breathe and center yourself can make a big difference."
      ],
      EmotionalState.tired: [
        "You seem tired. Let me help you feel more refreshed and energized.",
        "Sometimes when we're tired, a gentle practice can help us feel more awake and centered.",
        "I'll guide you through something that can help with your tiredness and boost your energy."
      ],
      EmotionalState.happy: [
        "It's wonderful that you're feeling happy! Let's enhance that joy with a mindful practice.",
        "Your happiness is beautiful! Let's celebrate it with a joyful meditation session.",
        "When you're happy, mindfulness can help you savor that feeling even more."
      ],
    };

    final emotionResponses = responses[analysis.primaryEmotion] ?? [
      "I'm here to help you find peace and balance. Let's practice together.",
      "Mindfulness can help you connect with your inner self and find clarity.",
      "Let me guide you through a practice that can support your well-being."
    ];

    return emotionResponses[Random().nextInt(emotionResponses.length)];
  }

  void _addToConversation(String sender, String message, bool isAI) {
    setState(() {
      _conversationHistory.add({
        'sender': sender,
        'message': message,
        'isAI': isAI,
        'timestamp': DateTime.now(),
      });
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _startRecommendedSession(String recommendation) async {
    developer.log('🎯 AI Assistant Screen - Starting recommended session: $recommendation', name: 'AIAssistantScreen');
    setState(() {
      _isProcessing = true;
      _currentResponse = "Preparing your ${recommendation.toLowerCase()} session...";
    });

    await Future.delayed(const Duration(seconds: 2));

    // Navigate to appropriate screen based on recommendation
    if (recommendation.toLowerCase().contains('breathing')) {
      developer.log('🎯 AI Assistant Screen - Navigating to breathing exercise', name: 'AIAssistantScreen');
      Get.to(() => const BreathingExerciseScreen());
    } else if (recommendation.toLowerCase().contains('meditation')) {
      // Show a dialog for meditation session
      _showMeditationSessionDialog(recommendation);
    }

    setState(() {
      _isProcessing = false;
    });
  }

  void _showMeditationSessionDialog(String recommendation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1B4B6F),
        title: Text(
          'AI Guided Meditation',
          style: TextStyle(color: Colors.white, fontSize: 18.sp),
        ),
        content: Text(
          'Starting your personalized meditation session: $recommendation',
          style: TextStyle(color: Colors.white70, fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Get.snackbar(
                'Meditation Started',
                'Your AI-guided meditation session is beginning...',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: Text('Start Session'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    developer.log('🎯 AI Assistant Screen - dispose called', name: 'AIAssistantScreen');
    _pulseController.dispose();
    _waveController.dispose();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    developer.log('🎯 AI Assistant Screen - build called', name: 'AIAssistantScreen');
    try {
      return Scaffold(
        backgroundColor: const Color(0xFF1B4B6F),
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: _buildMainContent(),
              ),
              _buildInputSection(),
            ],
          ),
        ),
      );
    } catch (e) {
      developer.log('🎯 AI Assistant Screen - Error in build: $e', name: 'AIAssistantScreen');
      return Scaffold(
        backgroundColor: const Color(0xFF1B4B6F),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, color: Colors.white, size: 50.sp),
              SizedBox(height: 16.h),
              Text(
                'Error loading AI Assistant',
                style: TextStyle(color: Colors.white, fontSize: 18.sp),
              ),
              SizedBox(height: 8.h),
              Text(
                'Error: $e',
                style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
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
            onPressed: () {
              developer.log('🎯 AI Assistant Screen - Back button tapped', name: 'AIAssistantScreen');
              Get.back();
            },
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
                  child: Icon(Icons.psychology, color: Colors.white, size: 20.sp),
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
                  'AI Assistant',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _isProcessing ? 'Processing...' : 'Ready to help',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          if (_isProcessing)
            SizedBox(
              width: 20.w,
              height: 20.w,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
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
          // AI Response Area
          if (_isProcessing || _currentResponse.isNotEmpty)
            _buildAIResponseArea(),
          
          // Emotion Analysis
          if (_showEmotionAnalysis)
            _buildEmotionAnalysis(),
          
          // Recommendations
          if (_showRecommendations)
            _buildRecommendations(),
          
          // Action Buttons
          if (_showActionButtons)
            _buildActionButtons(),
          
          // Conversation History
          Expanded(
            child: _buildConversationHistory(),
          ),
        ],
      ),
    );
  }

  Widget _buildAIResponseArea() {
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
            child: _isProcessing
                ? Row(
                    children: [
                      Expanded(
                        child: Text(
                          _currentResponse,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
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
                  )
                : Text(
                    _currentResponse,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionAnalysis() {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: _getEmotionColor(_currentEmotion).withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getEmotionColor(_currentEmotion).withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getEmotionIcon(_currentEmotion),
                color: _getEmotionColor(_currentEmotion),
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Emotional Analysis',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'Detected: ${_getEmotionDisplayName(_currentEmotion).toUpperCase()}',
            style: TextStyle(
              color: _getEmotionColor(_currentEmotion),
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
          LinearProgressIndicator(
            value: _confidence,
            backgroundColor: Colors.white.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(_getEmotionColor(_currentEmotion)),
          ),
          SizedBox(height: 4.h),
          Text(
            'Confidence: ${(_confidence * 100).toInt()}%',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations() {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personalized Recommendations',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          ...List.generate(_recommendations.length, (index) {
            return GestureDetector(
              onTap: () {
                developer.log('🎯 AI Assistant Screen - Recommendation tapped: ${_recommendations[index]}', name: 'AIAssistantScreen');
                _startRecommendedSession(_recommendations[index]);
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 8.h),
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getRecommendationIcon(_recommendations[index]),
                      color: Colors.blue,
                      size: 20.sp,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        _recommendations[index],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white70,
                      size: 16.sp,
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _simulateVoiceInput,
              icon: Icon(
                _isListening ? Icons.mic : Icons.mic_none,
                color: Colors.white,
                size: 20.sp,
              ),
              label: Text(
                _isListening ? 'Listening...' : 'Voice Input',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isListening ? Colors.red : Colors.blue,
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
                developer.log('🎯 AI Assistant Screen - Quick Chat button tapped', name: 'AIAssistantScreen');
                // Simulate text input
                final textInputs = [
                  "I need help relaxing",
                  "Can you guide me through meditation?",
                  "I'm feeling stressed",
                  "Help me sleep better",
                ];
                final randomInput = textInputs[Random().nextInt(textInputs.length)];
                developer.log('🎯 AI Assistant Screen - Simulated text input: $randomInput', name: 'AIAssistantScreen');
                _textController.text = randomInput;
                _addToConversation("You", randomInput, false);
                _processAIResponse(randomInput);
              },
              icon: Icon(
                Icons.chat,
                color: Colors.white,
                size: 20.sp,
              ),
              label: Text(
                'Quick Chat',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
              ),
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
    );
  }

  Widget _buildConversationHistory() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(16.w),
        itemCount: _conversationHistory.length,
        itemBuilder: (context, index) {
          final message = _conversationHistory[index];
          return _buildMessageBubble(message);
        },
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isAI = message['isAI'] as bool;
    final sender = message['sender'] as String;
    final text = message['message'] as String;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isAI ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isAI) ...[
            CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 16.r,
              child: Icon(Icons.psychology, color: Colors.white, size: 16.sp),
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
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isAI 
                      ? Colors.white.withOpacity(0.2)
                      : Colors.blue.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sender,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    text,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!isAI) ...[
            SizedBox(width: 8.w),
            CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 16.r,
              child: Icon(Icons.person, color: Colors.white, size: 16.sp),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
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
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Type your message...',
                hintStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          GestureDetector(
            onTap: () {
              if (_textController.text.isNotEmpty) {
                final input = _textController.text;
                developer.log('🎯 AI Assistant Screen - Send button tapped with text: $input', name: 'AIAssistantScreen');
                _textController.clear();
                _addToConversation("You", input, false);
                _processAIResponse(input);
              }
            },
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(
                Icons.send,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getEmotionColor(EmotionalState emotion) {
    switch (emotion) {
      case EmotionalState.anxious:
        return Colors.orange;
      case EmotionalState.stressed:
        return Colors.red;
      case EmotionalState.tired:
        return Colors.purple;
      case EmotionalState.happy:
        return Colors.green;
      case EmotionalState.sad:
        return Colors.blue;
      case EmotionalState.calm:
        return Colors.teal;
      case EmotionalState.relaxed:
        return Colors.indigo;
      case EmotionalState.focused:
        return Colors.cyan;
      case EmotionalState.excited:
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }

  IconData _getEmotionIcon(EmotionalState emotion) {
    switch (emotion) {
      case EmotionalState.anxious:
        return Icons.sentiment_dissatisfied;
      case EmotionalState.stressed:
        return Icons.sentiment_very_dissatisfied;
      case EmotionalState.tired:
        return Icons.sentiment_neutral;
      case EmotionalState.happy:
        return Icons.sentiment_very_satisfied;
      case EmotionalState.sad:
        return Icons.sentiment_dissatisfied;
      case EmotionalState.calm:
        return Icons.sentiment_satisfied;
      case EmotionalState.relaxed:
        return Icons.sentiment_satisfied_alt;
      case EmotionalState.focused:
        return Icons.psychology;
      case EmotionalState.excited:
        return Icons.sentiment_very_satisfied;
      default:
        return Icons.sentiment_neutral;
    }
  }

  IconData _getRecommendationIcon(String recommendation) {
    if (recommendation.toLowerCase().contains('breathing')) {
      return Icons.air;
    } else if (recommendation.toLowerCase().contains('meditation')) {
      return Icons.self_improvement;
    } else if (recommendation.toLowerCase().contains('music')) {
      return Icons.music_note;
    } else if (recommendation.toLowerCase().contains('yoga')) {
      return Icons.fitness_center;
    } else if (recommendation.toLowerCase().contains('walking')) {
      return Icons.directions_walk;
    } else if (recommendation.toLowerCase().contains('relaxation')) {
      return Icons.spa;
    } else {
      return Icons.psychology;
    }
  }
} 