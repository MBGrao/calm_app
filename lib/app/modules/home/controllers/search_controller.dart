import 'package:get/get.dart';
import '../../../data/models/content_model.dart';
import '../../../services/search_service.dart';

class SearchController extends GetxController {
  // Observable variables
  final isLoading = false.obs;
  final isSearching = false.obs;
  final isLoadingMore = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  
  // Search results
  final searchResult = Rxn<SearchResult>();
  final suggestions = <SearchSuggestion>[].obs;
  final trendingSearches = <String>[].obs;
  final searchHistory = <String>[].obs;
  
  // Search state
  final currentQuery = ''.obs;
  final showSuggestions = false.obs;
  final showAdvancedFilters = false.obs;
  final showFilterPanel = false.obs;
  
  // Filters
  final selectedCategory = ''.obs;
  final selectedTags = <String>[].obs;
  final minDuration = Rxn<int>();
  final maxDuration = Rxn<int>();
  final isPremium = Rxn<bool>();
  final sortBy = 'relevance'.obs;
  final sortOrder = 'DESC'.obs;
  
  // Pagination
  final currentPage = 1.obs;
  final hasMoreResults = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  // Load initial data
  Future<void> loadInitialData() async {
    try {
      await Future.wait([
        loadTrendingSearches(),
        loadSearchHistory(),
      ]);
    } catch (e) {
      print('Failed to load initial data: $e');
    }
  }

  // Load trending searches
  Future<void> loadTrendingSearches() async {
    try {
      final trending = await SearchService.getTrendingSearches();
      trendingSearches.assignAll(trending);
    } catch (e) {
      print('Failed to load trending searches: $e');
    }
  }

  // Load search history
  Future<void> loadSearchHistory() async {
    try {
      final history = await SearchService.getSearchHistory();
      searchHistory.assignAll(history);
    } catch (e) {
      print('Failed to load search history: $e');
    }
  }

  // Get search suggestions
  Future<void> getSearchSuggestions(String query) async {
    try {
      if (query.length < 2) {
        suggestions.clear();
        return;
      }

      final suggestionList = await SearchService.getSearchSuggestions(query);
      suggestions.assignAll(suggestionList);
    } catch (e) {
      print('Failed to get search suggestions: $e');
    }
  }

