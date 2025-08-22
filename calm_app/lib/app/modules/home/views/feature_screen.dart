import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../onboarding/onboarding_views/feature_plan_screen.dart';
import 'content_detail_screen.dart';
import '../../../widgets/interactive_feedback.dart';
import '../../../data/models/content_model.dart';

class FeatureScreen extends StatefulWidget {
  const FeatureScreen({Key? key}) : super(key: key);

  @override
  State<FeatureScreen> createState() => _FeatureScreenState();
}

class _FeatureScreenState extends State<FeatureScreen> with TickerProviderStateMixin {
  int selectedPlan = 0; // 0 = yearly, 1 = monthly
  String _selectedCategory = 'All';
  String _selectedSort = 'Featured';
  bool _showFilters = false;
  bool _isLoading = false;
  
  late AnimationController _filterAnimationController;
  late AnimationController _refreshAnimationController;
  
  // Content data
  List<ContentModel> _featuredContent = [];
  List<ContentModel> _filteredContent = [];
  List<ContentModel> _premiumContent = [];
  
  // Categories and sort options
  final List<String> _categories = ['All', 'Premium', 'New', 'Popular', 'Exclusive'];
  final List<String> _sortOptions = ['Featured', 'Newest', 'Most Popular', 'Highest Rated'];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadContent();
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
        _featuredContent = _getFeaturedContent();
        _premiumContent = _getPremiumContent();
        _applyFilters();
        
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void _applyFilters() {
    List<ContentModel> filtered = _featuredContent;

    // Apply category filter
    switch (_selectedCategory) {
      case 'Premium':
        filtered = _premiumContent;
        break;
      case 'New':
        filtered = filtered.where((content) => 
          content.createdAt.isAfter(DateTime.now().subtract(const Duration(days: 7)))
        ).toList();
        break;
      case 'Popular':
        filtered.sort((a, b) => b.playCount.compareTo(a.playCount));
        break;
      case 'Exclusive':
        filtered = filtered.where((content) => content.isPremium).toList();
        break;
    }

    // Apply sorting
    switch (_selectedSort) {
      case 'Newest':
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'Most Popular':
        filtered.sort((a, b) => b.playCount.compareTo(a.playCount));
        break;
      case 'Highest Rated':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
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
    
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _refreshAnimationController.stop();
        _loadContent();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Featured content refreshed!'),
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
          
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1B4B6F),
        title: const Text(
          'Share Content',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Share "${content.title}" with friends?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Content shared successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text(
              'Share',
              style: TextStyle(color: Colors.orange),
            ),
          ),
        ],
      ),
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top image with header
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
                child: Image.network(
                  'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80',
                  height: 180.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              // Header overlay
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Featured",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
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
                ),
              ),
            ],
          ),
          
          // Filters section
          if (_showFilters) _buildFiltersSection(),
          
          // Content section
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 12.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 8.h),
                          child: Text(
                            'Find your Calm today with this content and more',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        
                        // Featured content grid
                        _buildFeaturedContentGrid(),
                        SizedBox(height: 24.h),
                        
                        // Premium content section
                        _buildPremiumContentSection(),
                        SizedBox(height: 24.h),
                        
                        // Features list
                        _buildFeaturesList(),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
          ),
          
          // Fixed bottom box
          SafeArea(
            top: false,
            bottom: false,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xff000104),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PlanSelector(
                    selectedPlan: selectedPlan,
                    onChanged: (val) {
                      setState(() {
                        selectedPlan = val;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        // Get.off(() => const ReferralScreen());
                      },
                      child: Text('Try Free & Subscribe', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Totally free for 7 days, then Rs 675/month, billed annually at Rs 8,100/yr Cancel anytime.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
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
          _buildFilterChips('Category', _categories, _selectedCategory, (category) {
            setState(() {
              _selectedCategory = category;
            });
            _applyFilters();
          }),
          SizedBox(height: 12.h),
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

  Widget _buildFeaturedContentGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Featured Content',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 0.8,
            ),
            itemCount: _filteredContent.length,
            itemBuilder: (context, index) {
              final content = _filteredContent[index];
              return _buildContentCard(content);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumContentSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.diamond, color: Colors.orange, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                'Premium Content',
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
            height: 160.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _premiumContent.length,
              itemBuilder: (context, index) {
                final content = _premiumContent[index];
                return _buildContentCard(content, isHorizontal: true);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentCard(ContentModel content, {bool isHorizontal = false}) {
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
      onLongPress: () => _previewContent(content),
      child: Container(
        width: isHorizontal ? 200.w : double.infinity,
        margin: isHorizontal ? EdgeInsets.only(right: 16.w) : EdgeInsets.zero,
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
                    width: double.infinity,
                    height: isHorizontal ? 100.h : 120.h,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: isHorizontal ? 100.h : 120.h,
                        color: Colors.grey.withOpacity(0.3),
                        child: const Icon(Icons.image, color: Colors.white70, size: 40),
                      );
                    },
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

  Widget _buildFeaturesList() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          _featureItem(
            'A suite of life-changing tools',
            'Reduce your anxiety, manage your stress, and sleep better with over 50,000 minutes of content and tools.',
          ),
          _featureItem(
            'Learn from the best',
            'Taught by world-class mindfulness experts and narrated by soothing and familiar voices.',
          ),
          _featureItem(
            'Backed by research',
            'In a randomized controlled study, those who used Calm regularly saw reductions in stress, depression, and anxiety symptoms.',
          ),
        ],
      ),
    );
  }

  Widget _featureItem(String title, String subtitle) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: Colors.white, size: 26.h),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<ContentModel> _getFeaturedContent() {
    final allContent = ContentRepository.getAllContent();
    final featured = List<ContentModel>.from(allContent);
    
    // Sort by a combination of rating, play count, and premium status
    featured.sort((a, b) {
      final aScore = (a.rating * a.playCount) + (a.isPremium ? 1000 : 0);
      final bScore = (b.rating * b.playCount) + (b.isPremium ? 1000 : 0);
      return bScore.compareTo(aScore);
    });
    
    return featured.take(8).toList();
  }

  List<ContentModel> _getPremiumContent() {
    final allContent = ContentRepository.getAllContent();
    return allContent.where((content) => content.isPremium).take(6).toList();
  }
} 