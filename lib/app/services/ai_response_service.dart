import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:math' as math;

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

// User context model
class UserContext {
  final String userId;
  final EmotionalState currentEmotion;
  final List<String> recentInteractions;
  final Map<String, int> preferenceHistory;
  final DateTime lastSession;
  final int totalSessions;
  final String preferredLanguage;
  final List<String> favoriteCategories;

  UserContext({
    required this.userId,
    required this.currentEmotion,
    required this.recentInteractions,
    required this.preferenceHistory,
    required this.lastSession,
    required this.totalSessions,
    required this.preferredLanguage,
    required this.favoriteCategories,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'currentEmotion': currentEmotion.toString(),
      'recentInteractions': recentInteractions,
      'preferenceHistory': preferenceHistory,
      'lastSession': lastSession.toIso8601String(),
      'totalSessions': totalSessions,
      'preferredLanguage': preferredLanguage,
      'favoriteCategories': favoriteCategories,
    };
  }

  factory UserContext.fromMap(Map<String, dynamic> map) {
    return UserContext(
      userId: map['userId'] ?? '',
      currentEmotion: EmotionalState.values.firstWhere(
        (e) => e.toString() == map['currentEmotion'],
        orElse: () => EmotionalState.neutral,
      ),
      recentInteractions: List<String>.from(map['recentInteractions'] ?? []),
      preferenceHistory: Map<String, int>.from(map['preferenceHistory'] ?? {}),
      lastSession: DateTime.parse(map['lastSession'] ?? DateTime.now().toIso8601String()),
      totalSessions: map['totalSessions'] ?? 0,
      preferredLanguage: map['preferredLanguage'] ?? 'en-US',
      favoriteCategories: List<String>.from(map['favoriteCategories'] ?? []),
    );
  }
}

// AI response model
class AIResponse {
  final String text;
  final String action;
  final EmotionalState suggestedEmotion;
  final double confidence;
  final Map<String, dynamic> metadata;
  final DateTime timestamp;

  AIResponse({
    required this.text,
    required this.action,
    required this.suggestedEmotion,
    required this.confidence,
    required this.metadata,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'AIResponse(text: $text, action: $action, emotion: $suggestedEmotion, confidence: $confidence)';
  }
}

// Emotional analysis result
class EmotionalAnalysis {
  final EmotionalState primaryEmotion;
  final Map<EmotionalState, double> emotionScores;
  final double confidence;
  final String reasoning;

  EmotionalAnalysis({
    required this.primaryEmotion,
    required this.emotionScores,
    required this.confidence,
    required this.reasoning,
  });
}

// AI Response Service
class AIResponseService {
  static AIResponseService? _instance;
  static AIResponseService get instance => _instance ??= AIResponseService._();

  AIResponseService._();

  // User context management
  UserContext? _currentUserContext;
  final List<AIResponse> _responseHistory = [];
  final Map<String, int> _actionFrequency = {};