  // Perform search
  Future<void> performSearch({
    String? query,
    bool isNewSearch = true,
    bool saveToHistory = true,
  }) async {
    final searchQuery = query ?? currentQuery.value;
    if (searchQuery.trim().isEmpty) return;

    try {
      isSearching.value = true;
      hasError.value = false;
      showSuggestions.value = false;

      if (isNewSearch) {
        currentPage.value = 1;
        currentQuery.value = searchQuery;
      }

      // Save to history if it's a new search
      if (saveToHistory && isNewSearch) {
        await SearchService.saveSearchQuery(searchQuery);
        await loadSearchHistory();
      }

      final result = await SearchService.searchContent(
        query: searchQuery,
        page: currentPage.value,
        limit: 20,
        category: selectedCategory.value.isNotEmpty ? selectedCategory.value : null,
        tags: selectedTags.isNotEmpty ? selectedTags : null,
        minDuration: minDuration.value,
        maxDuration: maxDuration.value,
        isPremium: isPremium.value,
        sortBy: sortBy.value,
        sortOrder: sortOrder.value,
      );

      if (isNewSearch) {
        searchResult.value = result;
      } else {
        final existingResult = searchResult.value;
        if (existingResult != null) {
          searchResult.value = SearchResult(
            content: [...existingResult.content, ...result.content],
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
      }

      hasMoreResults.value = result.hasNextPage;
      isSearching.value = false;
      isLoadingMore.value = false;

    } catch (e) {
      isSearching.value = false;
      isLoadingMore.value = false;
      hasError.value = true;
      errorMessage.value = e.toString();
      print('Search failed: $e');
    }
  }

  // Load more results
  Future<void> loadMoreResults() async {
    if (isLoadingMore.value || !hasMoreResults.value) return;

    try {
      isLoadingMore.value = true;
      currentPage.value++;
      await performSearch(isNewSearch: false, saveToHistory: false);
    } catch (e) {
      currentPage.value--; // Revert on error
      isLoadingMore.value = false;
      print('Failed to load more results: $e');
    }
  }

  // Select suggestion
  void selectSuggestion(SearchSuggestion suggestion) {
    currentQuery.value = suggestion.query;
    performSearch(query: suggestion.query);
  }

  // Select trending search
  void selectTrendingSearch(String query) {
    currentQuery.value = query;
    performSearch(query: query);
  }

  // Select history item
  void selectHistoryItem(String query) {
    currentQuery.value = query;
    performSearch(query: query);
  }

  // Clear search
  void clearSearch() {
    currentQuery.value = '';
    searchResult.value = null;
    showSuggestions.value = false;
    hasError.value = false;
    resetFilters();
  }

  // Toggle advanced filters
  void toggleAdvancedFilters() {
    showAdvancedFilters.value = !showAdvancedFilters.value;
  }

  // Toggle filter panel
  void toggleFilterPanel() {
    showFilterPanel.value = !showFilterPanel.value;
  }

  // Apply filters
  void applyFilters() {
    currentPage.value = 1;
    performSearch(saveToHistory: false);
  }

  // Reset filters
  void resetFilters() {
    selectedCategory.value = '';
    selectedTags.clear();
    minDuration.value = null;
    maxDuration.value = null;
    isPremium.value = null;
    sortBy.value = 'relevance';
    sortOrder.value = 'DESC';
  }

  // Set category filter
  void setCategory(String category) {
    selectedCategory.value = category;
  }

  // Add tag filter
  void addTag(String tag) {
    if (!selectedTags.contains(tag)) {
      selectedTags.add(tag);
    }
  }

  // Remove tag filter
  void removeTag(String tag) {
    selectedTags.remove(tag);
  }

  // Set duration filter
  void setDurationFilter(int? min, int? max) {
    minDuration.value = min;
    maxDuration.value = max;
  }

  // Set premium filter
  void setPremiumFilter(bool? premium) {
    isPremium.value = premium;
  }

  // Set sort options
  void setSortOptions(String sort, String order) {
    sortBy.value = sort;
    sortOrder.value = order;
  }

  // Clear search history
  Future<void> clearSearchHistory() async {
    try {
      await SearchService.clearSearchHistory();
      searchHistory.clear();
    } catch (e) {
      print('Failed to clear search history: $e');
    }
  }

  // Get search statistics
  Future<SearchStats?> getSearchStats() async {
    try {
      return await SearchService.getSearchStats();
    } catch (e) {
      print('Failed to get search stats: $e');
      return null;
    }
  }

  // Get content by ID from search results
  ContentModel? getContentById(String id) {
    final result = searchResult.value;
    if (result == null) return null;
    
    try {
      return result.content.firstWhere((content) => content.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get filtered content count
  int get filteredContentCount {
    final result = searchResult.value;
    return result?.content.length ?? 0;
  }

  // Get total results count
  int get totalResultsCount {
    final result = searchResult.value;
    return result?.total ?? 0;
  }

  // Check if search has results
  bool get hasResults {
    final result = searchResult.value;
    return result != null && result.content.isNotEmpty;
  }

  // Check if search is empty
  bool get isEmpty {
    final result = searchResult.value;
    return result == null || result.content.isEmpty;
  }

  // Get category counts
  Map<String, int> get categoryCounts {
    final result = searchResult.value;
    return result?.categoryCounts ?? {};
  }

  // Get suggested queries
  List<String> get suggestedQueries {
    final result = searchResult.value;
    return result?.suggestedQueries ?? [];
  }

  // Handle error
  void handleError(String message) {
    hasError.value = true;
    errorMessage.value = message;
    isSearching.value = false;
    isLoadingMore.value = false;
  }

  // Clear error
  void clearError() {
    hasError.value = false;
    errorMessage.value = '';
  }
} 