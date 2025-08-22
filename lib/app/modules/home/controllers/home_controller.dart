import 'package:get/get.dart';
import '../../../data/models/content_model.dart';
import '../../../services/content_service.dart';
import '../../../services/user_progress_service.dart';

class HomeController extends GetxController {
  // Observable variables
  final isLoading = false.obs;
  final content = <ContentModel>[].obs;
  final recommendedContent = <ContentModel>[].obs;
  final categories = <Map<String, dynamic>>[].obs;
  final userStats = <String, dynamic>{}.obs;
  final userStreak = <String, dynamic>{}.obs;
  final currentPage = 1.obs;
  final hasMoreContent = true.obs;
  final selectedCategory = ''.obs;
  final searchQuery = ''.obs;
  
  // Error handling
  final errorMessage = ''.obs;
  final hasError = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }
  
  // Load initial data
  Future<void> loadInitialData() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      
      // Load content, categories, and user stats in parallel
      await Future.wait([
        loadContent(),
        loadCategories(),
        loadUserStats(),
        loadRecommendedContent(),
      ]);
      
    } catch (e) {
      handleError('Failed to load initial data: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  // Load content from backend
  Future<void> loadContent({bool refresh = false}) async {
    try {
      if (refresh) {
        currentPage.value = 1;
        content.clear();
      }
      
      final newContent = await ContentService.getAllContent(
        page: currentPage.value,
        limit: 10,
        category: selectedCategory.value.isNotEmpty ? selectedCategory.value : null,
        search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
      );
      
      if (refresh) {
        content.assignAll(newContent);
      } else {
        content.addAll(newContent);
      }
      
      hasMoreContent.value = newContent.length >= 10;
      
    } catch (e) {
      handleError('Failed to load content: $e');
    }
  }
  
  // Load more content (pagination)
  Future<void> loadMoreContent() async {
    if (isLoading.value || !hasMoreContent.value) return;
    
    try {
      currentPage.value++;
      await loadContent();
    } catch (e) {
      currentPage.value--; // Revert on error
      handleError('Failed to load more content: $e');
    }
  }
  
  // Load categories
  Future<void> loadCategories() async {
    try {
      final categoriesData = await ContentService.getCategories();
      categories.assignAll(categoriesData);
    } catch (e) {
      handleError('Failed to load categories: $e');
    }
  }
  
  // Load user statistics
  Future<void> loadUserStats() async {
    try {
      final stats = await UserProgressService.getUserStats();
      userStats.assignAll(stats);
      
      final streak = await UserProgressService.getUserStreak();
      userStreak.value = streak;
    } catch (e) {
      // User might not be logged in, so this is not a critical error
      print('Could not load user stats: $e');
    }
  }
  
  // Load recommended content
  Future<void> loadRecommendedContent() async {
    try {
      final recommended = await ContentService.getRecommendedContent(limit: 5);
      recommendedContent.assignAll(recommended);
    } catch (e) {
      // If recommendations fail, load popular content instead
      try {
        final popular = await ContentService.getPopularContent(limit: 5);
        recommendedContent.assignAll(popular);
      } catch (e2) {
        handleError('Failed to load recommended content: $e2');
      }
    }
  }
  
  // Search content
  Future<void> searchContent(String query) async {
    try {
      searchQuery.value = query;
      currentPage.value = 1;
      content.clear();
      
      if (query.isEmpty) {
        await loadContent();
        return;
      }
      
      final searchResults = await ContentService.searchContent(
        query,
        page: currentPage.value,
        limit: 10,
      );
      
      content.assignAll(searchResults);
      hasMoreContent.value = searchResults.length >= 10;
      
    } catch (e) {
      handleError('Search failed: $e');
    }
  }
  
  // Filter by category
  Future<void> filterByCategory(String category) async {
    try {
      selectedCategory.value = category;
      currentPage.value = 1;
      content.clear();
      
      if (category.isEmpty) {
        await loadContent();
        return;
      }
      
      final categoryContent = await ContentService.getContentByCategory(
        category,
        page: currentPage.value,
        limit: 10,
      );
      
      content.assignAll(categoryContent);
      hasMoreContent.value = categoryContent.length >= 10;
      
    } catch (e) {
      handleError('Failed to filter by category: $e');
    }
  }
  
  // Clear filters
  Future<void> clearFilters() async {
    selectedCategory.value = '';
    searchQuery.value = '';
    await loadContent(refresh: true);
  }
  
  // Record a meditation session
  Future<void> recordSession({
    required String contentId,
    required int duration,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await UserProgressService.recordSession(
        contentId: contentId,
        duration: duration,
        metadata: metadata,
      );
      
      // Refresh user stats after recording session
      await loadUserStats();
      
    } catch (e) {
      handleError('Failed to record session: $e');
    }
  }
  
  // Get content by ID
  ContentModel? getContentById(String id) {
    try {
      return content.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }
  
  // Get content by category
  List<ContentModel> getContentByCategory(String category) {
    return content.where((item) => item.category.toLowerCase() == category.toLowerCase()).toList();
  }
  
  // Get popular content
  List<ContentModel> getPopularContent({int limit = 5}) {
    final sorted = List<ContentModel>.from(content);
    sorted.sort((a, b) => b.playCount.compareTo(a.playCount));
    return sorted.take(limit).toList();
  }
  
  // Get recent content
  List<ContentModel> getRecentContent({int limit = 5}) {
    final sorted = List<ContentModel>.from(content);
    sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted.take(limit).toList();
  }
  
  // Error handling
  void handleError(String message) {
    errorMessage.value = message;
    hasError.value = true;
    print('HomeController Error: $message');
  }
  
  // Clear error
  void clearError() {
    errorMessage.value = '';
    hasError.value = false;
  }
  
  // Refresh all data
  Future<void> refresh() async {
    await loadInitialData();
  }
} 