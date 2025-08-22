import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../data/models/content_model.dart';
import '../../../widgets/interactive_feedback.dart';
import 'content_detail_screen.dart';

class AIRecommendationsEnhancedScreen extends StatefulWidget {
  const AIRecommendationsEnhancedScreen({Key? key}) : super(key: key);

  @override
  State<AIRecommendationsEnhancedScreen> createState() => _AIRecommendationsEnhancedScreenState();
}

class _AIRecommendationsEnhancedScreenState extends State<AIRecommendationsEnhancedScreen>
    with TickerProviderStateMixin {
  late AnimationController _loadingController;
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late Animation<double> _loadingAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  bool _isAnalyzing = false;
  bool _isGenerating = false;
  bool _showRecommendations = false;
  bool _showMoodSelector = false;
  bool _showPersonalizedContent = false;
  
  String _currentAnalysis = '';
  String _userMood = '😊';
  String _userMoodText = 'Happy';
  double _analysisProgress = 0.0;
  
  List<Map<String, dynamic>> _recommendations = [];
  List<Map<String, dynamic>> _personalizedContent = [];
  Map<String, dynamic> _userProfile = {};

  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAIAnalysis();
  }

  void _initializeAnimations() {
    _loadingController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _loadingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _loadingController, curve: Curves.easeInOut),
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _pulseController.repeat(reverse: true);
  }

  void _startAIAnalysis() async {
    setState(() {
      _isAnalyzing = true;
      _analysisProgress = 0.0;
    });

    _loadingController.forward();

    // Simulate AI analysis steps
    final analysisSteps = [
      "Analyzing your meditation patterns...",
      "Processing your emotional state...",
      "Learning from your preferences...",
      "Identifying your stress triggers...",
      "Understanding your sleep patterns...",
      "Mapping your relaxation preferences...",
      "Generating personalized insights...",
    ];

    for (int i = 0; i < analysisSteps.length; i++) {
      await Future.delayed(Duration(milliseconds: 800 + _random.nextInt(400)));
      setState(() {
        _currentAnalysis = analysisSteps[i];
        _analysisProgress = (i + 1) / analysisSteps.length;
      });
    }

    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      _isAnalyzing = false;
      _showMoodSelector = true;
    });

    _fadeController.forward();
  }

  void _selectMood(String mood, String moodText) {
    setState(() {
      _userMood = mood;
      _userMoodText = moodText;
      _showMoodSelector = false;
      _isGenerating = true;
    });

    _generatePersonalizedRecommendations();
  }

  void _generatePersonalizedRecommendations() async {
    // Simulate AI generation
    await Future.delayed(const Duration(seconds: 2));

    // Generate personalized user profile
    _userProfile = {
      'mood': _userMoodText,
      'stressLevel': _random.nextInt(5) + 1,
      'sleepQuality': _random.nextInt(3) + 1,
      'meditationStreak': _random.nextInt(30) + 1,
      'preferredDuration': ['5 min', '10 min', '15 min', '20 min'][_random.nextInt(4)],
      'favoriteCategories': _getFavoriteCategories(),
      'lastSession': DateTime.now().subtract(Duration(hours: _random.nextInt(24))),
    };

    // Generate recommendations based on mood
    _recommendations = _getRecommendationsForMood(_userMoodText);
    
    // Generate personalized content
    _personalizedContent = _generatePersonalizedContent();

    setState(() {
      _isGenerating = false;
      _showRecommendations = true;
      _showPersonalizedContent = true;
    });
  }

  List<String> _getFavoriteCategories() {
    final categories = ['meditation', 'breathing', 'sleep', 'relaxation', 'focus', 'anxiety'];
    categories.shuffle();
    return categories.take(3).toList();
  }

  List<Map<String, dynamic>> _getRecommendationsForMood(String mood) {
    final Map<String, List<Map<String, dynamic>>> moodRecommendations = {
      'Happy': [
        {'title': 'Joyful Meditation', 'subtitle': 'Celebrate your happiness', 'icon': Icons.sentiment_very_satisfied, 'color': Colors.green},
        {'title': 'Gratitude Practice', 'subtitle': 'Amplify positive feelings', 'icon': Icons.favorite, 'color': Colors.pink},
        {'title': 'Energizing Flow', 'subtitle': 'Channel your positive energy', 'icon': Icons.bolt, 'color': Colors.yellow},
        {'title': 'Mindful Celebration', 'subtitle': 'Savor this moment', 'icon': Icons.celebration, 'color': Colors.orange},
      ],
      'Stressed': [
        {'title': 'Stress Relief Breathing', 'subtitle': 'Release tension instantly', 'icon': Icons.air, 'color': Colors.blue},
        {'title': 'Progressive Relaxation', 'subtitle': 'Unwind muscle by muscle', 'icon': Icons.spa, 'color': Colors.teal},
        {'title': 'Calm Mind Meditation', 'subtitle': 'Find inner peace', 'icon': Icons.self_improvement, 'color': Colors.indigo},
        {'title': 'Nature Sounds', 'subtitle': 'Soothing ambient sounds', 'icon': Icons.nature, 'color': Colors.green},
      ],
      'Anxious': [
        {'title': 'Anxiety Relief Session', 'subtitle': 'Ease your worries', 'icon': Icons.psychology, 'color': Colors.purple},
        {'title': 'Grounding Exercise', 'subtitle': 'Find your center', 'icon': Icons.center_focus_strong, 'color': Colors.brown},
        {'title': 'Gentle Breathing', 'subtitle': 'Calm your nervous system', 'icon': Icons.favorite_border, 'color': Colors.pink},
        {'title': 'Safe Space Meditation', 'subtitle': 'Create inner sanctuary', 'icon': Icons.home, 'color': Colors.orange},
      ],
      'Tired': [
        {'title': 'Energy Boost', 'subtitle': 'Revitalize your body', 'icon': Icons.flash_on, 'color': Colors.yellow},
        {'title': 'Mindful Stretching', 'subtitle': 'Wake up gently', 'icon': Icons.fitness_center, 'color': Colors.green},
        {'title': 'Focus Enhancement', 'subtitle': 'Sharpen your mind', 'icon': Icons.psychology, 'color': Colors.blue},
        {'title': 'Power Nap Guide', 'subtitle': 'Quick energy restoration', 'icon': Icons.bedtime, 'color': Colors.indigo},
      ],
      'Sad': [
        {'title': 'Compassion Meditation', 'subtitle': 'Be kind to yourself', 'icon': Icons.favorite, 'color': Colors.pink},
        {'title': 'Emotional Healing', 'subtitle': 'Process your feelings', 'icon': Icons.healing, 'color': Colors.green},
        {'title': 'Loving-Kindness', 'subtitle': 'Send positive energy', 'icon': Icons.volunteer_activism, 'color': Colors.red},
        {'title': 'Gentle Self-Care', 'subtitle': 'Nurture your soul', 'icon': Icons.spa, 'color': Colors.teal},
      ],
    };

    return moodRecommendations[mood] ?? moodRecommendations['Happy']!;
  }

  List<Map<String, dynamic>> _generatePersonalizedContent() {
    final content = [
      {
        'title': 'AI Personalized Session',
        'subtitle': 'Tailored for your current state',
        'duration': '${_userProfile['preferredDuration']}',
        'image': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?auto=format&fit=crop&w=400&q=80',
        'rating': 4.8,
        'plays': _random.nextInt(1000) + 500,
        'isNew': true,
      },
      {
        'title': 'Mood-Based Meditation',
        'subtitle': 'Designed for ${_userMoodText.toLowerCase()} moments',
        'duration': '10 min',
        'image': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?auto=format&fit=crop&w=400&q=80',
        'rating': 4.6,
        'plays': _random.nextInt(800) + 300,
        'isNew': false,
      },
      {
        'title': 'Stress Relief Protocol',
        'subtitle': 'Based on your stress patterns',
        'duration': '15 min',
        'image': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?auto=format&fit=crop&w=400&q=80',
        'rating': 4.7,
        'plays': _random.nextInt(600) + 200,
        'isNew': true,
      },
    ];

    return content;
  }

  void _refreshRecommendations() async {
    setState(() {
      _isGenerating = true;
      _showRecommendations = false;
    });

    await Future.delayed(const Duration(seconds: 2));

    // Generate new recommendations
    _recommendations = _getRecommendationsForMood(_userMoodText);
    _personalizedContent = _generatePersonalizedContent();

    setState(() {
      _isGenerating = false;
      _showRecommendations = true;
    });

    Get.snackbar(
      'Recommendations Updated',
      'Fresh AI-powered suggestions for you!',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }

  @override
  void dispose() {
    _loadingController.dispose();
    _pulseController.dispose();
    _fadeController.dispose();
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
              child: _buildContent(),
            ),
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
                  'AI Recommendations',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _isAnalyzing ? 'Analyzing...' : 'Personalized for you',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          if (_showRecommendations)
            IconButton(
              onPressed: _refreshRecommendations,
              icon: Icon(
                _isGenerating ? Icons.hourglass_empty : Icons.refresh,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          // AI Analysis Section
          if (_isAnalyzing) _buildAnalysisSection(),
          
          // Mood Selector
          if (_showMoodSelector) _buildMoodSelector(),
          
          // User Profile
          if (_showPersonalizedContent) _buildUserProfile(),
          
          // Recommendations
          if (_showRecommendations) ...[
            _buildRecommendationsSection(),
            SizedBox(height: 24.h),
            _buildPersonalizedContentSection(),
          ],
          
          // Generating indicator
          if (_isGenerating) _buildGeneratingSection(),
        ],
      ),
    );
  }

  Widget _buildAnalysisSection() {
    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _loadingAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _loadingAnimation.value * 2 * 3.14159,
                child: Icon(
                  Icons.psychology,
                  color: Colors.blue,
                  size: 40.sp,
                ),
              );
            },
          ),
          SizedBox(height: 16.h),
          Text(
            _currentAnalysis,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          LinearProgressIndicator(
            value: _analysisProgress,
            backgroundColor: Colors.white.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          SizedBox(height: 8.h),
          Text(
            '${(_analysisProgress * 100).toInt()}% Complete',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodSelector() {
    final moods = [
      {'emoji': '😊', 'text': 'Happy'},
      {'emoji': '😔', 'text': 'Sad'},
      {'emoji': '😌', 'text': 'Relaxed'},
      {'emoji': '😡', 'text': 'Stressed'},
      {'emoji': '😴', 'text': 'Tired'},
      {'emoji': '😰', 'text': 'Anxious'},
    ];

    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Container(
            margin: EdgeInsets.only(bottom: 24.h),
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Text(
                  'How are you feeling today?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.h),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,
                  ),
                  itemCount: moods.length,
                  itemBuilder: (context, index) {
                    final mood = moods[index];
                    return GestureDetector(
                      onTap: () => _selectMood(mood['emoji']!, mood['text']!),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              mood['emoji']!,
                              style: TextStyle(fontSize: 32.sp),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              mood['text']!,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserProfile() {
    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.withOpacity(0.3),
            Colors.purple.withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                _userMood,
                style: TextStyle(fontSize: 24.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your AI Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Mood: $_userMoodText • ${_userProfile['preferredDuration']} sessions',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              _buildProfileStat('Stress Level', _userProfile['stressLevel'], 5),
              SizedBox(width: 16.w),
              _buildProfileStat('Sleep Quality', _userProfile['sleepQuality'], 3),
              SizedBox(width: 16.w),
              _buildProfileStat('Meditation Streak', _userProfile['meditationStreak'], 30),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileStat(String label, int value, int max) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 10.sp,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '$value',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.psychology, color: Colors.blue, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              'AI Recommendations',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        ...List.generate(_recommendations.length, (index) {
          final recommendation = _recommendations[index];
          return GestureDetector(
            onTap: () => _startRecommendation(recommendation),
            child: Container(
              margin: EdgeInsets.only(bottom: 12.h),
              padding: EdgeInsets.all(16.w),
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
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: (recommendation['color'] as Color).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      recommendation['icon'] as IconData,
                      color: recommendation['color'] as Color,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recommendation['title'] as String,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          recommendation['subtitle'] as String,
                          style: TextStyle(
                            color: Colors.white70,
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
          );
        }),
      ],
    );
  }

  Widget _buildPersonalizedContentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personalized Content',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 200.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _personalizedContent.length,
            itemBuilder: (context, index) {
              final content = _personalizedContent[index];
              return Container(
                width: 160.w,
                margin: EdgeInsets.only(right: 12.w),
                child: GestureDetector(
                  onTap: () => _openContent(content),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              content['image'] as String,
                              width: 160.w,
                              height: 120.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                          if (content['isNew'] as bool)
                            Positioned(
                              top: 8.h,
                              left: 8.w,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'NEW',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        content['title'] as String,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        content['subtitle'] as String,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(Icons.access_time, color: Colors.white70, size: 12.sp),
                          SizedBox(width: 4.w),
                          Text(
                            content['duration'] as String,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12.sp,
                            ),
                          ),
                          const Spacer(),
                          Icon(Icons.star, color: Colors.yellow, size: 12.sp),
                          SizedBox(width: 4.w),
                          Text(
                            '${content['rating']}',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGeneratingSection() {
    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 40.w,
            height: 40.w,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Generating personalized recommendations...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _startRecommendation(Map<String, dynamic> recommendation) {
    HapticFeedbackHelper.lightImpact();
    Get.snackbar(
      'Starting Session',
      '${recommendation['title']} session is beginning...',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }

  void _openContent(Map<String, dynamic> content) {
    final contentModel = ContentModel(
      id: 'ai-content-${DateTime.now().millisecondsSinceEpoch}',
      title: content['title'] as String,
      subtitle: content['subtitle'] as String,
      description: 'AI-generated personalized content based on your preferences and current state.',
      imageUrl: content['image'] as String,
      audioUrl: '',
      category: 'ai_personalized',
      tags: ['ai', 'personalized', _userMoodText.toLowerCase()],
      duration: _parseDuration(content['duration'] as String),
      author: 'AI Assistant',
      rating: content['rating'] as double,
      playCount: content['plays'] as int,
      isPremium: false,
      createdAt: DateTime.now(),
    );

    Get.to(() => ContentDetailScreen(
      contentId: contentModel.id,
      content: contentModel,
    ));
  }

  int _parseDuration(String duration) {
    final minutes = int.tryParse(duration.replaceAll(' min', '')) ?? 10;
    return minutes * 60; // Convert to seconds
  }
} 