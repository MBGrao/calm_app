import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/models/content_model.dart';
import '../../../services/search_service.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/error_widget.dart';
import '../../../widgets/rating_widget.dart';
import '../../../widgets/custom_button.dart';
import 'content_detail_screen.dart';

class SearchResultsScreen extends StatefulWidget {
  final String initialQuery;
  final Map<String, dynamic>? initialFilters;

  const SearchResultsScreen({
    Key? key,
    required this.initialQuery,
    this.initialFilters,
  }) : super(key: key);

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _searchFocusNode = FocusNode();
  
  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  // Search state
  String _currentQuery = '';
  bool _isSearching = false;
  bool _isLoadingMore = false;
  bool _showSuggestions = false;
  bool _hasError = false;
  String _errorMessage = '';
  
  // Search results
  SearchResult? _searchResult;
  List<SearchSuggestion> _suggestions = [];
  List<String> _trendingSearches = [];
  
  // Filters
  String _selectedCategory = '';
  List<String> _selectedTags = [];
  int? _minDuration;
  int? _maxDuration;
  bool? _isPremium;
  String _sortBy = 'relevance';
  String _sortOrder = 'DESC';
  
  // Advanced search
  bool _showAdvancedFilters = false;
  bool _showFilterPanel = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeSearch();
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _searchFocusNode.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  void _initializeSearch() {
    _currentQuery = widget.initialQuery;
    _searchController.text = _currentQuery;
    
    if (widget.initialFilters != null) {
      _selectedCategory = widget.initialFilters!['category'] ?? '';
      _selectedTags = List<String>.from(widget.initialFilters!['tags'] ?? []);
      _minDuration = widget.initialFilters!['minDuration'];
      _maxDuration = widget.initialFilters!['maxDuration'];
      _isPremium = widget.initialFilters!['isPremium'];
      _sortBy = widget.initialFilters!['sortBy'] ?? 'relevance';
      _sortOrder = widget.initialFilters!['sortOrder'] ?? 'DESC';
    }

    _loadInitialData();
    _performSearch();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query != _currentQuery) {
      _currentQuery = query;
      if (query.length >= 2) {
        _getSearchSuggestions();
        setState(() {
          _showSuggestions = true;
        });
      } else {
        setState(() {
          _showSuggestions = false;
        });
      }
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreResults();
    }
  }

  Future<void> _loadInitialData() async {
    try {
      final trending = await SearchService.getTrendingSearches();
      setState(() {
        _trendingSearches = trending;
      });
    } catch (e) {
      print('Failed to load trending searches: $e');
    }
  }

  Future<void> _getSearchSuggestions() async {
    try {
      final suggestions = await SearchService.getSearchSuggestions(_currentQuery);
      setState(() {
        _suggestions = suggestions;
      });
    } catch (e) {
      print('Failed to get search suggestions: $e');
    }
  }

  Future<void> _performSearch({bool isNewSearch = true}) async {
    if (_currentQuery.trim().isEmpty) return;

    try {
      setState(() {
        _isSearching = true;
        _showSuggestions = false;
        _hasError = false;
      });

      // Save search query to history
      await SearchService.saveSearchQuery(_currentQuery);

      final result = await SearchService.searchContent(
        query: _currentQuery,
        page: isNewSearch ? 1 : (_searchResult?.page ?? 1) + 1,
        limit: 20,
        category: _selectedCategory.isNotEmpty ? _selectedCategory : null,
        tags: _selectedTags.isNotEmpty ? _selectedTags : null,
        minDuration: _minDuration,
        maxDuration: _maxDuration,
        isPremium: _isPremium,
        sortBy: _sortBy,
        sortOrder: _sortOrder,
      );

      setState(() {
        if (isNewSearch) {
          _searchResult = result;
        } else {
          _searchResult = SearchResult(
            content: [...(_searchResult?.content ?? []), ...result.content],
            total: result.total,
            page: result.page,
            limit: result.limit,
            totalPages: result.totalPages,
            hasNextPage: result.hasNextPage,
            hasPrevPage: result.hasPrevPage,
            categoryCounts: result.categoryCounts,
            suggestedQueries: result.suggestedQueries,
          );
        }
        _isSearching = false;
        _isLoadingMore = false;
      });

    } catch (e) {
      setState(() {
        _isSearching = false;
        _isLoadingMore = false;
        _hasError = true;
        _errorMessage = e.toString();
      });
      _showErrorSnackBar('Search failed: $e');
    }
  }

  Future<void> _loadMoreResults() async {
    if (_isLoadingMore || !(_searchResult?.hasNextPage ?? false)) return;

    setState(() {
      _isLoadingMore = true;
    });

    await _performSearch(isNewSearch: false);
  }

  void _selectSuggestion(SearchSuggestion suggestion) {
    _searchController.text = suggestion.query;
    _searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: suggestion.query.length),
    );
    _performSearch();
  }

  void _selectTrendingSearch(String query) {
    _searchController.text = query;
    _searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: query.length),
    );
    _performSearch();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _currentQuery = '';
      _searchResult = null;
      _showSuggestions = false;
      _hasError = false;
    });
  }

  void _toggleFilterPanel() {
    setState(() {
      _showFilterPanel = !_showFilterPanel;
    });
  }

  void _applyFilters() {
    _performSearch();
  }

  void _resetFilters() {
    setState(() {
      _selectedCategory = '';
      _selectedTags.clear();
      _minDuration = null;
      _maxDuration = null;
      _isPremium = null;
      _sortBy = 'relevance';
      _sortOrder = 'DESC';
    });
    _performSearch();
  }

  void _navigateToContentDetail(ContentModel content) {
    Get.to(() => ContentDetailScreen(
      contentId: content.id,
      content: content,
    ));
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B4B6F),
      body: SafeArea(
        child: Column(
          children: [
            // Search Header
            _buildSearchHeader(),
            
            // Advanced Filters
            if (_showAdvancedFilters) _buildAdvancedFilters(),
            
            // Filter Panel
            if (_showFilterPanel) _buildFilterPanel(),
            
            // Content
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          // Search Bar
          Row(
            children: [
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  onSubmitted: (_) => _performSearch(),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search meditation, sleep stories, music...',
                    hintStyle: TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.search, color: Colors.white70),
                    suffixIcon: _currentQuery.isNotEmpty
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
              ),
              IconButton(
                onPressed: _toggleFilterPanel,
                icon: Icon(
                  _showFilterPanel ? Icons.filter_list : Icons.tune,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          
          // Quick Actions
          if (_searchResult != null) ...[
            SizedBox(height: 12.h),
            _buildQuickActions(),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Text(
          '${_searchResult!.total} results',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12.sp,
          ),
        ),
        const Spacer(),
        if (_searchResult!.suggestedQueries.isNotEmpty)
          TextButton(
            onPressed: () {
              _searchController.text = _searchResult!.suggestedQueries.first;
              _performSearch();
            },
            child: Text(
              'Try: ${_searchResult!.suggestedQueries.first}',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 12.sp,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFilterPanel() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
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
              Text(
                'Filters',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: _resetFilters,
                child: Text(
                  'Reset',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          
          // Category Filter
          DropdownButtonFormField<String>(
            value: _selectedCategory.isEmpty ? null : _selectedCategory,
            onChanged: (value) {
              setState(() {
                _selectedCategory = value ?? '';
              });
            },
            decoration: InputDecoration(
              labelText: 'Category',
              labelStyle: TextStyle(color: Colors.white70),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            dropdownColor: const Color(0xFF1B4B6F),
            style: const TextStyle(color: Colors.white),
            items: [
              const DropdownMenuItem(value: '', child: Text('All Categories')),
              const DropdownMenuItem(value: 'meditation', child: Text('Meditation')),
              const DropdownMenuItem(value: 'sleep', child: Text('Sleep Stories')),
              const DropdownMenuItem(value: 'breathing', child: Text('Breathing')),
              const DropdownMenuItem(value: 'relaxation', child: Text('Relaxation')),
              const DropdownMenuItem(value: 'music', child: Text('Music')),
              const DropdownMenuItem(value: 'nature', child: Text('Nature')),
            ],
          ),
          SizedBox(height: 12.h),
          
          // Duration Filter
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Min Duration (min)',
                    labelStyle: TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) {
                    _minDuration = int.tryParse(value);
                  },
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Max Duration (min)',
                    labelStyle: TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) {
                    _maxDuration = int.tryParse(value);
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          
          // Premium Filter
          Row(
            children: [
              Checkbox(
                value: _isPremium,
                onChanged: (value) {
                  setState(() {
                    _isPremium = value;
                  });
                },
                fillColor: WidgetStateProperty.resolveWith(
                  (states) => Colors.white.withOpacity(0.2),
                ),
              ),
              Text(
                'Premium Content Only',
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          
          // Sort Options
          Row(
            children: [
              Text(
                'Sort by: ',
                style: TextStyle(color: Colors.white70, fontSize: 14.sp),
              ),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _sortBy,
                  onChanged: (value) {
                    setState(() {
                      _sortBy = value ?? 'relevance';
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  dropdownColor: const Color(0xFF1B4B6F),
                  style: const TextStyle(color: Colors.white),
                  items: [
                    const DropdownMenuItem(value: 'relevance', child: Text('Relevance')),
                    const DropdownMenuItem(value: 'title', child: Text('Title')),
                    const DropdownMenuItem(value: 'duration', child: Text('Duration')),
                    const DropdownMenuItem(value: 'rating', child: Text('Rating')),
                    const DropdownMenuItem(value: 'playCount', child: Text('Popularity')),
                    const DropdownMenuItem(value: 'createdAt', child: Text('Date')),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          
          // Apply Button
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              onPressed: _applyFilters,
              text: 'Apply Filters',
              backgroundColor: Colors.blue,
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedFilters() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Advanced Filters',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          
          // Category counts
          if (_searchResult?.categoryCounts != null) ...[
            Text(
              'Categories',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: _searchResult!.categoryCounts.entries.map((entry) {
                final isSelected = _selectedCategory == entry.key;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = isSelected ? '' : entry.key;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${entry.key} (${entry.value})',
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 16.h),
          ],
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isSearching) {
      return const LoadingWidget();
    }

    if (_showSuggestions) {
      return _buildSuggestions();
    }

    if (_hasError) {
      return CustomErrorWidget(
        message: _errorMessage,
        onRetry: () => _performSearch(),
      );
    }

    if (_searchResult == null) {
      return _buildInitialState();
    }

    if (_searchResult!.content.isEmpty) {
      return _buildNoResults();
    }

    return _buildSearchResults();
  }

  Widget _buildInitialState() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Trending Searches
              if (_trendingSearches.isNotEmpty) ...[
                Text(
                  'Trending Searches',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: _trendingSearches.map((query) => GestureDetector(
                    onTap: () => _selectTrendingSearch(query),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        query,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  )).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: _suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = _suggestions[index];
        return ListTile(
          leading: Icon(
            _getSuggestionIcon(suggestion.type),
            color: Colors.white70,
          ),
          title: Text(
            suggestion.query,
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: suggestion.subtitle != null ? Text(
            suggestion.subtitle!,
            style: TextStyle(color: Colors.white70, fontSize: 12.sp),
          ) : null,
          trailing: suggestion.count != null ? Text(
            '${suggestion.count}',
            style: TextStyle(color: Colors.white70, fontSize: 12.sp),
          ) : null,
          onTap: () => _selectSuggestion(suggestion),
        );
      },
    );
  }

  Widget _buildNoResults() {
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
            'No results found',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Try adjusting your search terms or filters',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14.sp,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          CustomButton(
            onPressed: _resetFilters,
            text: 'Clear Filters',
            backgroundColor: Colors.blue,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(16.w),
      itemCount: _searchResult!.content.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _searchResult!.content.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final content = _searchResult!.content[index];
        return _buildContentCard(content);
      },
    );
  }

  Widget _buildContentCard(ContentModel content) {
    return GestureDetector(
      onTap: () => _navigateToContentDetail(content),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: content.imageUrl,
                width: 80.w,
                height: 80.w,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 80.w,
                  height: 80.w,
                  color: Colors.grey[800],
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 80.w,
                  height: 80.w,
                  color: Colors.grey[800],
                  child: const Icon(Icons.error, color: Colors.white),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            
            // Content Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    content.title,
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
                    content.subtitle,
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
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Icon(Icons.access_time, color: Colors.white70, size: 12.sp),
                      SizedBox(width: 4.w),
                      Text(
                        content.formattedDuration,
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
            
            // Premium Badge
            if (content.isPremium)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'PREMIUM',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getSuggestionIcon(String type) {
    switch (type) {
      case 'content':
        return Icons.play_circle_outline;
      case 'category':
        return Icons.category;
      case 'author':
        return Icons.person;
      case 'tag':
        return Icons.tag;
      default:
        return Icons.search;
    }
  }
} 