  // Response templates by emotion and action
  final Map<EmotionalState, Map<String, List<String>>> _responseTemplates = {
    EmotionalState.anxious: {
      'breathing': [
        "I can sense you're feeling anxious. Let's take some deep breaths together. I'll guide you through a calming breathing exercise.",
        "Anxiety can be overwhelming. Let me help you find your center with a gentle breathing meditation.",
        "I understand you're feeling anxious. Let's practice some mindful breathing to help you feel more grounded.",
      ],
      'meditation': [
        "When anxiety strikes, meditation can be a powerful tool. Let me guide you through a calming session.",
        "Let's work through this anxiety together with a soothing meditation practice.",
        "I'll help you find peace with a meditation designed specifically for anxious moments.",
      ],
      'music': [
        "Sometimes music can soothe anxiety better than words. Let me play something calming for you.",
        "I'll find the perfect calming music to help ease your anxiety.",
        "Let's use the power of music to help you feel more at ease.",
      ],
    },
    EmotionalState.stressed: {
      'breathing': [
        "Stress can be exhausting. Let's release some tension with a breathing exercise.",
        "I can see you're stressed. Let me guide you through a stress-relief breathing technique.",
        "When stress builds up, breathing exercises can help. Let's practice together.",
      ],
      'meditation': [
        "Stress relief meditation can help you find your inner peace. Let me guide you.",
        "Let's take a moment to release that stress with a calming meditation.",
        "I'll help you unwind with a meditation designed to reduce stress.",
      ],
      'music': [
        "Stress often responds well to calming music. Let me find something soothing for you.",
        "I'll play some stress-relief music to help you relax.",
        "Let's use music to help you let go of that stress.",
      ],
    },
    EmotionalState.tired: {
      'breathing': [
        "You seem tired. Let's do some energizing breathing exercises to help you feel refreshed.",
        "When you're tired, breathing exercises can help boost your energy naturally.",
        "Let me guide you through some invigorating breaths to help you feel more awake.",
      ],
      'meditation': [
        "Sometimes when we're tired, a gentle meditation can help us feel more refreshed.",
        "Let's do a light meditation to help you feel more energized.",
        "I'll guide you through a meditation that can help with tiredness.",
      ],
      'music': [
        "Tiredness often responds well to gentle, uplifting music. Let me find something for you.",
        "I'll play some music that can help you feel more awake and refreshed.",
        "Let's use music to help you feel more energized.",
      ],
    },
    EmotionalState.happy: {
      'breathing': [
        "It's wonderful that you're feeling happy! Let's enhance that joy with some mindful breathing.",
        "Your happiness is contagious! Let's celebrate it with a joyful breathing practice.",
        "When you're happy, breathing exercises can help you savor that feeling even more.",
      ],
      'meditation': [
        "Your happiness is beautiful! Let's enhance it with a joyful meditation practice.",
        "Let's celebrate your happiness with a meditation that amplifies positive feelings.",
        "I'll guide you through a meditation that celebrates your current happiness.",
      ],
      'music': [
        "Your happiness deserves some uplifting music! Let me find something perfect for you.",
        "I'll play some music that matches your wonderful mood.",
        "Let's enhance your happiness with some joyful music.",
      ],
    },
    EmotionalState.neutral: {
      'breathing': [
        "Let's take a moment to connect with your breath and find your center.",
        "Breathing exercises can help you feel more present and grounded.",
        "Let me guide you through a calming breathing practice.",
      ],
      'meditation': [
        "Meditation can help you find deeper peace and clarity.",
        "Let's take some time to meditate and connect with your inner self.",
        "I'll guide you through a peaceful meditation session.",
      ],
      'music': [
        "Music can help create a peaceful atmosphere for your practice.",
        "Let me find some calming music to enhance your experience.",
        "I'll play some soothing music to help you relax.",
      ],
    },
  };

  // Initialize user context
  Future<void> initializeUserContext(String userId) async {
    try {
      // Simulate loading user context from database
      await Future.delayed(const Duration(milliseconds: 300));
      
      _currentUserContext = UserContext(
        userId: userId,
        currentEmotion: EmotionalState.neutral,
        recentInteractions: [],
        preferenceHistory: {},
        lastSession: DateTime.now(),
        totalSessions: 0,
        preferredLanguage: 'en-US',
        favoriteCategories: ['meditation', 'breathing', 'music'],
      );
    } catch (e) {
      debugPrint('Failed to initialize user context: $e');
    }
  }

