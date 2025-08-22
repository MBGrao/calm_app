class AppConstants {
  // App Info
  static const String appName = 'MeditAi';
  static const String appVersion = '1.0.0';
  
  // Asset Paths
  static const String imagePath = 'assets/images';
  static const String iconPath = 'assets/icons';
  
  // API Endpoints
  // Development: Use 10.0.2.2 for Android emulator, localhost for web
  // Production: Use VPS API domain
  static const String baseUrl = 'http://168.231.66.116:3000/api/v1';
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'app_theme';
  
  // Animation Durations
  static const int splashDuration = 2000;
  static const int pageTransitionDuration = 300;
  
  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 20;
  
  // Pagination
  static const int defaultPageSize = 10;
  
  // Cache Duration
  static const int cacheDuration = 7; // days
  
  // Feature Flags
  static const bool enablePremium = true;
  static const bool enableSocial = false;
  static const bool enableOfflineMode = true;
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 12.0;
  static const double defaultIconSize = 24.0;
  
  // Error Messages
  static const String genericError = 'Something went wrong. Please try again.';
  static const String networkError = 'Please check your internet connection.';
  static const String authError = 'Authentication failed. Please login again.';
  
  // Success Messages
  static const String loginSuccess = 'Successfully logged in!';
  static const String signupSuccess = 'Account created successfully!';
  static const String profileUpdateSuccess = 'Profile updated successfully!';
  
  // Placeholder Images
  static const String placeholderImage = 'https://via.placeholder.com/400';
  static const String placeholderAvatar = 'https://via.placeholder.com/150';
  
  // Social Links
  static const String privacyPolicyUrl = 'https://meditai.com/privacy';
  static const String termsOfServiceUrl = 'https://meditai.com/terms';
  static const String supportEmail = 'support@meditai.com';
  
  // Feature Names
  static const String meditationFeature = 'Meditation';
  static const String sleepFeature = 'Sleep';
  static const String mindfulnessFeature = 'Mindfulness';
  static const String aiFeature = 'AI Guidance';
  
  // Subscription Plans
  static const String monthlyPlan = 'monthly';
  static const String yearlyPlan = 'yearly';
  static const String lifetimePlan = 'lifetime';
} 