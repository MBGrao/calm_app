import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final isLoading = false.obs;
  final authError = ''.obs;
  final isLoggedIn = false.obs;
  final userProfile = Rx<UserProfile?>(null);

  // API configuration - Updated for VPS backend
  // Use VPS IP for production deployment
  static const String baseUrl = 'http://168.231.66.116:3000/api/v1';
  static const String authEndpoint = '$baseUrl/auth';
  static const String profileEndpoint = '$baseUrl/profile';

  // Token storage
  String? _accessToken;
  String? _refreshToken;

  @override
  void onInit() {
    super.onInit();
    _loadStoredTokens();
    
    // Set up periodic token refresh (every 30 minutes)
    _setupTokenRefresh();
  }

  void _setupTokenRefresh() {
    // Refresh token every 30 minutes
    Timer.periodic(const Duration(minutes: 30), (timer) async {
      if (isLoggedIn.value && _refreshToken != null) {
        await _refreshAccessToken();
      }
    });
  }

  Future<void> _loadStoredTokens() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _accessToken = prefs.getString('access_token');
      _refreshToken = prefs.getString('refresh_token');
      
      // Check if user has completed onboarding
      final hasCompletedOnboarding = prefs.getBool('onboarding_completed') ?? false;
      
      if (_accessToken != null && _refreshToken != null && hasCompletedOnboarding) {
        // Validate token and load user profile
        final isValid = await _validateToken();
        if (isValid) {
          isLoggedIn.value = true;
          await loadUserProfile();
        } else {
          // Token is invalid, try to refresh
          final refreshed = await _refreshAccessToken();
          if (refreshed) {
            isLoggedIn.value = true;
            await loadUserProfile();
          } else {
            // Refresh failed, clear tokens
            await _clearTokens();
            isLoggedIn.value = false;
          }
        }
      } else {
        // No tokens or onboarding not completed, show onboarding
        isLoggedIn.value = false;
        if (!hasCompletedOnboarding) {
          // Navigate to onboarding after a short delay
          Future.delayed(const Duration(milliseconds: 500), () {
            Get.offAllNamed('/onboarding');
          });
        }
      }
    } catch (e) {
      print('Error loading stored tokens: $e');
      isLoggedIn.value = false;
    }
  }

  Future<bool> _validateToken() async {
    if (_accessToken == null) return false;
    
    try {
      final response = await http.get(
        Uri.parse('$profileEndpoint'),
        headers: {
          'Authorization': 'Bearer $_accessToken',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));
      
      return response.statusCode == 200;
    } catch (e) {
      print('Token validation error: $e');
      return false;
    }
  }

  Future<bool> _refreshAccessToken() async {
    if (_refreshToken == null) return false;
    
    try {
      final response = await http.post(
        Uri.parse('$authEndpoint/refresh'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'refreshToken': _refreshToken,
        }),
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _saveTokens(data['accessToken'], data['refreshToken']);
        return true;
      }
      return false;
    } catch (e) {
      print('Token refresh error: $e');
      return false;
    }
  }

  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', accessToken);
      await prefs.setString('refresh_token', refreshToken);
      _accessToken = accessToken;
      _refreshToken = refreshToken;
    } catch (e) {
      print('Error saving tokens: $e');
    }
  }

  Future<void> _clearTokens() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('access_token');
      await prefs.remove('refresh_token');
      _accessToken = null;
      _refreshToken = null;
    } catch (e) {
      print('Error clearing tokens: $e');
    }
  }

  void setLoading(bool value) {
    isLoading.value = value;
  }
  
  void setAuthError(String error) {
    authError.value = error;
    // Clear error after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      authError.value = '';
    });
  }
  
  void clearAuthError() {
    authError.value = '';
  }

  Future<void> signUp(String email, String password, String firstName, String lastName, {bool acceptPrivacyPolicy = false, bool acceptTermsOfService = false}) async {
    try {
      setLoading(true);
      setAuthError('');
      
      final response = await http.post(
        Uri.parse('$authEndpoint/signup'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
          'acceptPrivacyPolicy': acceptPrivacyPolicy,
          'acceptTermsOfService': acceptTermsOfService,
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final accessToken = data['accessToken']?.toString();
        final refreshToken = data['refreshToken']?.toString();
        
        if (accessToken != null && refreshToken != null) {
          await _saveTokens(accessToken, refreshToken);
          if (data['user'] != null) {
            userProfile.value = UserProfile.fromJson(data['user']);
          }
          isLoggedIn.value = true;
          await _showLoginSuccessAnimation();
        } else {
          setAuthError('Invalid response from server');
        }
      } else {
        final errorData = jsonDecode(response.body);
        setAuthError(errorData['message'] ?? 'Sign up failed');
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        setAuthError('Network error: Please check your internet connection');
      } else {
        setAuthError('Network error: ${e.toString()}');
      }
    } finally {
      setLoading(false);
    }
  }
  
  Future<void> signInWithEmail(String email, String password) async {
    try {
      setLoading(true);
      setAuthError('');
      
      final response = await http.post(
        Uri.parse('$authEndpoint/signin'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final accessToken = data['accessToken']?.toString();
        final refreshToken = data['refreshToken']?.toString();
        
        if (accessToken != null && refreshToken != null) {
          await _saveTokens(accessToken, refreshToken);
          if (data['user'] != null) {
            userProfile.value = UserProfile.fromJson(data['user']);
          }
          isLoggedIn.value = true;
          await _showLoginSuccessAnimation();
        } else {
          setAuthError('Invalid response from server');
        }
      } else {
        final errorData = jsonDecode(response.body);
        setAuthError(errorData['message'] ?? 'Sign in failed');
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        setAuthError('Network error: Please check your internet connection');
      } else {
        setAuthError('Network error: ${e.toString()}');
      }
    } finally {
      setLoading(false);
    }
  }

  Future<void> loadUserProfile() async {
    if (_accessToken == null) return;

    try {
      final response = await http.get(
        Uri.parse(profileEndpoint),
        headers: {
          'Authorization': 'Bearer $_accessToken',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        userProfile.value = UserProfile.fromJson(data);
      }
    } catch (e) {
      print('Error loading user profile: $e');
    }
  }

  Future<void> updateProfile(Map<String, dynamic> profileData) async {
    if (_accessToken == null) return;

    try {
      final response = await http.put(
        Uri.parse(profileEndpoint),
        headers: {
          'Authorization': 'Bearer $_accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(profileData),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        userProfile.value = UserProfile.fromJson(data);
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        final errorData = jsonDecode(response.body);
        Get.snackbar(
          'Error',
          errorData['message'] ?? 'Failed to update profile',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Network error: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> acceptPrivacyPolicy() async {
    if (_accessToken == null) return;

    try {
      final response = await http.put(
        Uri.parse('$profileEndpoint/privacy-policy'),
        headers: {
          'Authorization': 'Bearer $_accessToken',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        userProfile.value = UserProfile.fromJson(data);
      }
    } catch (e) {
      print('Error accepting privacy policy: $e');
    }
  }

  Future<void> acceptTermsOfService() async {
    if (_accessToken == null) return;

    try {
      final response = await http.put(
        Uri.parse('$profileEndpoint/terms-of-service'),
        headers: {
          'Authorization': 'Bearer $_accessToken',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        userProfile.value = UserProfile.fromJson(data);
      }
    } catch (e) {
      print('Error accepting terms of service: $e');
    }
  }
  
  Future<void> _showLoginSuccessAnimation() async {
    // Simulate success animation
    await Future.delayed(const Duration(milliseconds: 300));
    // Navigate to main app after successful login
    Get.offAllNamed('/home');
  }
  
  Future<void> forgotPassword(String email) async {
    try {
      setLoading(true);
      setAuthError('');
      
      final response = await http.post(
        Uri.parse('$authEndpoint/forgot-password'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        Get.snackbar(
          'Password Reset',
          'Password reset link sent to $email',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } else {
        final errorData = jsonDecode(response.body);
        setAuthError(errorData['message'] ?? 'Password reset failed');
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        setAuthError('Network error: Please check your internet connection');
      } else {
        setAuthError('Network error: ${e.toString()}');
      }
    } finally {
      setLoading(false);
    }
  }
  
  // Mark onboarding as completed
  Future<void> markOnboardingCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_completed', true);
    } catch (e) {
      print('Error marking onboarding as completed: $e');
    }
  }

  // Check if onboarding is completed
  Future<bool> isOnboardingCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('onboarding_completed') ?? false;
    } catch (e) {
      print('Error checking onboarding completion: $e');
      return false;
    }
  }
  
  Future<void> logout() async {
    try {
      // Clear loading states
      setLoading(false);
      
      // Clear auth error
      clearAuthError();
      
      // Call backend logout if token exists
      if (_accessToken != null) {
        try {
          await http.post(
            Uri.parse('$authEndpoint/logout'),
            headers: {
              'Authorization': 'Bearer $_accessToken',
              'Content-Type': 'application/json',
            },
          ).timeout(const Duration(seconds: 10));
        } catch (e) {
          print('Error during backend logout: $e');
          // Continue with local logout even if backend fails
        }
      }

      // Clear all local data
      await _clearTokens();
      userProfile.value = null;
      isLoggedIn.value = false;
      
      // Clear any stored user data
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_data');
      await prefs.remove('user_preferences');
      await prefs.remove('onboarding_completed'); // Clear onboarding completion
      
      // Navigate to onboarding
      Get.offAllNamed('/onboarding');
      
    } catch (e) {
      print('Error during logout: $e');
      // Force logout even if there's an error
      await _clearTokens();
      userProfile.value = null;
      isLoggedIn.value = false;
      Get.offAllNamed('/onboarding');
    }
  }
}

class UserProfile {
  final String id;
  final String email;
  final String name;
  final String avatar;
  final String provider;
  final bool isEmailVerified;
  final DateTime createdAt;
  final List<String> linkedAccounts;
  final Map<String, dynamic> profile;
  
  UserProfile({
    required this.id,
    required this.email,
    required this.name,
    required this.avatar,
    required this.provider,
    required this.isEmailVerified,
    DateTime? createdAt,
    List<String>? linkedAccounts,
    this.profile = const {},
  }) : 
    createdAt = createdAt ?? DateTime.now(),
    linkedAccounts = linkedAccounts ?? [];
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar': avatar,
      'provider': provider,
      'isEmailVerified': isEmailVerified,
      'createdAt': createdAt.toIso8601String(),
      'linkedAccounts': linkedAccounts,
      'profile': profile,
    };
  }
  
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    // Handle both user object and direct user data
    final userData = json['user'] ?? json;
    
    return UserProfile(
      id: userData['id']?.toString() ?? '',
      email: userData['email']?.toString() ?? '',
      name: userData['fullName']?.toString() ?? 
            '${userData['firstName']?.toString() ?? ''} ${userData['lastName']?.toString() ?? ''}'.trim(),
      avatar: userData['avatar']?.toString() ?? 'https://via.placeholder.com/150',
      provider: userData['authProvider']?.toString() ?? 'email',
      isEmailVerified: userData['isEmailVerified'] == true,
      createdAt: userData['createdAt'] != null ? DateTime.parse(userData['createdAt'].toString()) : DateTime.now(),
      linkedAccounts: userData['linkedAccounts'] != null ? List<String>.from(userData['linkedAccounts']) : [],
      profile: userData['preferences'] != null ? Map<String, dynamic>.from(userData['preferences']) : {},
    );
  }
} 