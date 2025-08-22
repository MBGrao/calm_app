import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../modules/home/views/search_results_screen.dart';
import '../data/models/content_model.dart';
import '../widgets/interactive_feedback.dart';

class DiscovrSearhBox extends StatefulWidget {
  const DiscovrSearhBox({super.key});

  @override
  State<DiscovrSearhBox> createState() => _DiscovrSearhBoxState();
}

class _DiscovrSearhBoxState extends State<DiscovrSearhBox> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<String> _searchHistory = [];
  List<ContentModel> _searchSuggestions = [];
  List<String> _autocompleteSuggestions = [];
  bool _showSuggestions = false;
  bool _isListening = false;
  bool _isLoadingSuggestions = false;

  // Search filters
  String _selectedCategory = 'All';
  String _selectedDuration = 'All';
  String _selectedType = 'All';

  final List<String> _categories = ['All', 'Meditation', 'Sleep', 'Breathing', 'Relaxation', 'Nature', 'Music'];
  final List<String> _durations = ['All', '0-5 min', '5-10 min', '10-20 min', '20+ min'];
  final List<String> _types = ['All', 'Guided', 'Music', 'Nature', 'Breathing', 'Stories'];

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _loadSearchHistory() {
    // In a real app, this would load from SharedPreferences
    _searchHistory = [
      'meditation for anxiety',
      'sleep stories',
      'breathing exercises',
      'relaxation music',
      'nature sounds',
      'mindfulness',
      'stress relief',
      'deep sleep'
    ];
  }

  void _saveSearchHistory(String query) {
    if (query.isNotEmpty && !_searchHistory.contains(query)) {
      setState(() {
        _searchHistory.insert(0, query);
        if (_searchHistory.length > 10) {
          _searchHistory.removeLast();
        }
      });
      // In a real app, this would save to SharedPreferences
    }
  }

  void _clearSearchHistory() {
    setState(() {
      _searchHistory.clear();
    });
    HapticFeedbackHelper.lightImpact();
    // In a real app, this would clear from SharedPreferences
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    
    if (query.isEmpty) {
      setState(() {
        _searchSuggestions = [];
        _autocompleteSuggestions = [];
        _showSuggestions = false;
      });
      return;
    }

    _updateSuggestions(query);
  }

  void _updateSuggestions(String query) {
    setState(() {
      _isLoadingSuggestions = true;
    });

    // Simulate API delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      // Generate autocomplete suggestions
      final autocompleteSuggestions = _generateAutocompleteSuggestions(query);
      
      // Get content suggestions
      final contentSuggestions = ContentRepository.searchContent(query).take(5).toList();
      
      setState(() {
        _autocompleteSuggestions = autocompleteSuggestions;
        _searchSuggestions = contentSuggestions;
        _showSuggestions = true;
        _isLoadingSuggestions = false;
      });
    });
  }

  List<String> _generateAutocompleteSuggestions(String query) {
    final lowercaseQuery = query.toLowerCase();
    final suggestions = <String>[];
    
    // Add popular search terms that match the query
    final popularTerms = [
      'meditation for anxiety',
      'sleep stories for adults',
      'breathing exercises for stress',
      'relaxation music for sleep',
      'nature sounds for meditation',
      'mindfulness exercises',
      'stress relief techniques',
      'deep sleep meditation',
      'morning meditation',
      'evening relaxation',
      'quick breathing exercise',
      'guided meditation for beginners',
      'sleep music for insomnia',
      'anxiety relief meditation',
      'focus and concentration'
    ];

    for (final term in popularTerms) {
      if (term.toLowerCase().contains(lowercaseQuery) && 
          !suggestions.contains(term) && 
          suggestions.length < 5) {
        suggestions.add(term);
      }
    }

    return suggestions;
  }

  void _performSearch(String query) {
    if (query.isEmpty) return;
    
    _saveSearchHistory(query);
    _searchFocusNode.unfocus();
    HapticFeedbackHelper.mediumImpact();
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchResultsScreen(
          initialQuery: query,
          initialFilters: {
            'category': _selectedCategory,
            'duration': _selectedDuration,
            'type': _selectedType,
          },
        ),
      ),
    );
  }

  void _startVoiceSearch() {
    setState(() {
      _isListening = true;
    });
    HapticFeedbackHelper.lightImpact();

    // Simulate voice search
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isListening = false;
          _searchController.text = 'meditation for stress relief';
        });
        _performSearch('meditation for stress relief');
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchSuggestions = [];
      _autocompleteSuggestions = [];
      _showSuggestions = false;
    });
    HapticFeedbackHelper.lightImpact();
  }

  void _applyFilters() {
    HapticFeedbackHelper.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1B4B6F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildFiltersSheet(),
    );
  }

  Widget _buildFiltersSheet() {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Search Filters',
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
          
          // Category Filter
          Text(
            'Category',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: _categories.map((category) {
              final isSelected = _selectedCategory == category;
              return FilterChip(
                label: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? const Color(0xFF1B4B6F) : Colors.white,
                    fontSize: 14.sp,
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedCategory = category;
                  });
                  HapticFeedbackHelper.lightImpact();
                },
                backgroundColor: Colors.transparent,
                selectedColor: Colors.white,
                side: BorderSide(
                  color: isSelected ? Colors.white : Colors.white30,
                ),
              );
            }).toList(),
          ),
          
          SizedBox(height: 20.h),
          
          // Duration Filter
          Text(
            'Duration',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: _durations.map((duration) {
              final isSelected = _selectedDuration == duration;
              return FilterChip(
                label: Text(
                  duration,
                  style: TextStyle(
                    color: isSelected ? const Color(0xFF1B4B6F) : Colors.white,
                    fontSize: 14.sp,
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedDuration = duration;
                  });
                  HapticFeedbackHelper.lightImpact();
                },
                backgroundColor: Colors.transparent,
                selectedColor: Colors.white,
                side: BorderSide(
                  color: isSelected ? Colors.white : Colors.white30,
                ),
              );
            }).toList(),
          ),
          
          SizedBox(height: 20.h),
          
          // Type Filter
          Text(
            'Type',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: _types.map((type) {
              final isSelected = _selectedType == type;
              return FilterChip(
                label: Text(
                  type,
                  style: TextStyle(
                    color: isSelected ? const Color(0xFF1B4B6F) : Colors.white,
                    fontSize: 14.sp,
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedType = type;
                  });
                  HapticFeedbackHelper.lightImpact();
                },
                backgroundColor: Colors.transparent,
                selectedColor: Colors.white,
                side: BorderSide(
                  color: isSelected ? Colors.white : Colors.white30,
                ),
              );
            }).toList(),
          ),
          
          SizedBox(height: 24.h),
          
          // Apply Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                HapticFeedbackHelper.mediumImpact();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Apply Filters',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Color.fromARGB(255, 177, 177, 177),
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Image.asset("assets/icons/home_screen/light.png", height: 20.h),
              const SizedBox(width: 10),
              Image.asset("assets/icons/home_screen/line.png", height: 24),
              const SizedBox(width: 10),
              Image.asset("assets/icons/home_screen/search_icon.png", height: 20.h),
              const SizedBox(width: 10),
              
              Expanded(
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  onSubmitted: _performSearch,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search meditation, sleep, breathing...',
                    hintStyle: TextStyle(
                      color: Colors.white54, 
                      fontSize: 17, 
                      fontWeight: FontWeight.w400
                    ),
                    isCollapsed: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_searchController.text.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.clear, color: Colors.white70),
                            onPressed: _clearSearch,
                          ),
                        IconButton(
                          icon: Icon(
                            _isListening ? Icons.mic : Icons.mic_none,
                            color: _isListening ? Colors.orange : Colors.white70,
                          ),
                          onPressed: _startVoiceSearch,
                        ),
                        IconButton(
                          icon: const Icon(Icons.tune, color: Colors.white70),
                          onPressed: _applyFilters,
                        ),
                      ],
                    ),
                  ),
                  style: TextStyle(color: Colors.white, fontSize: 17),
                  cursorColor: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        
        // Search suggestions dropdown
        if (_showSuggestions)
          Container(
            margin: EdgeInsets.only(top: 4.h),
            decoration: BoxDecoration(
              color: const Color(0xFF1B4B6F),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recent searches
                if (_searchHistory.isNotEmpty) ...[
                  Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Searches',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: _clearSearchHistory,
                          child: Text(
                            'Clear',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ..._searchHistory.take(3).map((query) => ListTile(
                    leading: const Icon(Icons.history, color: Colors.white70, size: 20),
                    title: Text(
                      query,
                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    ),
                    onTap: () => _performSearch(query),
                  )),
                  Divider(color: Colors.white.withOpacity(0.2), height: 1),
                ],
                
                // Autocomplete suggestions
                if (_autocompleteSuggestions.isNotEmpty) ...[
                  Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Text(
                      'Suggestions',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ..._autocompleteSuggestions.map((suggestion) => ListTile(
                    leading: const Icon(Icons.search, color: Colors.white70, size: 20),
                    title: Text(
                      suggestion,
                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    ),
                    onTap: () => _performSearch(suggestion),
                  )),
                  Divider(color: Colors.white.withOpacity(0.2), height: 1),
                ],
                
                // Content suggestions
                if (_searchSuggestions.isNotEmpty) ...[
                  Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Text(
                      'Content',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ..._searchSuggestions.map((content) => ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        content.imageUrl,
                        width: 40.w,
                        height: 40.w,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 40.w,
                            height: 40.w,
                            color: Colors.white.withOpacity(0.1),
                            child: const Icon(Icons.image, color: Colors.white70),
                          );
                        },
                      ),
                    ),
                    title: Text(
                      content.title,
                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    ),
                    subtitle: Text(
                      content.subtitle,
                      style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                    ),
                    trailing: content.isPremium 
                      ? const Icon(Icons.diamond, color: Colors.orange, size: 16)
                      : null,
                    onTap: () => _performSearch(content.title),
                  )),
                ],
                
                // Loading indicator
                if (_isLoadingSuggestions)
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}