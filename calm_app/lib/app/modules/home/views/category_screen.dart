import 'package:calm_app/app/screens/meditation_player_screen.dart';
import 'package:calm_app/app/components/ai_assistant_button.dart';
import 'package:calm_app/app/widgets/interactive_feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../screens/meditation_screen.dart';
import 'content_detail_screen.dart';
import '../../../data/models/content_model.dart';

class CategoryScreen extends StatefulWidget {
  final String category;
  final bool isSelected;

  const CategoryScreen({
    Key? key,
    required this.category,
    this.isSelected = false,
  }) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String _selectedFilter = 'All';
  bool _isLoading = false;

  final Map<String, List<String>> _filterOptions = {
    'meditation': ['All', 'Breathing', 'Mindfulness', 'Guided', 'Body Scan'],
    'sleep': ['All', 'Stories', 'Music', 'Nature', 'White Noise'],
    'music': ['All', 'Piano', 'Nature', 'Ambient', 'Classical'],
  };

  @override
  Widget build(BuildContext context) {
    // If meditation, render directly to avoid ListView infinite height error
    if (widget.category.toLowerCase() == 'meditation') {
      return Scaffold(
        backgroundColor: const Color(0xFF1B4B6F),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1B4B6F),
          title: Text(
            widget.category,
            style: const TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Stack(
          children: [
            const MeditationScreen(),
            const AIAssistantButton(),
          ],
        ),
      );
    }
    // Default: use ListView for other categories
    return Scaffold(
      backgroundColor: const Color(0xFF1B4B6F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B4B6F),
        title: Text(
          widget.category,
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {
              _showFilterDialog();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.all(16.w),
            children: [
              // Category description
              _buildCategoryDescription(),
              SizedBox(height: 20.h),
              // Filter chips
              _buildFilterChips(),
              SizedBox(height: 20.h),
              // Content based on category
              _buildCategoryContent(),
            ],
          ),
          const AIAssistantButton(),
        ],
      ),
    );
  }

  Widget _buildCategoryDescription() {
    final descriptions = {
      'meditation': 'Find inner peace through guided meditation sessions, breathing exercises, and mindfulness practices.',
      'sleep': 'Discover soothing sleep stories, calming music, and relaxation techniques for better sleep.',
      'music': 'Listen to peaceful melodies, nature sounds, and ambient music for relaxation and focus.',
    };
    
    final description = descriptions[widget.category.toLowerCase()] ?? 
        'Explore content in the ${widget.category} category.';
    
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getCategoryIcon(),
                color: Colors.white,
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                widget.category,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            description,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14.sp,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = _filterOptions[widget.category.toLowerCase()] ?? ['All'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Filter by',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 40.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: filters.length,
            itemBuilder: (context, index) {
              final filter = filters[index];
              final isSelected = _selectedFilter == filter;
              return Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedbackHelper.lightImpact();
                    setState(() {
                      _selectedFilter = filter;
                    });
                    _filterContent();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? Colors.white : Colors.white30,
                      ),
                    ),
                    child: Text(
                      filter,
                      style: TextStyle(
                        color: isSelected ? const Color(0xFF1B4B6F) : Colors.white,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _filterContent() {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void _showFilterDialog() {
    final filters = _filterOptions[widget.category.toLowerCase()] ?? ['All'];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Filter ${widget.category}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: filters.map((filter) {
            return ListTile(
              title: Text(filter),
              leading: Radio<String>(
                value: filter,
                groupValue: _selectedFilter,
                onChanged: (value) {
                  setState(() {
                    _selectedFilter = value!;
                  });
                  _filterContent();
                  Navigator.pop(context);
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  IconData _getCategoryIcon() {
    switch (widget.category.toLowerCase()) {
      case 'meditation':
        return Icons.self_improvement;
      case 'sleep':
        return Icons.nightlight_round;
      case 'music':
        return Icons.music_note;
      default:
        return Icons.category;
    }
  }

  Widget _buildCategoryContent() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    // Different content for each category
    switch (widget.category.toLowerCase()) {
      case 'sleep':
        return _buildSleepContent();
      case 'meditation':
        return _buildMeditationContent();
      case 'music':
        return _buildMusicContent();
      default:
        return _buildDefaultContent();
    }
  }

  Widget _buildSleepContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Sleep Stories'),
        SizedBox(height: 16.h),
        _buildSleepStoriesGrid(),
        SizedBox(height: 24.h),
        _buildSectionTitle('Sleep Music'),
        SizedBox(height: 16.h),
        _buildSleepMusicList(),
      ],
    );
  }

  Widget _buildMeditationContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Guided Meditation'),
        SizedBox(height: 16.h),
        _buildMeditationList([
          {'title': 'Mindful Breathing', 'duration': '10 min', 'imageUrl': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?auto=format&fit=crop&w=400&q=80'},
          {'title': 'Body Scan', 'duration': '15 min', 'imageUrl': 'https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?auto=format&fit=crop&w=400&q=80'},
          {'title': 'Guided Meditation', 'duration': '20 min', 'imageUrl': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?auto=format&fit=crop&w=400&q=80'},
        ]),
        SizedBox(height: 24.h),
        _buildSectionTitle('Breathing Exercises'),
        SizedBox(height: 16.h),
        _buildBreathingExercises(),
      ],
    );
  }

  Widget _buildDefaultContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('All Categories'),
        SizedBox(height: 16.h),
        _buildCategoryGrid([
          {'title': 'Sleep Stories', 'icon': Icons.nightlight_round},
          {'title': 'Meditation', 'icon': Icons.self_improvement},
          {'title': 'Music', 'icon': Icons.music_note},
          {'title': 'Tools', 'icon': Icons.toll_outlined},
        ]),
      ],
    );
  }

  Widget _buildSleepStoriesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 0.8,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        final stories = [
          {'title': 'Bedtime Stories', 'subtitle': 'For Deep Sleep', 'imageUrl': 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=400&q=80'},
          {'title': 'Nature Sounds', 'subtitle': 'Forest Ambience', 'imageUrl': 'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?auto=format&fit=crop&w=400&q=80'},
          {'title': 'Lullabies', 'subtitle': 'Soothing Melodies', 'imageUrl': 'https://images.unsplash.com/photo-1502082553048-f009c37129b9?auto=format&fit=crop&w=400&q=80'},
          {'title': 'Ocean Waves', 'subtitle': 'Calming Sounds', 'imageUrl': 'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80'},
        ];
        
        return _buildContentCard(context, stories[index]);
      },
    );
  }

  Widget _buildSleepMusicList() {
    final music = [
      {'title': 'Calm Piano', 'artist': 'Sleep Music', 'duration': '1 hour'},
      {'title': 'Rain Sounds', 'artist': 'Nature', 'duration': '8 hours'},
      {'title': 'White Noise', 'artist': 'Ambient', 'duration': '10 hours'},
    ];

    return Column(
      children: music.map((song) {
        return _buildMusicCard(context, song);
      }).toList(),
    );
  }

  Widget _buildBreathingExercises() {
    final exercises = [
      {'title': '4-7-8 Breathing', 'duration': '5 min', 'description': 'Calm your nervous system'},
      {'title': 'Box Breathing', 'duration': '3 min', 'description': 'Improve focus and concentration'},
      {'title': 'Diaphragmatic Breathing', 'duration': '7 min', 'description': 'Reduce stress and anxiety'},
    ];

    return Column(
      children: exercises.map((exercise) {
        return _buildExerciseCard(context, exercise);
      }).toList(),
    );
  }

  Widget _buildContentCard(BuildContext context, Map<String, String> content) {
    return GestureDetector(
      onTap: () {
        HapticFeedbackHelper.lightImpact();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ContentDetailScreen(
              contentId: content['id'] ?? 'category-${content['title']?.toString().toLowerCase().replaceAll(' ', '-')}',
              content: ContentModel.fromMap({
                'id': content['id'] ?? 'category-${content['title']?.toString().toLowerCase().replaceAll(' ', '-')}',
                'imageUrl': content['imageUrl'] ?? 'https://via.placeholder.com/400x300',
                'title': content['title'] ?? 'Unknown Title',
                'subtitle': content['subtitle'] ?? 'Unknown Subtitle',
                'description': 'Content from ${widget.category} category.',
                'category': widget.category,
                'tags': [widget.category],
                'duration': 300,
                'author': 'Content Creator',
                'rating': 4.2,
                'playCount': 150,
                'isPremium': false,
                'createdAt': DateTime.now().toIso8601String(),
              }),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image.network(
                  content['imageUrl'] ?? 'https://via.placeholder.com/400x300',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      content['title'] ?? 'Unknown Title',
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
                      content['subtitle'] ?? 'Unknown Subtitle',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMusicCard(BuildContext context, Map<String, String> song) {
    return GestureDetector(
      onTap: () {
        HapticFeedbackHelper.lightImpact();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MeditationPlayerScreen(
              content: ContentModel(
                id: 'music-${song['title']?.toLowerCase().replaceAll(' ', '-')}',
                title: song['title'] ?? 'Music',
                subtitle: song['artist'] ?? 'Artist',
                description: 'Relaxing music for meditation.',
                imageUrl: 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?auto=format&fit=crop&w=400&q=80',
                audioUrl: '',
                category: 'music',
                tags: ['music', 'relaxation'],
                duration: 300,
                author: song['artist'] ?? 'Artist',
                rating: 4.3,
                playCount: 200,
                isPremium: false,
                createdAt: DateTime.now(),
              ),
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.music_note,
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
                    song['title']!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${song['artist']} • ${song['duration']}',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.play_circle_filled,
              color: Colors.white,
              size: 32.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseCard(BuildContext context, Map<String, String> exercise) {
    return GestureDetector(
      onTap: () {
        HapticFeedbackHelper.lightImpact();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MeditationPlayerScreen(
              content: ContentModel(
                id: 'exercise-${exercise['title']?.toLowerCase().replaceAll(' ', '-')}',
                title: exercise['title'] ?? 'Exercise',
                subtitle: exercise['description'] ?? 'Description',
                description: 'Breathing exercise for relaxation.',
                imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?auto=format&fit=crop&w=400&q=80',
                audioUrl: '',
                category: 'exercise',
                tags: ['breathing', 'exercise'],
                duration: 300,
                author: 'Exercise Guide',
                rating: 4.4,
                playCount: 150,
                isPremium: false,
                createdAt: DateTime.now(),
              ),
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.air,
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
                    exercise['title']!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    exercise['description']!,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  exercise['duration']!,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12.sp,
                  ),
                ),
                Icon(
                  Icons.play_circle_filled,
                  color: Colors.white,
                  size: 32.sp,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildSleepStoriesContent() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       _buildSectionTitle('Popular Sleep Stories'),
  //       const SizedBox(height: 16),
  //       _buildStoryGrid([
  //         {'title': 'Bedtime Stories', 'subtitle': 'For Deep Sleep'},
  //         {'title': 'Nature Sounds', 'subtitle': 'Forest Ambience'},
  //         {'title': 'Lullabies', 'subtitle': 'Soothing Melodies'},
  //       ]),
  //     ],
  //   );
  // }



  Widget _buildMusicContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Sleep Music'),
        const SizedBox(height: 16),
        _buildMusicList([
          {
            'title': 'Calm Piano',
            'artist': 'Sleep Music',
            'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MeditationPlayerScreen(
                  content: ContentModel(
                    id: 'calm-piano',
                    title: 'Calm Piano',
                    subtitle: 'Sleep Music',
                    description: 'Peaceful piano music for sleep.',
                    imageUrl: 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?auto=format&fit=crop&w=400&q=80',
                    audioUrl: '',
                    category: 'music',
                    tags: ['piano', 'sleep', 'calm'],
                    duration: 600,
                    author: 'Sleep Music',
                    rating: 4.5,
                    playCount: 400,
                    isPremium: false,
                    createdAt: DateTime.now(),
                  ),
                ),
              ),
            ),
          },
          {
            'title': 'Rain Sounds',
            'artist': 'Nature',
            'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MeditationPlayerScreen(
                  content: ContentModel(
                    id: 'rain-sounds',
                    title: 'Rain Sounds',
                    subtitle: 'Nature',
                    description: 'Soothing rain sounds for relaxation.',
                    imageUrl: 'https://images.unsplash.com/photo-1518837695005-2083093ee35b?auto=format&fit=crop&w=400&q=80',
                    audioUrl: '',
                    category: 'nature',
                    tags: ['rain', 'nature', 'relaxation'],
                    duration: 600,
                    author: 'Nature',
                    rating: 4.3,
                    playCount: 250,
                    isPremium: false,
                    createdAt: DateTime.now(),
                  ),
                ),
              ),
            ),
          },
          {
            'title': 'White Noise',
            'artist': 'Ambient',
            'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MeditationPlayerScreen(
                  content: ContentModel(
                    id: 'white-noise',
                    title: 'White Noise',
                    subtitle: 'Ambient',
                    description: 'Calming white noise for focus.',
                    imageUrl: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?auto=format&fit=crop&w=400&q=80',
                    audioUrl: '',
                    category: 'ambient',
                    tags: ['white-noise', 'ambient', 'focus'],
                    duration: 600,
                    author: 'Ambient',
                    rating: 4.2,
                    playCount: 180,
                    isPremium: false,
                    createdAt: DateTime.now(),
                  ),
                ),
              ),
            ),
          },
        ]),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }



  Widget _buildCategoryGrid(List<Map<String, dynamic>> categories) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(categories[index]['icon'] as IconData, color: Colors.white, size: 40),
              const SizedBox(height: 8),
              Text(
                categories[index]['title']!,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMeditationList(List<Map<String, dynamic>> meditations) {
    return Column(
      children: meditations.map((meditation) {
        return _buildContentCard(context, {
          'title': meditation['title']!,
          'subtitle': meditation['duration']!,
          'imageUrl': meditation['imageUrl']!,
        });
      }).toList(),
    );
  }



  Widget _buildMusicList(List<Map<String, dynamic>> music) {
    return Column(
      children: music.map((song) {
        return GestureDetector(
          onTap: song['onTap'] as VoidCallback,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.music_note, color: Colors.white, size: 30),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        song['title']!,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        song['artist']!,
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.play_circle_filled, color: Colors.white, size: 30),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
} 