  // Analyze emotional state from voice input
  EmotionalAnalysis analyzeEmotion(String voiceInput) {
    final input = voiceInput.toLowerCase();
    final emotionScores = <EmotionalState, double>{};
    
    // Initialize all emotions with neutral score
    for (final emotion in EmotionalState.values) {
      emotionScores[emotion] = 0.0;
    }

    // Analyze keywords and patterns
    if (input.contains('anxious') || input.contains('worry') || input.contains('nervous')) {
      emotionScores[EmotionalState.anxious] = 0.8;
      emotionScores[EmotionalState.stressed] = 0.6;
    }
    
    if (input.contains('stress') || input.contains('overwhelmed') || input.contains('pressure')) {
      emotionScores[EmotionalState.stressed] = 0.9;
      emotionScores[EmotionalState.anxious] = 0.7;
    }
    
    if (input.contains('tired') || input.contains('exhausted') || input.contains('sleepy')) {
      emotionScores[EmotionalState.tired] = 0.8;
      emotionScores[EmotionalState.sad] = 0.4;
    }
    
    if (input.contains('happy') || input.contains('joy') || input.contains('excited')) {
      emotionScores[EmotionalState.happy] = 0.9;
      emotionScores[EmotionalState.excited] = 0.7;
    }
    
    if (input.contains('sad') || input.contains('depressed') || input.contains('down')) {
      emotionScores[EmotionalState.sad] = 0.8;
      emotionScores[EmotionalState.tired] = 0.5;
    }
    
    if (input.contains('focus') || input.contains('concentrate') || input.contains('attention')) {
      emotionScores[EmotionalState.focused] = 0.8;
      emotionScores[EmotionalState.calm] = 0.6;
    }
    
    if (input.contains('calm') || input.contains('peaceful') || input.contains('relaxed')) {
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
    String reasoning = _generateEmotionReasoning(input, primaryEmotion);

    return EmotionalAnalysis(
      primaryEmotion: primaryEmotion,
      emotionScores: emotionScores,
      confidence: maxScore,
      reasoning: reasoning,
    );
  }

  String _generateEmotionReasoning(String input, EmotionalState emotion) {
    switch (emotion) {
      case EmotionalState.anxious:
        return "Detected anxiety-related keywords and patterns in your voice input.";
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
        return "Analyzed voice input for emotional patterns and context.";
    }
  }

  // Generate AI response based on voice input and context
  Future<AIResponse> generateResponse(String voiceInput) async {
    // Analyze emotion
    final emotionalAnalysis = analyzeEmotion(voiceInput);
    
    // Determine action based on input
    final action = _determineAction(voiceInput);
    
    // Generate personalized response
    final response = await _generatePersonalizedResponse(
      voiceInput,
      emotionalAnalysis,
      action,
    );

    // Update user context
    _updateUserContext(voiceInput, action, emotionalAnalysis.primaryEmotion);
    
    // Add to history
    _responseHistory.add(response);
    _actionFrequency[action] = (_actionFrequency[action] ?? 0) + 1;

    return response;
  }

  // Determine action from voice input
  String _determineAction(String voiceInput) {
    final input = voiceInput.toLowerCase();
    
    if (input.contains('breath') || input.contains('inhale') || input.contains('exhale')) {
      return 'breathing';
    }
    
    if (input.contains('meditation') || input.contains('meditate') || input.contains('mindful')) {
      return 'meditation';
    }
    
    if (input.contains('music') || input.contains('song') || input.contains('play')) {
      return 'music';
    }
    
    if (input.contains('sleep') || input.contains('bed') || input.contains('rest')) {
      return 'sleep';
    }
    
    if (input.contains('focus') || input.contains('concentrate') || input.contains('attention')) {
      return 'focus';
    }
    
    if (input.contains('relax') || input.contains('calm') || input.contains('peace')) {
      return 'relaxation';
    }
    
    // Default action based on emotion
    final emotion = analyzeEmotion(voiceInput).primaryEmotion;
    switch (emotion) {
      case EmotionalState.anxious:
      case EmotionalState.stressed:
        return 'breathing';
      case EmotionalState.tired:
        return 'sleep';
      case EmotionalState.happy:
        return 'meditation';
      default:
        return 'meditation';
    }
  }

  // Generate personalized response
  Future<AIResponse> _generatePersonalizedResponse(
    String voiceInput,
    EmotionalAnalysis emotionalAnalysis,
    String action,
  ) async {
    // Get response templates for the emotion and action
    final templates = _responseTemplates[emotionalAnalysis.primaryEmotion]?[action] ?? 
                     _responseTemplates[EmotionalState.neutral]?[action] ?? 
                     ['I understand. Let me help you with that.'];
    
    // Select template based on personalization
    final selectedTemplate = _selectPersonalizedTemplate(templates, voiceInput);
    
    // Personalize the response
    final personalizedText = _personalizeResponse(selectedTemplate, emotionalAnalysis);
    
    // Generate metadata
    final metadata = {
      'originalInput': voiceInput,
      'emotionalAnalysis': {
        'primaryEmotion': emotionalAnalysis.primaryEmotion.toString(),
        'confidence': emotionalAnalysis.confidence,
        'reasoning': emotionalAnalysis.reasoning,
      },
      'userContext': _currentUserContext?.toMap(),
      'actionFrequency': _actionFrequency,
      'responseHistory': _responseHistory.length,
    };

    return AIResponse(
      text: personalizedText,
      action: action,
      suggestedEmotion: emotionalAnalysis.primaryEmotion,
      confidence: emotionalAnalysis.confidence,
      metadata: metadata,
      timestamp: DateTime.now(),
    );
  }

  // Select personalized template
  String _selectPersonalizedTemplate(List<String> templates, String voiceInput) {
    if (templates.isEmpty) return 'I understand. Let me help you with that.';
    
    // Use user preferences if available
    if (_currentUserContext != null) {
      final recentInteractions = _currentUserContext!.recentInteractions;
      
      // Check if user has preferred response patterns
      if (recentInteractions.isNotEmpty) {
        final lastInteraction = recentInteractions.last;
        // Prefer templates that match recent interaction patterns
        for (final template in templates) {
          if (template.toLowerCase().contains(lastInteraction.toLowerCase())) {
            return template;
          }
        }
      }
    }
    
    // Random selection with slight bias towards first template
    final random = math.Random();
    if (random.nextDouble() < 0.6) {
      return templates.first;
    } else {
      return templates[random.nextInt(templates.length)];
    }
  }

  // Personalize response based on user context
  String _personalizeResponse(String template, EmotionalAnalysis emotionalAnalysis) {
    String personalized = template;
    
    // Add emotional acknowledgment
    if (emotionalAnalysis.confidence > 0.7) {
      switch (emotionalAnalysis.primaryEmotion) {
        case EmotionalState.anxious:
          personalized = "I can sense your anxiety. " + personalized;
          break;
        case EmotionalState.stressed:
          personalized = "I understand you're feeling stressed. " + personalized;
          break;
        case EmotionalState.tired:
          personalized = "You seem tired. " + personalized;
          break;
        case EmotionalState.happy:
          personalized = "It's wonderful that you're feeling happy! " + personalized;
          break;
        default:
          break;
      }
    }
    
    // Add personalization based on user context
    if (_currentUserContext != null) {
      if (_currentUserContext!.totalSessions > 10) {
        personalized += " I know you're experienced with meditation, so I'll guide you through something that builds on your practice.";
      } else if (_currentUserContext!.totalSessions > 0) {
        personalized += " I'm here to support your meditation journey.";
      } else {
        personalized += " Welcome to your meditation practice. I'm here to guide you.";
      }
    }
    
    return personalized;
  }

  // Update user context
  void _updateUserContext(String voiceInput, String action, EmotionalState emotion) {
    if (_currentUserContext == null) return;
    
    final updatedContext = UserContext(
      userId: _currentUserContext!.userId,
      currentEmotion: emotion,
      recentInteractions: [..._currentUserContext!.recentInteractions, voiceInput].take(10).toList(),
      preferenceHistory: {
        ..._currentUserContext!.preferenceHistory,
        action: (_currentUserContext!.preferenceHistory[action] ?? 0) + 1,
      },
      lastSession: DateTime.now(),
      totalSessions: _currentUserContext!.totalSessions + 1,
      preferredLanguage: _currentUserContext!.preferredLanguage,
      favoriteCategories: _currentUserContext!.favoriteCategories,
    );
    
    _currentUserContext = updatedContext;
  }

  // Get user preferences
  Map<String, dynamic> getUserPreferences() {
    if (_currentUserContext == null) return {};
    
    return {
      'favoriteActions': _getTopActions(3),
      'emotionalTrends': _getEmotionalTrends(),
      'sessionStats': {
        'totalSessions': _currentUserContext!.totalSessions,
        'lastSession': _currentUserContext!.lastSession,
        'preferredLanguage': _currentUserContext!.preferredLanguage,
      },
      'recentInteractions': _currentUserContext!.recentInteractions,
    };
  }

  // Get top actions by frequency
  List<String> _getTopActions(int count) {
    final sortedActions = _actionFrequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sortedActions.take(count).map((e) => e.key).toList();
  }

  // Get emotional trends
  Map<String, dynamic> _getEmotionalTrends() {
    final emotionCounts = <EmotionalState, int>{};
    
    for (final response in _responseHistory) {
      emotionCounts[response.suggestedEmotion] = 
          (emotionCounts[response.suggestedEmotion] ?? 0) + 1;
    }
    
    return emotionCounts.map((key, value) => MapEntry(key.toString(), value));
  }

  // Get response history
  List<AIResponse> getResponseHistory() {
    return List.from(_responseHistory);
  }

  // Clear response history
  void clearResponseHistory() {
    _responseHistory.clear();
    _actionFrequency.clear();
  }

  // Get current user context
  UserContext? getCurrentUserContext() {
    return _currentUserContext;
  }
}

// AI Response Controller for GetX integration
class AIResponseController extends GetxController {
  final AIResponseService _aiService = AIResponseService.instance;
  
