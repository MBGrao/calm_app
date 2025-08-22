import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../modules/home/views/breathing_exercise_screen.dart';
import '../modules/home/views/relaxation_exercise_screen.dart';
import '../modules/home/views/mood_checkin_flow.dart';
import '../screens/meditation_player_screen.dart';
import '../widgets/interactive_feedback.dart';
import '../data/models/content_model.dart';
import '../modules/home/views/ai_assistant_screen.dart';
import '../modules/home/views/simple_ai_assistant_screen.dart';
import '../modules/home/views/ai_recommendations_enhanced_screen.dart';
import '../modules/home/views/ai_voice_assistant_screen.dart';
import '../routes/app_pages.dart';
import 'dart:developer' as developer;

class AIAssistantButton extends StatefulWidget {
  const AIAssistantButton({Key? key}) : super(key: key);

  @override
  State<AIAssistantButton> createState() => _AIAssistantButtonState();
}

class _AIAssistantButtonState extends State<AIAssistantButton> {
  bool _isModalOpen = false;

  // Dummy suggestions - in a real app, these would come from an AI service
  final List<Map<String, dynamic>> _suggestions = [
    {
      'title': 'AI Chat Assistant',
      'subtitle': 'Talk to your AI companion',
      'icon': Icons.chat,
      'action': 'ai_chat',
      'color': Colors.blue,
    },
    {
      'title': 'AI Recommendations',
      'subtitle': 'Get personalized suggestions',
      'icon': Icons.psychology,
      'action': 'ai_recommendations',
      'color': Colors.purple,
    },
    {
      'title': 'Voice AI Assistant',
      'subtitle': 'Speak with your AI',
      'icon': Icons.mic,
      'action': 'ai_voice',
      'color': Colors.green,
    },
    {
      'title': 'Feeling tired?',
      'subtitle': 'Try this 5-minute breathing exercise',
      'icon': Icons.self_improvement,
      'action': 'breathing',
      'color': Colors.orange,
    },
    {
      'title': 'Sleep quality dropped',
      'subtitle': 'Want to log your mood?',
      'icon': Icons.bedtime,
      'action': 'mood_log',
      'color': Colors.indigo,
    },
    {
      'title': 'Stress level high',
      'subtitle': 'Start a quick meditation session',
      'icon': Icons.spa,
      'action': 'meditation',
      'color': Colors.teal,
    },
    {
      'title': 'Anxiety rising',
      'subtitle': 'Try progressive muscle relaxation',
      'icon': Icons.fitness_center,
      'action': 'relaxation',
      'color': Colors.pink,
    },
  ];

  void _showSuggestionsModal() {
    developer.log('🎯 AI Button tapped - Opening modal', name: 'AIAssistantButton');
    HapticFeedbackHelper.lightImpact();
    setState(() {
      _isModalOpen = true;
    });

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildSuggestionsModal(),
    ).then((_) {
      setState(() {
        _isModalOpen = false;
      });
    });
  }

  Widget _buildSuggestionsModal() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Color(0xFF1B4B6F),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 8.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: 24.r,
                  child: Icon(Icons.psychology, color: Colors.white, size: 24.sp),
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
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Personalized suggestions for you',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white, size: 24.sp),
                  onPressed: () {
                    HapticFeedbackHelper.lightImpact();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          // Suggestions list
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: _suggestions.length,
              itemBuilder: (context, index) {
                final suggestion = _suggestions[index];
                return _buildSuggestionCard(suggestion);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionCard(Map<String, dynamic> suggestion) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      color: Colors.white.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          developer.log('🎯 Suggestion tapped: ${suggestion['title']}', name: 'AIAssistantButton');
          _handleSuggestionAction(suggestion['action']);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: (suggestion['color'] as Color).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  suggestion['icon'] as IconData,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      suggestion['title'] as String,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      suggestion['subtitle'] as String,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
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
      ),
    );
  }

  void _handleSuggestionAction(String action) {
    developer.log('🎯 Handling action: $action', name: 'AIAssistantButton');
    HapticFeedbackHelper.mediumImpact();
    
    // Close the modal first
    Navigator.pop(context);
    
    // Handle different actions based on the suggestion
    switch (action) {
      case 'ai_chat':
        developer.log('🎯 Navigating to AI Chat Assistant', name: 'AIAssistantButton');
        try {
          // Use GetX navigation instead of Navigator.push
          developer.log('🎯 Navigating to Simple AI Assistant using GetX', name: 'AIAssistantButton');
          Get.toNamed(AppRoutes.simpleAiAssistant);
        } catch (e) {
          developer.log('🎯 Exception navigating to Simple AI Chat Assistant: $e', name: 'AIAssistantButton');
          // Fallback to direct navigation
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const SimpleAIAssistantScreen(),
            ),
          );
        }
        break;
      case 'ai_recommendations':
        developer.log('🎯 Navigating to AI Recommendations', name: 'AIAssistantButton');
        try {
          Get.toNamed(AppRoutes.aiRecommendationsEnhanced);
        } catch (e) {
          developer.log('🎯 Exception navigating to AI Recommendations: $e', name: 'AIAssistantButton');
          // Fallback to direct navigation
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AIRecommendationsEnhancedScreen(),
            ),
          );
        }
        break;
      case 'ai_voice':
        developer.log('🎯 Navigating to AI Voice Assistant', name: 'AIAssistantButton');
        try {
          Get.toNamed(AppRoutes.aiVoiceAssistant);
        } catch (e) {
          developer.log('🎯 Exception navigating to AI Voice Assistant: $e', name: 'AIAssistantButton');
          // Fallback to direct navigation
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AIVoiceAssistantScreen(),
            ),
          );
        }
        break;
      case 'breathing':
        developer.log('🎯 Navigating to Breathing Exercise', name: 'AIAssistantButton');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const BreathingExerciseScreen(),
          ),
        );
        break;
      case 'mood_log':
        developer.log('🎯 Navigating to Mood Check In', name: 'AIAssistantButton');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const MoodCheckInFlow(),
          ),
        );
        break;
      case 'meditation':
        developer.log('🎯 Navigating to Meditation Player', name: 'AIAssistantButton');
        // Create a sample content for meditation
        final sampleContent = ContentModel(
          id: 'ai-meditation-1',
          title: 'AI Guided Meditation',
          subtitle: 'Personalized meditation session',
          description: 'A calming meditation session guided by AI.',
          imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?auto=format&fit=crop&w=800&q=80',
          audioUrl: '',
          category: 'meditation',
          tags: ['ai', 'guided', 'calm'],
          duration: 600,
          author: 'AI Assistant',
          rating: 4.8,
          playCount: 500,
          isPremium: false,
          createdAt: DateTime.now(),
        );
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MeditationPlayerScreen(
              content: sampleContent,
            ),
          ),
        );
        break;
      case 'relaxation':
        developer.log('🎯 Navigating to Relaxation Exercise', name: 'AIAssistantButton');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const RelaxationExerciseScreen(),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _showSuggestionsModal,
      backgroundColor: Colors.blue,
      elevation: 8,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Icon(
          _isModalOpen ? Icons.close : Icons.psychology,
          key: ValueKey<bool>(_isModalOpen),
          size: 24.sp,
        ),
      ),
    );
  }
} 