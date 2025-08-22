import 'package:get/get.dart';
import '../modules/home/views/home_view.dart';
import '../modules/auth/views/auth_view.dart';
import '../modules/onboarding/onboarding_views/onboarding_view.dart';
import '../modules/home/views/search_screen.dart';
import '../modules/home/views/search_results_screen.dart';
import '../modules/home/views/content_detail_screen.dart';
import '../modules/home/views/all_content_screen.dart';
import '../modules/home/views/category_content_screen.dart';
import '../modules/home/views/ai_recommendations_modal.dart';
import '../modules/home/views/whispr_mode_screen.dart';
import '../modules/settings/views/help_center_screen.dart';
import '../modules/settings/views/privacy_policy_screen.dart';
import '../modules/settings/views/terms_of_service_screen.dart';
import '../modules/settings/views/notifications_settings_screen.dart';
import '../modules/settings/views/settings_screen.dart';
import '../modules/home/views/ai_assistant_screen.dart';
import '../modules/home/views/simple_ai_assistant_screen.dart';
import '../modules/home/views/ai_voice_assistant_screen.dart';
import '../modules/home/views/ai_recommendations_enhanced_screen.dart';

abstract class AppRoutes {
  static const String initial = '/';
  static const String home = '/home';
  static const String auth = '/auth';
  static const String onboarding = '/onboarding';
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String search = '/search';
  static const String searchResults = '/search-results';
  static const String contentDetail = '/content-detail';
  static const String allContent = '/all-content';
  static const String categoryContent = '/category-content';
  static const String meditationPlayer = '/meditation-player';
  static const String sleepStories = '/sleep-stories';
  static const String breathing = '/breathing';
  static const String relaxation = '/relaxation';
  static const String music = '/music';
  static const String nature = '/nature';
  static const String aiRecommendations = '/ai-recommendations';
  static const String whisprMode = '/whispr-mode';
  static const String helpCenter = '/help-center';
  static const String privacyPolicy = '/privacy-policy';
  static const String termsOfService = '/terms-of-service';
  static const String notifications = '/notifications';
  // AI Assistant Routes
  static const String aiAssistant = '/ai-assistant';
  static const String simpleAiAssistant = '/simple-ai-assistant';
  static const String aiVoiceAssistant = '/ai-voice-assistant';
  static const String aiRecommendationsEnhanced = '/ai-recommendations-enhanced';
}

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.initial,
      page: () => const HomeView(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
    ),
    GetPage(
      name: AppRoutes.auth,
      page: () => const AuthView(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingView(),
    ),
    GetPage(
      name: AppRoutes.search,
      page: () => const SearchScreen(),
    ),
    GetPage(
      name: AppRoutes.searchResults,
      page: () => SearchResultsScreen(
        initialQuery: Get.parameters['query'] ?? '',
        initialFilters: Get.parameters['filters'] != null 
            ? Map<String, dynamic>.from(Get.parameters['filters'] as Map)
            : null,
      ),
    ),
    GetPage(
      name: AppRoutes.contentDetail,
      page: () => ContentDetailScreen(
        contentId: Get.parameters['contentId'] ?? '',
        content: Get.arguments as dynamic,
      ),
    ),
    GetPage(
      name: AppRoutes.allContent,
      page: () => AllContentScreen(
        category: Get.parameters['category'],
        searchQuery: Get.parameters['searchQuery'],
        title: Get.parameters['title'] ?? 'All Content',
      ),
    ),
    GetPage(
      name: AppRoutes.categoryContent,
      page: () => CategoryContentScreen(
        category: Get.parameters['category'] ?? '',
        displayName: Get.parameters['displayName'] ?? 'Category Content',
      ),
    ),
    GetPage(
      name: AppRoutes.aiRecommendations,
      page: () => AiRecommendationsModal(
        onClose: () => Get.back(),
      ),
    ),
    GetPage(
      name: AppRoutes.whisprMode,
      page: () => const WhisprModeScreen(),
    ),
    GetPage(
      name: AppRoutes.helpCenter,
      page: () => const HelpCenterScreen(),
    ),
    GetPage(
      name: AppRoutes.privacyPolicy,
      page: () => const PrivacyPolicyScreen(),
    ),
    GetPage(
      name: AppRoutes.termsOfService,
      page: () => const TermsOfServiceScreen(),
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsSettingsScreen(),
    ),
    // AI Assistant Routes
    GetPage(
      name: AppRoutes.aiAssistant,
      page: () => const AIAssistantScreen(),
    ),
    GetPage(
      name: AppRoutes.simpleAiAssistant,
      page: () => const SimpleAIAssistantScreen(),
    ),
    GetPage(
      name: AppRoutes.aiVoiceAssistant,
      page: () => const AIVoiceAssistantScreen(),
    ),
    GetPage(
      name: AppRoutes.aiRecommendationsEnhanced,
      page: () => const AIRecommendationsEnhancedScreen(),
    ),
  ];
}

 
 