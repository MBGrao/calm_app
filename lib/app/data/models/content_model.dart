class ContentModel {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String imageUrl;
  final String? audioUrl;
  final String category;
  final List<String> tags;
  final int duration; // in seconds
  final String author;
  final double rating;
  final int playCount;
  final bool isPremium;
  final DateTime createdAt;
  final String? avatarUrl;

  ContentModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imageUrl,
    this.audioUrl,
    required this.category,
    required this.tags,
    required this.duration,
    required this.author,
    required this.rating,
    required this.playCount,
    required this.isPremium,
    required this.createdAt,
    this.avatarUrl,
  });

  // Convert to Map for search and filtering
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
      'category': category,
      'tags': tags,
      'duration': duration,
      'author': author,
      'rating': rating,
      'playCount': playCount,
      'isPremium': isPremium,
      'createdAt': createdAt.toIso8601String(),
      'avatarUrl': avatarUrl,
    };
  }

  // Create from Map
  factory ContentModel.fromMap(Map<String, dynamic> map) {
    return ContentModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      audioUrl: map['audioUrl'],
      category: map['category'] ?? '',
      tags: List<String>.from(map['tags'] ?? []),
      duration: map['duration'] ?? 0,
      author: map['author'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      playCount: map['playCount'] ?? 0,
      isPremium: map['isPremium'] ?? false,
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      avatarUrl: map['avatarUrl'],
    );
  }

  // Search methods
  bool matchesSearch(String query) {
    final lowercaseQuery = query.toLowerCase();
    return title.toLowerCase().contains(lowercaseQuery) ||
           subtitle.toLowerCase().contains(lowercaseQuery) ||
           description.toLowerCase().contains(lowercaseQuery) ||
           author.toLowerCase().contains(lowercaseQuery) ||
           tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
  }

  bool matchesCategory(String category) {
    return this.category.toLowerCase() == category.toLowerCase();
  }

  bool matchesTag(String tag) {
    return tags.any((t) => t.toLowerCase() == tag.toLowerCase());
  }

  // Duration formatting
  String get formattedDuration {
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    if (minutes > 0) {
      return '$minutes:${seconds.toString().padLeft(2, '0')}';
    }
    return '$seconds seconds';
  }

  // Category display name
  String get categoryDisplayName {
    switch (category.toLowerCase()) {
      case 'meditation':
        return 'Meditation';
      case 'sleep':
        return 'Sleep Stories';
      case 'breathing':
        return 'Breathing Exercises';
      case 'relaxation':
        return 'Relaxation';
      case 'music':
        return 'Music';
      case 'nature':
        return 'Nature Sounds';
      default:
        return category;
    }
  }
}

