import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/app_constants.dart';
import '../data/models/content_model.dart';

class SearchService {
  static const String baseUrl = AppConstants.baseUrl;

  // Main search method with advanced filtering
  static Future<SearchResult> searchContent({
    required String query,
    int page = 1,
    int limit = 20,
    String? category,
    List<String>? tags,
    int? minDuration,
    int? maxDuration,
    bool? isPremium,
    String? author,
    double? minRating,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search/content').replace(queryParameters: {
          'q': query,
          'page': page.toString(),
          'limit': limit.toString(),
          if (category != null && category.isNotEmpty) 'category': category,
          if (tags != null && tags.isNotEmpty) 'tags': tags.join(','),
          if (minDuration != null) 'minDuration': minDuration.toString(),
          if (maxDuration != null) 'maxDuration': maxDuration.toString(),
          if (isPremium != null) 'isPremium': isPremium.toString(),
          if (author != null && author.isNotEmpty) 'author': author,
          if (minRating != null) 'minRating': minRating.toString(),
          if (sortBy != null) 'sortBy': sortBy,
          if (sortOrder != null) 'sortOrder': sortOrder,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return SearchResult.fromMap(data);
      } else {
        throw SearchException('Search failed: ${response.statusCode}');
      }
    } catch (e) {
      throw SearchException('Network error: $e');
    }
  }

  // Get search suggestions based on query
  static Future<List<SearchSuggestion>> getSearchSuggestions(String query) async {
    try {
      if (query.length < 2) return [];

      final response = await http.get(
        Uri.parse('$baseUrl/search/suggestions?q=${Uri.encodeComponent(query)}'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> suggestions = data['suggestions'] ?? [];
        return suggestions.map((s) => SearchSuggestion.fromMap(s)).toList();
      } else {
        throw SearchException('Failed to get suggestions: ${response.statusCode}');
      }
    } catch (e) {
      throw SearchException('Network error: $e');
    }
  }

  // Get trending searches
  static Future<List<String>> getTrendingSearches() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search/trending'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> trending = data['trending'] ?? [];
        return trending.map((t) => t.toString()).toList();
      } else {
        throw SearchException('Failed to get trending searches: ${response.statusCode}');
      }
    } catch (e) {
      throw SearchException('Network error: $e');
    }
  }

  // Get search history for current user
  static Future<List<String>> getSearchHistory() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search/history'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> history = data['history'] ?? [];
        return history.map((h) => h.toString()).toList();
      } else {
        throw SearchException('Failed to get search history: ${response.statusCode}');
      }
    } catch (e) {
      throw SearchException('Network error: $e');
    }
  }

  // Save search query to history
  static Future<void> saveSearchQuery(String query) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/search/history'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'query': query,
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw SearchException('Failed to save search query: ${response.statusCode}');
      }
    } catch (e) {
      throw SearchException('Network error: $e');
    }
  }

  // Clear search history
  static Future<void> clearSearchHistory() async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/search/history'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw SearchException('Failed to clear search history: ${response.statusCode}');
      }
    } catch (e) {
      throw SearchException('Network error: $e');
    }
  }

  // Get search statistics
  static Future<SearchStats> getSearchStats() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search/stats'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return SearchStats.fromMap(data['stats']);
      } else {
        throw SearchException('Failed to get search stats: ${response.statusCode}');
      }
    } catch (e) {
      throw SearchException('Network error: $e');
    }
  }

  // Advanced search with filters
  static Future<SearchResult> advancedSearch({
    required Map<String, dynamic> filters,
    int page = 1,
    int limit = 20,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/search/advanced'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(filters),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return SearchResult.fromMap(data);
      } else {
        throw SearchException('Advanced search failed: ${response.statusCode}');
      }
    } catch (e) {
      throw SearchException('Network error: $e');
    }
  }

  // Get content by category
  static Future<List<ContentModel>> getContentByCategory(
    String category, {
    int limit = 20,
    int page = 1,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/content/category/$category'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> contentList = data['content'] ?? [];
        return contentList.map((item) => ContentModel.fromMap(item)).toList();
      } else {
        throw Exception('Failed to load category content: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}

// Search Result Model
class SearchResult {
  final List<ContentModel> content;
  final int total;
  final int page;
  final int limit;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPrevPage;
  final Map<String, int> categoryCounts;
  final List<String> suggestedQueries;

  SearchResult({
    required this.content,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPrevPage,
    required this.categoryCounts,
    required this.suggestedQueries,
  });

  factory SearchResult.fromMap(Map<String, dynamic> map) {
    return SearchResult(
      content: (map['content'] as List<dynamic>?)
          ?.map((item) => ContentModel.fromMap(item))
          .toList() ?? [],
      total: map['total'] ?? 0,
      page: map['page'] ?? 1,
      limit: map['limit'] ?? 20,
      totalPages: map['totalPages'] ?? 1,
      hasNextPage: map['hasNextPage'] ?? false,
      hasPrevPage: map['hasPrevPage'] ?? false,
      categoryCounts: Map<String, int>.from(map['categoryCounts'] ?? {}),
      suggestedQueries: List<String>.from(map['suggestedQueries'] ?? []),
    );
  }
}

// Search Suggestion Model
class SearchSuggestion {
  final String query;
  final String type; // 'content', 'category', 'author', 'tag'
  final String? subtitle;
  final int? count;

  SearchSuggestion({
    required this.query,
    required this.type,
    this.subtitle,
    this.count,
  });

  factory SearchSuggestion.fromMap(Map<String, dynamic> map) {
    return SearchSuggestion(
      query: map['query'] ?? '',
      type: map['type'] ?? 'content',
      subtitle: map['subtitle'],
      count: map['count'],
    );
  }
}

// Search Stats Model
class SearchStats {
  final int totalSearches;
  final int uniqueSearches;
  final Map<String, int> popularQueries;
  final Map<String, int> categorySearches;
  final double averageResultsPerSearch;

  SearchStats({
    required this.totalSearches,
    required this.uniqueSearches,
    required this.popularQueries,
    required this.categorySearches,
    required this.averageResultsPerSearch,
  });

  factory SearchStats.fromMap(Map<String, dynamic> map) {
    return SearchStats(
      totalSearches: map['totalSearches'] ?? 0,
      uniqueSearches: map['uniqueSearches'] ?? 0,
      popularQueries: Map<String, int>.from(map['popularQueries'] ?? {}),
      categorySearches: Map<String, int>.from(map['categorySearches'] ?? {}),
      averageResultsPerSearch: (map['averageResultsPerSearch'] ?? 0.0).toDouble(),
    );
  }
}

// Custom Search Exception
class SearchException implements Exception {
  final String message;
  
  SearchException(this.message);
  
  @override
  String toString() => 'SearchException: $message';
} 