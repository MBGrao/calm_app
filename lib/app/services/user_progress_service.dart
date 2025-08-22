import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/app_constants.dart';

class UserProgressService {
  static const String baseUrl = AppConstants.baseUrl;

  // Record a user session
  static Future<void> recordSession({
    required String contentId,
    required int duration,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/progress/session'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'contentId': contentId,
          'duration': duration,
          'metadata': metadata ?? {},
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to record session: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get user progress
  static Future<Map<String, dynamic>> getUserProgress() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/progress/user'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Map<String, dynamic>.from(data['progress'] ?? {});
      } else {
        throw Exception('Failed to load user progress: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get user statistics
  static Future<Map<String, dynamic>> getUserStats() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/progress/stats'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Map<String, dynamic>.from(data['stats'] ?? {});
      } else {
        throw Exception('Failed to load user stats: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get user streak
  static Future<Map<String, dynamic>> getUserStreak() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/progress/streak'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Map<String, dynamic>.from(data['streak'] ?? {});
      } else {
        throw Exception('Failed to load user streak: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get user sessions
  static Future<List<Map<String, dynamic>>> getUserSessions({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/progress/sessions?page=$page&limit=$limit'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> sessions = data['sessions'] ?? [];
        return sessions.map((session) => Map<String, dynamic>.from(session)).toList();
      } else {
        throw Exception('Failed to load user sessions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Mark content as completed
  static Future<void> markCompleted(String contentId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/progress/complete'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'contentId': contentId,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to mark content as completed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get user achievements
  static Future<List<Map<String, dynamic>>> getUserAchievements() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/progress/achievements'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> achievements = data['achievements'] ?? [];
        return achievements.map((achievement) => Map<String, dynamic>.from(achievement)).toList();
      } else {
        throw Exception('Failed to load user achievements: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
} 