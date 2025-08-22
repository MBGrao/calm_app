import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/models/content_model.dart';
import '../../../services/content_service.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/error_widget.dart';
import '../../../widgets/rating_widget.dart';
import 'content_detail_screen.dart';

class AllContentScreen extends StatefulWidget {
  final String? category;
  final String? searchQuery;
  final String title;

  const AllContentScreen({
    Key? key,
    this.category,
    this.searchQuery,
    this.title = 'All Content',
  }) : super(key: key);

  @override
  State<AllContentScreen> createState() => _AllContentScreenState();
}

class _AllContentScreenState extends State<AllContentScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  List<ContentModel> _content = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _isError = false;
  String _errorMessage = '';
  
  int _currentPage = 1;
  int _totalPages = 1;
  bool _hasMoreData = true;
  
  String _currentSearch = '';
  String _currentCategory = '';
  String _sortBy = 'createdAt';
  String _sortOrder = 'DESC';

  @override
  void initState() {
    super.initState();
    _currentCategory = widget.category ?? '';
    _currentSearch = widget.searchQuery ?? '';
    _searchController.text = _currentSearch;
    _loadContent();
    
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreContent();
    }
  }

  void _changeSort(String sortBy, String sortOrder) {
    setState(() {
      _sortBy = sortBy;
      _sortOrder = sortOrder;
    });
    _loadContent(refresh: true);
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

      List<ContentModel> newContent;
      
      if (_currentSearch.isNotEmpty) {
        newContent = await ContentService.searchContent(
          _currentSearch,
          limit: 20,
        );
        _totalPages = 1;
        _hasMoreData = false;
      } else if (_currentCategory.isNotEmpty) {
        newContent = await ContentService.getContentByCategory(
          _currentCategory,
          limit: 20,
        );
        _totalPages = 1;
        _hasMoreData = false;
      } else {
        final response = await ContentService.getAllContent(
          page: _currentPage,
          limit: 20,
          category: _currentCategory.isNotEmpty ? _currentCategory : null,
          search: _currentSearch.isNotEmpty ? _currentSearch : null,
          sortBy: _sortBy,
          sortOrder: _sortOrder,
        );
        newContent = response;
        _totalPages = (_content.length / 20).ceil();
        _hasMoreData = _currentPage < _totalPages;
      }

      setState(() {
        if (refresh) {
          _content = newContent;
        } else {
          _content.addAll(newContent);
        }
        _isLoading = false;
        _isError = false;
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
      
      final newContent = await ContentService.getAllContent(
        page: _currentPage,
        limit: 20,
        category: _currentCategory.isNotEmpty ? _currentCategory : null,
        search: _currentSearch.isNotEmpty ? _currentSearch : null,
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

  void _performSearch() {
    _currentSearch = _searchController.text.trim();
    _loadContent(refresh: true);
  }

  void _clearSearch() {
    _searchController.clear();
    _currentSearch = '';
    _loadContent(refresh: true);
  }

  void _navigateToContentDetail(ContentModel content) {
    Get.to(() => ContentDetailScreen(
      contentId: content.id,
      content: content,
    ));
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
            
            // Search Bar
            _buildSearchBar(),
            
            // Filter and Sort
            _buildFilterSort(),
            
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
            child: Text(
              widget.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
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

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: TextField(
        controller: _searchController,
        onSubmitted: (_) => _performSearch(),
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search content...',
          hintStyle: TextStyle(color: Colors.white70),
          prefixIcon: const Icon(Icons.search, color: Colors.white70),
          suffixIcon: _currentSearch.isNotEmpty
              ? IconButton(
                  onPressed: _clearSearch,
                  icon: const Icon(Icons.clear, color: Colors.white70),
                )
              : null,
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        ),
      ),
    );
  }

  Widget _buildFilterSort() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          // Category Filter
          Expanded(
            child: PopupMenuButton<String>(
              onSelected: (category) {
                setState(() {
                  _currentCategory = category;
                });
                _loadContent(refresh: true);
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
                    const Icon(Icons.filter_list, color: Colors.white, size: 16),
                    SizedBox(width: 4.w),
                    Text(
                      _currentCategory.isEmpty ? 'All Categories' : _currentCategory,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    const Icon(Icons.arrow_drop_down, color: Colors.white, size: 16),
                  ],
                ),
              ),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: '',
                  child: Text('All Categories'),
                ),
                const PopupMenuItem(
                  value: 'meditation',
                  child: Text('Meditation'),
                ),
                const PopupMenuItem(
                  value: 'sleep',
                  child: Text('Sleep Stories'),
                ),
                const PopupMenuItem(
                  value: 'breathing',
                  child: Text('Breathing'),
                ),
                const PopupMenuItem(
                  value: 'relaxation',
                  child: Text('Relaxation'),
                ),
                const PopupMenuItem(
                  value: 'music',
                  child: Text('Music'),
                ),
                const PopupMenuItem(
                  value: 'nature',
                  child: Text('Nature'),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          
          // Sort Options
          PopupMenuButton<String>(
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
                  const Text(
                    'Sort',
                    style: TextStyle(color: Colors.white, fontSize: 12),
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
              Icons.search_off,
              size: 64.w,
              color: Colors.white.withOpacity(0.5),
            ),
            SizedBox(height: 16.h),
            Text(
              'No content found',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 16.sp,
              ),
            ),
            if (_currentSearch.isNotEmpty || _currentCategory.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Text(
                'Try adjusting your search or filters',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 14.sp,
                ),
              ),
            ],
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
                child: CachedNetworkImage(
                  imageUrl: content.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[800],
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
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