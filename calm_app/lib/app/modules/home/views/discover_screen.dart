import 'package:calm_app/app/widgets/category_icon_grid.dart';
import 'package:calm_app/app/widgets/discovr_searh_box.dart';
import 'package:calm_app/app/widgets/premium_card_box.dart';
import 'package:calm_app/app/modules/home/views/all_discover_content_screen.dart';
import 'package:calm_app/app/modules/home/views/content_detail_screen.dart';
import 'package:calm_app/app/widgets/interactive_feedback.dart';
import 'package:calm_app/app/data/models/content_model.dart';
import 'package:calm_app/app/services/share_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> with TickerProviderStateMixin {
  String _selectedCategory = 'All';
  String _selectedSort = 'Popular';
  bool _showFilters = false;
  bool _isLoading = false;
  
  late AnimationController _filterAnimationController;
  late AnimationController _refreshAnimationController;
  
  // Content data
  List<ContentModel> _allContent = [];
  List<ContentModel> _filteredContent = [];
  List<ContentModel> _personalizedRecommendations = [];
  List<ContentModel> _trendingContent = [];
  List<ContentModel> _recentContent = [];
  
  // Playlists
  List<Map<String, dynamic>> _playlists = [];
  
  // Categories
  final List<String> _categories = ['All', 'Meditation', 'Sleep', 'Breathing', 'Relaxation', 'Nature', 'Music'];
  final List<String> _sortOptions = ['Popular', 'Recent', 'Trending', 'Rating', 'Duration'];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadContent();
    _loadPlaylists();
  }

  @override
  void dispose() {
    _filterAnimationController.dispose();
    _refreshAnimationController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _filterAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _refreshAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  void _loadContent() {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _allContent = ContentRepository.getAllContent();
        _personalizedRecommendations = _getPersonalizedRecommendations();
        _trendingContent = _getTrendingContent();
        _recentContent = _getRecentContent();
        _applyFilters();
        
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void _loadPlaylists() {
    _playlists = [
      {
        'id': '1',
        'name': 'Morning Mindfulness',
        'description': 'Start your day with intention and clarity',
        'imageUrl': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=400&q=80',
        'contentCount': 8,
        'duration': '45 min',
        'category': 'Meditation',
      },
      {
        'id': '2',
        'name': 'Deep Sleep Collection',
        'description': 'Gentle stories and sounds for peaceful sleep',
        'imageUrl': 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=400&q=80',
        'contentCount': 12,
        'duration': '2 hours',
        'category': 'Sleep',
      },
      {
        'id': '3',
        'name': 'Stress Relief Toolkit',
        'description': 'Quick techniques for immediate stress relief',
        'imageUrl': 'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80',
        'contentCount': 6,
        'duration': '30 min',
        'category': 'Relaxation',
      },
      {
        'id': '4',
        'name': 'Focus & Concentration',
        'description': 'Enhance your productivity and mental clarity',
        'imageUrl': 'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?auto=format&fit=crop&w=400&q=80',
        'contentCount': 10,
        'duration': '1 hour',
        'category': 'Meditation',
      },
    ];
  }

  void _applyFilters() {
    List<ContentModel> filtered = _allContent;

    // Apply category filter
    if (_selectedCategory != 'All') {
      filtered = filtered.where((content) => 
        content.categoryDisplayName == _selectedCategory
      ).toList();
    }

    // Apply sorting
    switch (_selectedSort) {
      case 'Popular':
        filtered.sort((a, b) => b.playCount.compareTo(a.playCount));
        break;
      case 'Recent':
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'Trending':
        // Simulate trending based on recent activity
        filtered.sort((a, b) => (b.rating * b.playCount).compareTo(a.rating * a.playCount));
        break;
      case 'Rating':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Duration':
        filtered.sort((a, b) => a.duration.compareTo(b.duration));
        break;
    }

    setState(() {
      _filteredContent = filtered;
    });
  }

  void _toggleFilters() {
    setState(() {
      _showFilters = !_showFilters;
    });
    
    if (_showFilters) {
      _filterAnimationController.forward();
    } else {
      _filterAnimationController.reverse();
    }
    
    HapticFeedbackHelper.lightImpact();
  }

  void _refreshContent() {
    _refreshAnimationController.repeat();
    HapticFeedbackHelper.mediumImpact();
    
    // Simulate refresh
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _refreshAnimationController.stop();
        _loadContent();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Content refreshed!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  void _previewContent(ContentModel content) {
    HapticFeedbackHelper.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1B4B6F),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildContentPreview(content),
    );
  }

  Widget _buildContentPreview(ContentModel content) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Preview',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          
          // Content Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              content.imageUrl,
              width: double.infinity,
              height: 200.h,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 200.h,
                  color: Colors.grey.withOpacity(0.3),
                  child: const Icon(Icons.image, color: Colors.white70, size: 80),
                );
              },
            ),
          ),
          SizedBox(height: 16.h),
          
          // Content Info
          Text(
            content.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            content.subtitle,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            content.description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14.sp,
              height: 1.4,
            ),
          ),
          SizedBox(height: 16.h),
          
          // Quick Actions
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ContentDetailScreen(
                          contentId: content.id,
                          content: content,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Play'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _shareContent(content);
                  },
                  icon: const Icon(Icons.share),
                  label: const Text('Share'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          
          // Rating
          Row(
            children: [
              Icon(Icons.star, color: Colors.yellow, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                '${content.rating}/5 (${content.playCount} plays)',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14.sp,
                ),
              ),
              const Spacer(),
              if (content.isPremium)
                Row(
                  children: [
                    Icon(Icons.diamond, color: Colors.orange, size: 16.sp),
                    SizedBox(width: 4.w),
                    Text(
                      'Premium',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _shareContent(ContentModel content) {
    HapticFeedbackHelper.lightImpact();
    ShareService.showShareDialog(
      context: context,
      contentType: content.categoryDisplayName.toLowerCase(),
      title: content.title,
      subtitle: content.subtitle,
      description: content.description,
      imageUrl: content.imageUrl,
      customMessage: 'Check out this amazing ${content.categoryDisplayName.toLowerCase()} content on Calm! 🧘‍♀️✨',
    );
  }

  void _rateContent(ContentModel content) {
    HapticFeedbackHelper.lightImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1B4B6F),
        title: const Text(
          'Rate Content',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              content.title,
              style: const TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Thank you for your ${index + 1}-star rating!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 32.sp,
                  ),
                );
              }),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B4B6F),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1B517E),
                Color(0xFF0D3550),
                Color(0xFF32366F),
                Color(0xFF1B517E),
              ],
              stops: [0.0, 0.3, 0.7, 1.0],
            ),
          ),
          child: Column(
            children: [
              // Header with filters
              _buildHeader(),
              
              // Filters section
              if (_showFilters) _buildFiltersSection(),
              
              // Content
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : ListView(
                        padding: EdgeInsets.all(16.w),
                        children: [
                          // Search Bar
                          DiscovrSearhBox(),
                          SizedBox(height: 24.h),
                          
                          // AI Recommendations
                          _buildSmartRecommendations(),
                          SizedBox(height: 24.h),
                          
                          // Playlists
                          _buildPlaylistsSection(),
                          SizedBox(height: 24.h),
                          
                          // Trending Content
                          _buildTrendingSection(),
                          SizedBox(height: 24.h),
                          
                          // Recent Content
                          _buildRecentSection(),
                          SizedBox(height: 24.h),
                          
                          // Filtered Content
                          if (_selectedCategory != 'All' || _selectedSort != 'Popular')
                            _buildFilteredContentSection(),
                          
                          // Premium Card
                          PremiumCardBox(),
                          SizedBox(height: 24.h),
                          
                          // Category Grid
                          CategoryIconGrid(),
                          SizedBox(height: 24.h),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Text(
            "Discover",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          // Filter button
          IconButton(
            onPressed: _toggleFilters,
            icon: AnimatedBuilder(
              animation: _filterAnimationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _filterAnimationController.value * 0.5,
                  child: Icon(
                    Icons.tune,
                    color: _showFilters ? Colors.orange : Colors.white,
                  ),
                );
              },
            ),
          ),
          // Refresh button
          AnimatedBuilder(
            animation: _refreshAnimationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _refreshAnimationController.value * 6.28,
                child: IconButton(
                  onPressed: _refreshContent,
                  icon: const Icon(Icons.refresh, color: Colors.white),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        children: [
          // Category Filter
          _buildFilterChips('Category', _categories, _selectedCategory, (category) {
            setState(() {
              _selectedCategory = category;
            });
            _applyFilters();
          }),
          SizedBox(height: 12.h),
          
          // Sort Filter
          _buildFilterChips('Sort by', _sortOptions, _selectedSort, (sort) {
            setState(() {
              _selectedSort = sort;
            });
            _applyFilters();
          }),
        ],
      ),
    );
  }

  Widget _buildFilterChips(String title, List<String> options, String selected, Function(String) onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: options.map((option) {
              final isSelected = selected == option;
              return Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: GestureDetector(
                  onTap: () => onTap(option),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.orange : Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: isSelected ? Colors.orange : Colors.white.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      option,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontSize: 12.sp,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSmartRecommendations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.psychology,
              color: Colors.yellow,
              size: 20.sp,
            ),
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
        SizedBox(height: 12.h),
        SizedBox(
          height: 180.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _personalizedRecommendations.length,
            itemBuilder: (context, index) {
              final content = _personalizedRecommendations[index];
              return _buildContentCard(content, showPreview: true);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPlaylistsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader("Curated Playlists"),
        SizedBox(height: 12.h),
        SizedBox(
          height: 140.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _playlists.length,
            itemBuilder: (context, index) {
              final playlist = _playlists[index];
              return GestureDetector(
                onTap: () {
                  HapticFeedbackHelper.lightImpact();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AllDiscoverContentScreen(
                        category: playlist['name'],
                        content: _filteredContent.take(8).map((c) => c.toMap()).toList(),
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 160.w,
                  margin: EdgeInsets.only(right: 16.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.network(
                          playlist['imageUrl'],
                          width: 160.w,
                          height: 80.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              playlist['name'],
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
                              '${playlist['contentCount']} sessions • ${playlist['duration']}',
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
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTrendingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader("Trending Now"),
        SizedBox(height: 12.h),
        SizedBox(
          height: 180.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _trendingContent.length,
            itemBuilder: (context, index) {
              final content = _trendingContent[index];
              return _buildContentCard(content, showPreview: true);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader("Recently Added"),
        SizedBox(height: 12.h),
        SizedBox(
          height: 180.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _recentContent.length,
            itemBuilder: (context, index) {
              final content = _recentContent[index];
              return _buildContentCard(content, showPreview: true);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilteredContentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader("Filtered Results"),
        SizedBox(height: 12.h),
        SizedBox(
          height: 180.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _filteredContent.length,
            itemBuilder: (context, index) {
              final content = _filteredContent[index];
              return _buildContentCard(content, showPreview: true);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildContentCard(ContentModel content, {bool showPreview = false}) {
    return GestureDetector(
      onTap: () {
        HapticFeedbackHelper.mediumImpact();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ContentDetailScreen(
              contentId: content.id,
              content: content,
            ),
          ),
        );
      },
      onLongPress: showPreview ? () => _previewContent(content) : null,
      child: Container(
        width: 200.w,
        margin: EdgeInsets.only(right: 16.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    content.imageUrl,
                    width: 200.w,
                    height: 120.h,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 200.w,
                        height: 120.h,
                        color: Colors.grey.withOpacity(0.3),
                        child: const Icon(Icons.image, color: Colors.white70, size: 40),
                      );
                    },
                  ),
                ),
                if (showPreview)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        Icons.preview,
                        color: Colors.white,
                        size: 16.sp,
                      ),
                    ),
                  ),
                if (content.isPremium)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        Icons.diamond,
                        color: Colors.white,
                        size: 16.sp,
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    content.title,
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
                    content.subtitle,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 14.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        content.rating.toString(),
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12.sp,
                        ),
                      ),
                      const Spacer(),
                      if (showPreview)
                        GestureDetector(
                          onTap: () => _rateContent(content),
                          child: Icon(
                            Icons.rate_review,
                            color: Colors.white70,
                            size: 14.sp,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: () {
            HapticFeedbackHelper.lightImpact();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AllDiscoverContentScreen(
                  category: title,
                  content: _filteredContent.map((c) => c.toMap()).toList(),
                ),
              ),
            );
          },
          child: Text(
            "See All",
            style: TextStyle(
              color: Colors.white54,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  List<ContentModel> _getPersonalizedRecommendations() {
    final allContent = ContentRepository.getAllContent();
    final recommendations = <ContentModel>[];
    
    // Add popular content
    final popularContent = ContentRepository.getPopularContent(limit: 2);
    recommendations.addAll(popularContent);
    
    // Add content based on time of day
    final now = DateTime.now();
    if (now.hour < 12) {
      final morningContent = allContent.where((content) => 
        content.tags.any((tag) => tag.toLowerCase().contains('morning') || 
                                 tag.toLowerCase().contains('energy'))
      ).take(1);
      recommendations.addAll(morningContent);
    } else if (now.hour < 18) {
      final focusContent = allContent.where((content) => 
        content.tags.any((tag) => tag.toLowerCase().contains('focus') || 
                                 tag.toLowerCase().contains('concentration'))
      ).take(1);
      recommendations.addAll(focusContent);
    } else {
      final eveningContent = allContent.where((content) => 
        content.tags.any((tag) => tag.toLowerCase().contains('sleep') || 
                                 tag.toLowerCase().contains('relaxation'))
      ).take(1);
      recommendations.addAll(eveningContent);
    }
    
    // Add recent content
    final recentContent = ContentRepository.getRecentContent(limit: 2);
    for (final content in recentContent) {
      if (!recommendations.contains(content) && recommendations.length < 4) {
        recommendations.add(content);
      }
    }
    
    return recommendations.take(4).toList();
  }

  List<ContentModel> _getTrendingContent() {
    final allContent = ContentRepository.getAllContent();
    final trending = List<ContentModel>.from(allContent);
    
    // Simulate trending based on rating and play count
    trending.sort((a, b) => (b.rating * b.playCount).compareTo(a.rating * a.playCount));
    
    return trending.take(6).toList();
  }

  List<ContentModel> _getRecentContent() {
    return ContentRepository.getRecentContent(limit: 6);
  }
} 