import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../widgets/theme_aware_components.dart';
import '../../../widgets/interactive_feedback.dart';
import '../../../core/controllers/theme_controller.dart';
import '../../../components/voice_input_widget.dart';
import '../../../services/ai_response_service.dart';
import '../../../services/tts_service.dart';
import '../../../core/error/error_handler.dart';
import '../../../core/performance/performance_optimizer.dart';
import 'dart:async';

// Message model for conversation
class ConversationMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final EmotionalState? emotion;
  final String? action;
  final double? confidence;

  ConversationMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.emotion,
    this.action,
    this.confidence,
  });
}

class WhisprModeScreen extends StatefulWidget {
  const WhisprModeScreen({Key? key}) : super(key: key);

  @override
  State<WhisprModeScreen> createState() => _WhisprModeScreenState();
}

class _WhisprModeScreenState extends State<WhisprModeScreen>
    with TickerProviderStateMixin, ErrorHandlingMixin, PerformanceMonitoringMixin {
  final List<ConversationMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  
  // Services
  final AIResponseService _aiService = AIResponseService.instance;
  final TTSService _ttsService = TTSService.instance;
  
  // State management
  bool _isProcessing = false;
  bool _showSettings = false;
  bool _autoSpeak = true;
  String _selectedVoice = 'en-US-1';
  double _speechSpeed = 1.0;
  
  // Animation controllers
  late AnimationController _pulseController;
  late AnimationController _settingsController;
  late Animation<double> _settingsAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _addWelcomeMessage();
    _initializeServices();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _settingsController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _settingsAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _settingsController,
      curve: Curves.easeInOut,
    ));
  }

  void _addWelcomeMessage() {
    _addMessage(
      'Hello! I\'m your AI meditation assistant. You can speak to me naturally, and I\'ll help you with meditation, breathing exercises, music, and more. How are you feeling today?',
      false,
      emotion: EmotionalState.neutral,
      action: 'welcome',
    );
  }

  void _initializeServices() async {
    await safeAsync(
      () async {
        await _aiService.initializeUserContext('user_${DateTime.now().millisecondsSinceEpoch}');
        await _ttsService.initialize();
      },
      loadingKey: 'services',
      loadingMessage: 'Initializing services...',
      errorType: ErrorType.server,
      errorSeverity: ErrorSeverity.medium,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _settingsController.dispose();
    _scrollController.dispose();
    _textController.dispose();
    _ttsService.dispose();
    super.dispose();
  }

  void _addMessage(
    String text,
    bool isUser, {
    EmotionalState? emotion,
    String? action,
    double? confidence,
  }) {
    final message = ConversationMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isUser: isUser,
      timestamp: DateTime.now(),
      emotion: emotion,
      action: action,
      confidence: confidence,
    );

    setState(() {
      _messages.add(message);
    });

    _scrollToBottom();

    // Auto-speak AI responses
    if (!isUser && _autoSpeak) {
      _speakText(text);
    }
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

  void _handleVoiceInput(String text) {
    if (text.trim().isEmpty) return;

    _addMessage(text, true);
    _processUserInput(text);
  }

  void _handleAIResponse(AIResponse response) {
    _addMessage(
      response.text,
      false,
      emotion: response.suggestedEmotion,
      action: response.action,
      confidence: response.confidence,
    );
  }

  void _handleVoiceError(String error) {
    _addMessage('Sorry, I couldn\'t understand that. Could you please try again?', false);
  }

  Future<void> _processUserInput(String text) async {
    await safeAsync(
      () async {
        setState(() {
          _isProcessing = true;
        });

        final response = await _aiService.generateResponse(text);
        _handleAIResponse(response);
      },
      loadingKey: 'processing',
      loadingMessage: 'Processing your request...',
      errorType: ErrorType.server,
      errorSeverity: ErrorSeverity.medium,
      fallbackValue: null,
    ).then((_) {
      setState(() {
        _isProcessing = false;
      });
    });
  }

  Future<void> _speakText(String text) async {
    try {
      await _ttsService.speak(
        text,
        voice: _selectedVoice,
        speed: _speechSpeed,
      );
    } catch (e) {
      // Handle TTS error silently
    }
  }

  void _toggleSettings() {
    setState(() {
      _showSettings = !_showSettings;
    });

    if (_showSettings) {
      _settingsController.forward();
    } else {
      _settingsController.reverse();
    }
  }

  void _clearConversation() {
    setState(() {
      _messages.clear();
    });
    _addWelcomeMessage();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    
    // Check offline status
    if (isOffline) {
      return _buildOfflineView(themeController);
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.psychology,
              color: Colors.white,
              size: 24.sp,
            ),
            SizedBox(width: 8.w),
            const Text('Whispr Mode'),
          ],
        ),
        backgroundColor: themeController.getPrimaryColor(),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_showSettings ? Icons.close : Icons.settings),
            onPressed: _toggleSettings,
          ),
        ],
      ),
      body: ThemeAwareContainer(
        useGradient: true,
        child: Column(
          children: [
            // Settings Panel
            if (_showSettings)
              AnimatedBuilder(
                animation: _settingsAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _settingsAnimation.value,
                    child: _buildSettingsPanel(themeController),
                  );
                },
              ),

            // Conversation Area
            Expanded(
              child: _buildConversationArea(themeController),
            ),

            // Voice Input Area
            _buildVoiceInputArea(themeController),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsPanel(ThemeController themeController) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.settings,
                color: Colors.white,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              ThemeAwareText(
                'Whispr Mode Settings',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Auto-speak toggle
          Row(
            children: [
              Icon(
                Icons.volume_up,
                color: Colors.white70,
                size: 18.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: ThemeAwareText(
                  'Auto-speak responses',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                  ),
                ),
              ),
              Switch(
                value: _autoSpeak,
                onChanged: (value) {
                  setState(() {
                    _autoSpeak = value;
                  });
                },
                activeColor: themeController.getPrimaryColor(),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Voice selection
          Row(
            children: [
              Icon(
                Icons.record_voice_over,
                color: Colors.white70,
                size: 18.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: ThemeAwareText(
                  'Voice',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: DropdownButton<String>(
                  value: _selectedVoice,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedVoice = value;
                      });
                    }
                  },
                  dropdownColor: themeController.getSurfaceColor(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                  ),
                  underline: const SizedBox(),
                  items: [
                    DropdownMenuItem(
                      value: 'en-US-1',
                      child: Text('Emma (US)'),
                    ),
                    DropdownMenuItem(
                      value: 'en-US-2',
                      child: Text('James (US)'),
                    ),
                    DropdownMenuItem(
                      value: 'en-GB-1',
                      child: Text('Sophie (UK)'),
                    ),
                    DropdownMenuItem(
                      value: 'en-GB-2',
                      child: Text('Oliver (UK)'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Speech speed
          Row(
            children: [
              Icon(
                Icons.speed,
                color: Colors.white70,
                size: 18.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: ThemeAwareText(
                  'Speech Speed',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                '${(_speechSpeed * 100).round()}%',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          Slider(
            value: _speechSpeed,
            min: 0.5,
            max: 2.0,
            divisions: 15,
            onChanged: (value) {
              setState(() {
                _speechSpeed = value;
              });
            },
            activeColor: themeController.getPrimaryColor(),
            inactiveColor: Colors.white.withOpacity(0.3),
          ),
          SizedBox(height: 12.h),

          // Clear conversation button
          SizedBox(
            width: double.infinity,
            child: AnimatedButton(
              onPressed: _clearConversation,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.clear_all,
                      color: Colors.white,
                      size: 16.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Clear Conversation',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationArea(ThemeController themeController) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          final message = _messages[index];
          return _buildMessageBubble(message, themeController);
        },
      ),
    );
  }

  Widget _buildMessageBubble(ConversationMessage message, ThemeController themeController) {
    final isUser = message.isUser;
    
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16.sp,
              backgroundColor: Colors.purple.withOpacity(0.8),
              child: Icon(
                Icons.psychology,
                color: Colors.white,
                size: 16.sp,
              ),
            ),
            SizedBox(width: 8.w),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: isUser 
                    ? themeController.getPrimaryColor().withOpacity(0.8)
                    : Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isUser 
                      ? Colors.transparent
                      : Colors.white.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Text(
                        _formatTime(message.timestamp),
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10.sp,
                        ),
                      ),
                      if (!isUser && message.emotion != null) ...[
                        SizedBox(width: 8.w),
                        Icon(
                          _getEmotionIcon(message.emotion!),
                          color: Colors.white70,
                          size: 12.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          message.emotion.toString().split('.').last,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            SizedBox(width: 8.w),
            CircleAvatar(
              radius: 16.sp,
              backgroundColor: themeController.getPrimaryColor(),
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 16.sp,
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getEmotionIcon(EmotionalState emotion) {
    switch (emotion) {
      case EmotionalState.happy:
        return Icons.sentiment_satisfied;
      case EmotionalState.sad:
        return Icons.sentiment_dissatisfied;
      case EmotionalState.anxious:
        return Icons.sentiment_very_dissatisfied;
      case EmotionalState.stressed:
        return Icons.sentiment_neutral;
      case EmotionalState.calm:
        return Icons.sentiment_satisfied_alt;
      case EmotionalState.excited:
        return Icons.sentiment_very_satisfied;
      case EmotionalState.tired:
        return Icons.sentiment_neutral;
      case EmotionalState.focused:
        return Icons.sentiment_satisfied;
      case EmotionalState.relaxed:
        return Icons.sentiment_satisfied_alt;
      default:
        return Icons.sentiment_neutral;
    }
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }

  Widget _buildOfflineView(ThemeController themeController) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.psychology,
              color: Colors.white,
              size: 24.sp,
            ),
            SizedBox(width: 8.w),
            const Text('Whispr Mode'),
          ],
        ),
        backgroundColor: themeController.getPrimaryColor(),
        foregroundColor: Colors.white,
      ),
      body: ThemeAwareContainer(
        useGradient: true,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.wifi_off,
                  size: 64.sp,
                  color: Colors.white70,
                ),
                SizedBox(height: 16.h),
                ThemeAwareText(
                  'You\'re Offline',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.h),
                ThemeAwareText(
                  'Please check your internet connection and try again.',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),
                AnimatedButton(
                  onPressed: () {
                    setState(() {});
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.refresh,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Retry',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVoiceInputArea(ThemeController themeController) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
      ),
      child: Column(
        children: [
          // Processing indicator
          if (_isProcessing || isLoading('processing') || isLoading('services'))
            Container(
              padding: EdgeInsets.all(12.w),
              margin: EdgeInsets.only(bottom: 12.h),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.orange.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 16.sp,
                    height: 16.sp,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    getLoadingMessage('processing') ?? 
                    getLoadingMessage('services') ?? 
                    'Processing your request...',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),

          // Voice input widget
          VoiceInputWidget(
            onVoiceInput: _handleVoiceInput,
            onError: _handleVoiceError,
            onAIResponse: _handleAIResponse,
            maxRecordingDuration: const Duration(seconds: 30),
            showVisualization: true,
            placeholderText: 'Tap to speak with your AI assistant',
          ),
        ],
      ),
    );
  }
} 