  final Rx<AIResponse?> currentResponse = Rx<AIResponse?>(null);
  final Rx<EmotionalAnalysis?> currentEmotion = Rx<EmotionalAnalysis?>(null);
  final RxBool isProcessing = false.obs;
  final RxList<AIResponse> responseHistory = <AIResponse>[].obs;
  final RxMap<String, dynamic> userPreferences = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeService();
  }

  Future<void> _initializeService() async {
    await _aiService.initializeUserContext('user_${DateTime.now().millisecondsSinceEpoch}');
    _loadUserPreferences();
  }

  Future<void> processVoiceInput(String voiceInput) async {
    isProcessing.value = true;
    
    try {
      // Analyze emotion
      final emotionalAnalysis = _aiService.analyzeEmotion(voiceInput);
      currentEmotion.value = emotionalAnalysis;
      
      // Generate response
      final response = await _aiService.generateResponse(voiceInput);
      currentResponse.value = response;
      
      // Update history
      responseHistory.add(response);
      
      // Update preferences
      _loadUserPreferences();
      
    } catch (e) {
      Get.snackbar(
        'AI Response Error',
        'Failed to process your request: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isProcessing.value = false;
    }
  }

  void _loadUserPreferences() {
    userPreferences.value = _aiService.getUserPreferences();
  }

  void clearHistory() {
    _aiService.clearResponseHistory();
    responseHistory.clear();
    currentResponse.value = null;
    currentEmotion.value = null;
    _loadUserPreferences();
  }

  EmotionalAnalysis analyzeEmotion(String text) {
    return _aiService.analyzeEmotion(text);
  }

  List<AIResponse> getResponseHistory() {
    return _aiService.getResponseHistory();
  }

  UserContext? getCurrentUserContext() {
    return _aiService.getCurrentUserContext();
  }
} 