// Content Repository for managing content data
class ContentRepository {
  static final List<ContentModel> _allContent = [
    ContentModel(
      id: '1',
      title: 'Calming Anxiety',
      subtitle: 'Meditation • 3 minutes',
      description: 'A gentle meditation to help calm anxiety and find inner peace.',
      imageUrl: 'assets/icons/home_screen/light.png',
      category: 'meditation',
      tags: ['anxiety', 'calm', 'peace', 'mindfulness', 'stress-relief'],
      duration: 180,
      author: 'MeditAi',
      rating: 4.8,
      playCount: 1250,
      isPremium: false,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    ContentModel(
      id: '2',
      title: 'Deep Sleep',
      subtitle: 'Sleep Music • 45 minutes',
      description: 'Soothing sounds to help you fall asleep naturally.',
      imageUrl: 'assets/icons/home_screen/moon.png',
      category: 'sleep',
      tags: ['sleep', 'relaxation', 'night', 'peaceful'],
      duration: 2700,
      author: 'Sleep Master',
      rating: 4.9,
      playCount: 3200,
      isPremium: true,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    ContentModel(
      id: '3',
      title: 'Breathing for Focus',
      subtitle: 'Breathing Exercise • 5 minutes',
      description: 'A focused breathing exercise to improve concentration.',
      imageUrl: 'assets/icons/home_screen/circle_white.png',
      category: 'breathing',
      tags: ['focus', 'breathing', 'concentration', 'energy'],
      duration: 300,
      author: 'Breath Coach',
      rating: 4.7,
      playCount: 890,
      isPremium: false,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    ContentModel(
      id: '4',
      title: 'Ocean Waves',
      subtitle: 'Nature Sounds • 30 minutes',
      description: 'Relaxing ocean wave sounds for deep relaxation.',
      imageUrl: 'assets/icons/home_screen/glasses.png',
      category: 'nature',
      tags: ['ocean', 'waves', 'nature', 'relaxation'],
      duration: 1800,
      author: 'Nature Sounds',
      rating: 4.6,
      playCount: 2100,
      isPremium: false,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
    ContentModel(
      id: '5',
      title: 'Progressive Muscle Relaxation',
      subtitle: 'Relaxation • 15 minutes',
      description: 'Guided progressive muscle relaxation for complete body relaxation.',
      imageUrl: 'assets/icons/home_screen/yellow_circle.png',
      category: 'relaxation',
      tags: ['muscle', 'relaxation', 'body', 'stress-relief'],
      duration: 900,
      author: 'Relaxation Expert',
      rating: 4.8,
      playCount: 1560,
      isPremium: true,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    ContentModel(
      id: '6',
      title: 'Mindful Morning',
      subtitle: 'Meditation • 10 minutes',
      description: 'Start your day with mindfulness and intention.',
      imageUrl: 'assets/icons/home_screen/clock.png',
      category: 'meditation',
      tags: ['morning', 'mindfulness', 'intention', 'daily'],
      duration: 600,
      author: 'Mindful Living',
      rating: 4.9,
      playCount: 2800,
      isPremium: false,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ContentModel(
      id: '7',
      title: 'Forest Ambience',
      subtitle: 'Nature Sounds • 60 minutes',
      description: 'Immerse yourself in the peaceful sounds of the forest.',
      imageUrl: 'assets/icons/home_screen/prize.png',
      category: 'nature',
      tags: ['forest', 'nature', 'peaceful', 'ambience'],
      duration: 3600,
      author: 'Nature Sounds',
      rating: 4.7,
      playCount: 1800,
      isPremium: true,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
    ContentModel(
      id: '8',
      title: 'Stress Relief Breathing',
      subtitle: 'Breathing Exercise • 7 minutes',
      description: 'Quick breathing exercise to relieve stress and tension.',
      imageUrl: 'assets/icons/home_screen/music.png',
      category: 'breathing',
      tags: ['stress', 'relief', 'breathing', 'quick'],
      duration: 420,
      author: 'Stress Relief Coach',
      rating: 4.6,
      playCount: 950,
      isPremium: false,
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
    ContentModel(
      id: '9',
      title: 'Mindful Morning Routine',
      subtitle: 'Meditation • 15 minutes',
      description: 'Start your day with intention and mindfulness.',
      imageUrl: 'assets/icons/home_screen/gift.png',
      category: 'meditation',
      tags: ['morning', 'mindfulness', 'routine', 'intention', 'daily'],
      duration: 900,
      author: 'Mindful Living',
      rating: 4.9,
      playCount: 3200,
      isPremium: true,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ContentModel(
      id: '10',
      title: 'Insomnia Relief',
      subtitle: 'Sleep Stories • 30 minutes',
      description: 'Gentle stories to help you fall asleep naturally.',
      imageUrl: 'assets/icons/home_screen/lock.png',
      category: 'sleep',
      tags: ['insomnia', 'sleep', 'stories', 'relaxation', 'night'],
      duration: 1800,
      author: 'Sleep Master',
      rating: 4.7,
      playCount: 2100,
      isPremium: false,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    ContentModel(
      id: '11',
      title: 'Focus and Concentration',
      subtitle: 'Breathing Exercise • 5 minutes',
      description: 'Enhance your focus and concentration with this breathing technique.',
      imageUrl: 'assets/icons/home_screen/search_icon.png',
      category: 'breathing',
      tags: ['focus', 'concentration', 'breathing', 'productivity', 'work'],
      duration: 300,
      author: 'Focus Coach',
      rating: 4.5,
      playCount: 1800,
      isPremium: false,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    ContentModel(
      id: '12',
      title: 'Evening Relaxation',
      subtitle: 'Music • 45 minutes',
      description: 'Soothing music to help you unwind and prepare for sleep.',
      imageUrl: 'assets/icons/home_screen/share.png',
      category: 'music',
      tags: ['evening', 'relaxation', 'music', 'sleep', 'unwind'],
      duration: 2700,
      author: 'Relaxation Expert',
      rating: 4.8,
      playCount: 2800,
      isPremium: true,
      createdAt: DateTime.now().subtract(const Duration(days: 6)),
    ),
  ];

  // Get all content
  static List<ContentModel> getAllContent() {
    return _allContent;
  }

  // Search content
  static List<ContentModel> searchContent(String query) {
    if (query.isEmpty) return [];
    return _allContent.where((content) => content.matchesSearch(query)).toList();
  }

  // Filter by category
  static List<ContentModel> getContentByCategory(String category) {
    return _allContent.where((content) => content.matchesCategory(category)).toList();
  }

  // Filter by tag
  static List<ContentModel> getContentByTag(String tag) {
    return _allContent.where((content) => content.matchesTag(tag)).toList();
  }

  // Get popular content
  static List<ContentModel> getPopularContent({int limit = 10}) {
    final sorted = List<ContentModel>.from(_allContent);
    sorted.sort((a, b) => b.playCount.compareTo(a.playCount));
    return sorted.take(limit).toList();
  }

  // Get recent content
  static List<ContentModel> getRecentContent({int limit = 10}) {
    final sorted = List<ContentModel>.from(_allContent);
    sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted.take(limit).toList();
  }

  // Get content by duration range
  static List<ContentModel> getContentByDuration({int? minDuration, int? maxDuration}) {
    return _allContent.where((content) {
      if (minDuration != null && content.duration < minDuration) return false;
      if (maxDuration != null && content.duration > maxDuration) return false;
      return true;
    }).toList();
  }

  // Get all categories
  static List<String> getAllCategories() {
    final categories = _allContent.map((content) => content.category).toSet();
    return categories.toList();
  }

  // Get all tags
  static List<String> getAllTags() {
    final tags = <String>{};
    for (final content in _allContent) {
      tags.addAll(content.tags);
    }
    return tags.toList();
  }
} 