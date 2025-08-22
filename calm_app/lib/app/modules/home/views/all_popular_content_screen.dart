import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'content_detail_screen.dart';
import '../../../widgets/interactive_feedback.dart';
import '../../../data/models/content_model.dart';

class AllPopularContentScreen extends StatefulWidget {
  final String category;
  final List<Map<String, dynamic>> content;

  const AllPopularContentScreen({
    Key? key,
    required this.category,
    required this.content,
  }) : super(key: key);

  @override
  State<AllPopularContentScreen> createState() => _AllPopularContentScreenState();
}

class _AllPopularContentScreenState extends State<AllPopularContentScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  List<Map<String, dynamic>> _filteredContent = [];
  bool _isLoading = false;
  String _sortBy = 'Popular';

  final List<String> _filterOptions = ['All', 'Music', 'Meditation', 'Podcast', 'Sleep'];
  final List<String> _sortOptions = ['Popular', 'Recent', 'Duration', 'Alphabetical'];

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
      case 'Recent':
        _filteredContent.sort((a, b) => (b['date'] ?? '').compareTo(a['date'] ?? ''));
        break;
      case 'Duration':
        _filteredContent.sort((a, b) => (a['duration'] ?? '').compareTo(b['duration'] ?? ''));
        break;
      case 'Alphabetical':
        _filteredContent.sort((a, b) => (a['title'] ?? '').compareTo(b['title'] ?? ''));
        break;
      default: // Popular
        // Keep original order for popular
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
                    hintText: 'Search popular content...',
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
          // Content Grid
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
                              'No content found',
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
                    : GridView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 12.w,
                          mainAxisSpacing: 12.h,
                        ),
                        itemCount: _filteredContent.length + 1, // +1 for pagination indicator
                        itemBuilder: (context, index) {
                          if (index == _filteredContent.length) {
                            // Pagination indicator
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      strokeWidth: 2,
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      'Loading more...',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          
                          final item = _filteredContent[index];
                          return _buildContentCard(context, item);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentCard(BuildContext context, Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        HapticFeedbackHelper.lightImpact();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ContentDetailScreen(
              contentId: item['id'] ?? 'popular-${item['title']?.toString().toLowerCase().replaceAll(' ', '-')}',
              content: ContentModel.fromMap({
                'id': item['id'] ?? 'popular-${item['title']?.toString().toLowerCase().replaceAll(' ', '-')}',
                'imageUrl': item['imageUrl'] ?? 'https://via.placeholder.com/400x300',
                'title': item['title'] ?? 'Unknown Title',
                'subtitle': item['subtitle'] ?? 'Unknown Subtitle',
                'description': 'Popular content loved by many users.',
                'category': item['tag'] ?? 'popular',
                'tags': [item['tag'] ?? 'popular'],
                'duration': 300,
                'author': 'Content Creator',
                'rating': 4.5,
                'playCount': 500,
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
            // Image
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Stack(
                  children: [
                    Image.network(
                      item['imageUrl'] ?? 'https://via.placeholder.com/400x300',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          item['tag'] ?? 'Popular',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 16.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Content
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'] ?? 'Unknown Title',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
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