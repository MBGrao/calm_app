import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/app_constants.dart';
import '../data/models/content_model.dart';

class ContentService {
  static const String baseUrl = AppConstants.baseUrl;

  // Get content by ID
  static Future<ContentModel> getContentById(String contentId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/content/$contentId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ContentModel.fromMap(data['content']);
      } else {
        throw Exception('Failed to load content: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get all content with pagination and filtering
  static Future<List<ContentModel>> getAllContent({
    int page = 1,
    int limit = 20,
    String? category,
    String? search,
    String? sortBy,
    String? sortOrder,
    bool? isPremium,
    int? minDuration,
    int? maxDuration,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (category != null && category.isNotEmpty) 'category': category,
        if (search != null && search.isNotEmpty) 'search': search,
        if (sortBy != null) 'sortBy': sortBy,
        if (sortOrder != null) 'sortOrder': sortOrder,
        if (isPremium != null) 'isPremium': isPremium.toString(),
        if (minDuration != null) 'minDuration': minDuration.toString(),
        if (maxDuration != null) 'maxDuration': maxDuration.toString(),
      };

      final response = await http.get(
        Uri.parse('$baseUrl/content').replace(queryParameters: queryParams),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> contentList = data['content'] ?? [];
        return contentList.map((item) => ContentModel.fromMap(item)).toList();
      } else {
        throw Exception('Failed to load content: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
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
      final queryParams = {
        'limit': limit.toString(),
        'page': page.toString(),
        if (sortBy != null) 'sortBy': sortBy,
        if (sortOrder != null) 'sortOrder': sortOrder,
      };

      final response = await http.get(
        Uri.parse('$baseUrl/content/category/$category').replace(queryParameters: queryParams),
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

  // Get popular content
  static Future<List<ContentModel>> getPopularContent({int limit = 20}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/content/popular?limit=$limit'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> contentList = data['content'] ?? [];
        return contentList.map((item) => ContentModel.fromMap(item)).toList();
      } else {
        throw Exception('Failed to load popular content: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get recommended content
  static Future<List<ContentModel>> getRecommendedContent({int limit = 20}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/content/recommended?limit=$limit'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> contentList = data['content'] ?? [];
        return contentList.map((item) => ContentModel.fromMap(item)).toList();
      } else {
        throw Exception('Failed to load recommended content: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Search content
  static Future<List<ContentModel>> searchContent(
    String query, {
    int limit = 20,
    int page = 1,
    String? category,
    int? duration,
    bool? isPremium,
  }) async {
    try {
      final queryParams = {
        'q': query,
        'limit': limit.toString(),
        'page': page.toString(),
        if (category != null) 'category': category,
        if (duration != null) 'duration': duration.toString(),
        if (isPremium != null) 'isPremium': isPremium.toString(),
      };

      final response = await http.get(
        Uri.parse('$baseUrl/content/search').replace(queryParameters: queryParams),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> contentList = data['content'] ?? [];
        return contentList.map((item) => ContentModel.fromMap(item)).toList();
      } else {
        throw Exception('Search failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get content categories
  static Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/content/categories'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> categories = data['categories'] ?? [];
        return categories.map((cat) => Map<String, dynamic>.from(cat)).toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Increment play count
  static Future<void> incrementPlayCount(String contentId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/content/$contentId/play'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to increment play count: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Rate content
  static Future<void> rateContent(String contentId, double rating) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/content/$contentId/rate'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'rating': rating,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to rate content: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get content statistics
  static Future<Map<String, dynamic>> getContentStats() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/content/stats'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Map<String, dynamic>.from(data['stats'] ?? {});
      } else {
        throw Exception('Failed to load content stats: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
} 