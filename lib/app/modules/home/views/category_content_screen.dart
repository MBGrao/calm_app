import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../data/models/content_model.dart';
import '../../../services/content_service.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/error_widget.dart';
import '../../../widgets/rating_widget.dart';
import 'content_detail_screen.dart';

class CategoryContentScreen extends StatefulWidget {
  final String category;
  final String displayName;

  const CategoryContentScreen({
    Key? key,
    required this.category,
    required this.displayName,
  }) : super(key: key);

  @override
  State<CategoryContentScreen> createState() => _CategoryContentScreenState();
}

class _CategoryContentScreenState extends State<CategoryContentScreen> {
  final ScrollController _scrollController = ScrollController();
  
  List<ContentModel> _content = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _isError = false;
  String _errorMessage = '';
  
  int _currentPage = 1;
  bool _hasMoreData = true;
  
  String _sortBy = 'createdAt';
  String _sortOrder = 'DESC';

  @override
  void initState() {
    super.initState();
    _loadContent();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreContent();
    }
  }

  Future<void> _loadContent({bool refresh = false}) async {
    try {
      if (refresh) {
        setState(() {
          _isLoading = true;
          _isError = false;
          _currentPage = 1;
          _content.clear();
        });
      }

      final newContent = await ContentService.getContentByCategory(
        widget.category,
        limit: 20,
        page: _currentPage,
        sortBy: _sortBy,
        sortOrder: _sortOrder,
      );

      setState(() {
        if (refresh) {
          _content = newContent;
        } else {
          _content.addAll(newContent);
        }
        _isLoading = false;
        _isError = false;
        _hasMoreData = newContent.isNotEmpty;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isError = true;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _loadMoreContent() async {
    if (_isLoadingMore || !_hasMoreData) return;

    try {
      setState(() {
        _isLoadingMore = true;
      });

      _currentPage++;
      
      final newContent = await ContentService.getContentByCategory(
        widget.category,
        limit: 20,
        page: _currentPage,
      );

      setState(() {
        _content.addAll(newContent);
        _isLoadingMore = false;
        _hasMoreData = newContent.isNotEmpty;
      });
    } catch (e) {
      setState(() {
        _isLoadingMore = false;
        _currentPage--;
      });
    }
  }

  void _navigateToContentDetail(ContentModel content) {
    Get.to(() => ContentDetailScreen(
      contentId: content.id,
      content: content,
    ));
  }

  void _changeSort(String sortBy, String sortOrder) {
    setState(() {
      _sortBy = sortBy;
      _sortOrder = sortOrder;
    });
    _loadContent(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B4B6F),
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            _buildAppBar(),
            
            // Sort Options
            _buildSortOptions(),
            
            // Content Grid
            Expanded(
              child: _isLoading
                  ? const LoadingWidget()
                  : _isError
                      ? CustomErrorWidget(
                          message: _errorMessage,
                          onRetry: () => _loadContent(refresh: true),
                        )
                      : _buildContentGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.displayName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_content.length} items',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _loadContent(refresh: true),
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSortOptions() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: PopupMenuButton<String>(
              onSelected: (sort) {
                final parts = sort.split('_');
                _changeSort(parts[0], parts[1]);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.sort, color: Colors.white, size: 16),
                    SizedBox(width: 4.w),
                    Text(
                      'Sort by',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    const Icon(Icons.arrow_drop_down, color: Colors.white, size: 16),
                  ],
                ),
              ),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'createdAt_DESC',
                  child: Text('Newest First'),
                ),
                const PopupMenuItem(
                  value: 'createdAt_ASC',
                  child: Text('Oldest First'),
                ),
                const PopupMenuItem(
                  value: 'playCount_DESC',
                  child: Text('Most Popular'),
                ),
                const PopupMenuItem(
                  value: 'rating_DESC',
                  child: Text('Highest Rated'),
                ),
                const PopupMenuItem(
                  value: 'duration_ASC',
                  child: Text('Shortest First'),
                ),
                const PopupMenuItem(
                  value: 'duration_DESC',
                  child: Text('Longest First'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentGrid() {
    if (_content.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category_outlined,
              size: 64.w,
              color: Colors.white.withOpacity(0.5),
            ),
            SizedBox(height: 16.h),
            Text(
              'No content in this category',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Check back later for new content',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
      ),
      itemCount: _content.length + (_hasMoreData ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _content.length) {
          return _buildLoadingMoreItem();
        }
        
        final content = _content[index];
        return _buildContentCard(content);
      },
    );
  }

  Widget _buildContentCard(ContentModel content) {
    return GestureDetector(
      onTap: () => _navigateToContentDetail(content),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white.withOpacity(0.1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  content.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[800],
                    child: const Icon(Icons.error, color: Colors.white),
                  ),
                ),
              ),
            ),
            
            // Content Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      content.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    
                    // Subtitle
                    Text(
                      content.subtitle,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    
                    // Bottom Row
                    Row(
                      children: [
                        // Rating
                        RatingWidget(
                          rating: content.rating,
                          size: 12,
                          showText: false,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '(${content.rating})',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 10.sp,
                          ),
                        ),
                        const Spacer(),
                        
                        // Duration
                        Text(
                          content.formattedDuration,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 10.sp,
                          ),
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

  Widget _buildLoadingMoreItem() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.1),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
} 