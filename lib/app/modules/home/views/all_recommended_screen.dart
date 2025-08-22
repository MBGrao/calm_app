import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'content_detail_screen.dart';
import '../../../widgets/interactive_feedback.dart';
import '../../../data/models/content_model.dart';

class AllRecommendedScreen extends StatefulWidget {
  final String category;
  final List<Map<String, dynamic>> content;

  const AllRecommendedScreen({
    Key? key,
    required this.category,
    required this.content,
  }) : super(key: key);

  @override
  State<AllRecommendedScreen> createState() => _AllRecommendedScreenState();
}

class _AllRecommendedScreenState extends State<AllRecommendedScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  List<Map<String, dynamic>> _filteredContent = [];
  bool _isLoading = false;
  String _sortBy = 'Recommended';

  final List<String> _filterOptions = ['All', 'Meditation', 'Music', 'Sleep', 'Podcast', 'Breathing'];
  final List<String> _sortOptions = ['Recommended', 'Duration', 'Mood', 'Alphabetical'];

  @override
  void initState() {
    super.initState();
    _filteredContent = List.from(widget.content);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterContent();
  }

  void _filterContent() {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _filteredContent = widget.content.where((item) {
            final searchQuery = _searchController.text.toLowerCase();
            final title = item['title']?.toString().toLowerCase() ?? '';
            final subtitle = item['subtitle']?.toString().toLowerCase() ?? '';
            final tag = item['tag']?.toString().toLowerCase() ?? '';
            
            final matchesSearch = searchQuery.isEmpty || 
                title.contains(searchQuery) || 
                subtitle.contains(searchQuery) || 
                tag.contains(searchQuery);
            
            final matchesFilter = _selectedFilter == 'All' || 
                tag.contains(_selectedFilter.toLowerCase());
            
            return matchesSearch && matchesFilter;
          }).toList();
          
          // Sort content
          _sortContent();
          _isLoading = false;
        });
      }
    });
  }

  void _sortContent() {
    switch (_sortBy) {
      case 'Duration':
        _filteredContent.sort((a, b) => (a['duration'] ?? '').compareTo(b['duration'] ?? ''));
        break;
      case 'Mood':
        _filteredContent.sort((a, b) => (a['mood'] ?? '').compareTo(b['mood'] ?? ''));
        break;
      case 'Alphabetical':
        _filteredContent.sort((a, b) => (a['title'] ?? '').compareTo(b['title'] ?? ''));
        break;
      default: // Recommended
        // Keep original order for recommended
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B4B6F),
      appBar: AppBar(
        title: Text(widget.category),
        backgroundColor: const Color(0xFF1B4B6F),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.sort, color: Colors.white),
            onPressed: () {
              _showSortDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search recommended content...',
                    hintStyle: TextStyle(color: Colors.white70),
                    prefixIcon: Icon(Icons.search, color: Colors.white70),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, color: Colors.white70),
                            onPressed: () {
                              _searchController.clear();
                              _filterContent();
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white30),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                  ),
                ),
                SizedBox(height: 12.h),
                // Filter Chips
                SizedBox(
                  height: 40.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _filterOptions.length,
                    itemBuilder: (context, index) {
                      final filter = _filterOptions[index];
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
                SizedBox(height: 8.h),
                // Sort indicator
                Row(
                  children: [
                    Icon(Icons.sort, color: Colors.white70, size: 16.sp),
                    SizedBox(width: 4.w),
                    Text(
                      'Sorted by: $_sortBy',
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
          // Content List
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : _filteredContent.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              color: Colors.white70,
                              size: 64.sp,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'No recommendations found',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Try adjusting your search or filters',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        itemCount: _filteredContent.length + 1, // +1 for pagination indicator
                        itemBuilder: (context, index) {
                          if (index == _filteredContent.length) {
                            // Pagination indicator
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                              child: Center(
                                child: Column(
                                  children: [
                                    CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      strokeWidth: 2,
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      'Loading more recommendations...',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          
                          final item = _filteredContent[index];
                          return _buildRecommendedCard(context, item);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedCard(BuildContext context, Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        HapticFeedbackHelper.lightImpact();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ContentDetailScreen(
              contentId: item['id'] ?? 'recommended-${item['title']?.toString().toLowerCase().replaceAll(' ', '-')}',
              content: ContentModel.fromMap({
                'id': item['id'] ?? 'recommended-${item['title']?.toString().toLowerCase().replaceAll(' ', '-')}',
                'imageUrl': item['imageUrl'] ?? 'https://via.placeholder.com/400x300',
                'title': item['title'] ?? 'Unknown Title',
                'subtitle': item['subtitle'] ?? 'Unknown Subtitle',
                'description': 'Recommended content based on your preferences.',
                'category': item['tag'] ?? 'recommended',
                'tags': [item['tag'] ?? 'recommended'],
                'duration': 300,
                'author': 'Content Creator',
                'rating': 4.3,
                'playCount': 300,
                'isPremium': false,
                'createdAt': DateTime.now().toIso8601String(),
              }),
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Stack(
                children: [
                  Image.network(
                    item['imageUrl'] ?? 'https://via.placeholder.com/400x300',
                    width: 120.w,
                    height: 120.h,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'AI Recommended',
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
            ),
            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'] ?? 'Unknown Title',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      item['subtitle'] ?? 'Unknown Subtitle',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        if (item['tag'] != null)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              item['tag'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        Spacer(),
                        Icon(
                          Icons.play_circle_outline,
                          color: Colors.white,
                          size: 32.sp,
                        ),
                      ],
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

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sort by'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _sortOptions.map((option) {
            return ListTile(
              title: Text(option),
              leading: Radio<String>(
                value: option,
                groupValue: _sortBy,
                onChanged: (value) {
                  setState(() {
                    _sortBy = value!;
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
} 