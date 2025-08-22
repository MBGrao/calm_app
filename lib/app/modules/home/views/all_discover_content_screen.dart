import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'content_detail_screen.dart';
import '../../../widgets/interactive_feedback.dart';
import '../../../data/models/content_model.dart';

class AllDiscoverContentScreen extends StatefulWidget {
  final String category;
  final List<Map<String, dynamic>> content;

  const AllDiscoverContentScreen({
    Key? key,
    required this.category,
    required this.content,
  }) : super(key: key);

  @override
  State<AllDiscoverContentScreen> createState() => _AllDiscoverContentScreenState();
}

class _AllDiscoverContentScreenState extends State<AllDiscoverContentScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  List<Map<String, dynamic>> _filteredContent = [];
  bool _isLoading = false;
  String _sortBy = 'Discover';
  String _viewMode = 'Grid'; // Grid or List

  final List<String> _filterOptions = ['All', 'Meditation', 'Music', 'Sleep', 'Podcast', 'Breathing', 'Nature'];
  final List<String> _sortOptions = ['Discover', 'Trending', 'New', 'Duration', 'Alphabetical'];

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
      case 'Trending':
        _filteredContent.sort((a, b) => (b['trending'] ?? 0).compareTo(a['trending'] ?? 0));
        break;
      case 'New':
        _filteredContent.sort((a, b) => (b['date'] ?? '').compareTo(a['date'] ?? ''));
        break;
      case 'Duration':
        _filteredContent.sort((a, b) => (a['duration'] ?? '').compareTo(b['duration'] ?? ''));
        break;
      case 'Alphabetical':
        _filteredContent.sort((a, b) => (a['title'] ?? '').compareTo(b['title'] ?? ''));
        break;
      default: // Discover
        // Keep original order for discover
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
          // View mode toggle
          IconButton(
            icon: Icon(
              _viewMode == 'Grid' ? Icons.view_list : Icons.grid_view,
              color: Colors.white,
            ),
            onPressed: () {
              HapticFeedbackHelper.lightImpact();
              setState(() {
                _viewMode = _viewMode == 'Grid' ? 'List' : 'Grid';
              });
            },
          ),
          // Sort button
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
                    hintText: 'Discover new content...',
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
                    Spacer(),
                    Text(
                      'View: $_viewMode',
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
          // Content
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
                              Icons.explore_off,
                              color: Colors.white70,
                              size: 64.sp,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'No content to discover',
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
                    : _viewMode == 'Grid'
                        ? _buildGridView()
                        : _buildListView(),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
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
                    'Discovering more...',
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
        return _buildGridCard(context, item);
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
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
                    'Discovering more content...',
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
        return _buildListCard(context, item);
      },
    );
  }

  Widget _buildGridCard(BuildContext context, Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        HapticFeedbackHelper.lightImpact();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ContentDetailScreen(
              contentId: item['id'] ?? 'discover-${item['title']?.toString().toLowerCase().replaceAll(' ', '-')}',
              content: ContentModel.fromMap({
                'id': item['id'] ?? 'discover-${item['title']?.toString().toLowerCase().replaceAll(' ', '-')}',
                'imageUrl': item['imageUrl'] ?? 'https://via.placeholder.com/400x300',
                'title': item['title'] ?? 'Unknown Title',
                'subtitle': item['subtitle'] ?? 'Unknown Subtitle',
                'description': 'Discover new content tailored for you.',
                'category': item['tag'] ?? 'discover',
                'tags': [item['tag'] ?? 'discover'],
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
                          color: Colors.green.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'New',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
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

  Widget _buildListCard(BuildContext context, Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        HapticFeedbackHelper.lightImpact();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ContentDetailScreen(
              contentId: item['id'] ?? 'discover-${item['title']?.toString().toLowerCase().replaceAll(' ', '-')}',
              content: ContentModel.fromMap({
                'id': item['id'] ?? 'discover-${item['title']?.toString().toLowerCase().replaceAll(' ', '-')}',
                'imageUrl': item['imageUrl'] ?? 'https://via.placeholder.com/400x300',
                'title': item['title'] ?? 'Unknown Title',
                'subtitle': item['subtitle'] ?? 'Unknown Subtitle',
                'description': 'Discover new content tailored for you.',
                'category': item['tag'] ?? 'discover',
                'tags': [item['tag'] ?? 'discover'],
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
                        color: Colors.green.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Discover',
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
                              color: Colors.purple.withOpacity(0.8),
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