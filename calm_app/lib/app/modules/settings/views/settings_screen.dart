import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/controllers/theme_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import 'profile_settings_screen.dart';
import 'notifications_settings_screen.dart';
import 'help_center_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_of_service_screen.dart';
import '../../../widgets/interactive_feedback.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF1B4B6F),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1B517E),
              Color(0xFF0D3550),
              Color(0xFF32366F),
            ],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.all(16.w),
          children: [
            _buildSectionTitle('Appearance'),
            _buildThemeTile(themeController),
            const Divider(color: Colors.white24),
            _buildSectionTitle('Account'),
            _buildSettingsTile(
              icon: Icons.person_outline,
              title: 'Profile',
              onTap: () {
                HapticFeedbackHelper.lightImpact();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileSettingsScreen(),
                  ),
                );
              },
            ),
            _buildSettingsTile(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              onTap: () {
                HapticFeedbackHelper.lightImpact();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationsSettingsScreen(),
                  ),
                );
              },
            ),
            _buildSettingsTile(
              icon: Icons.refresh,
              title: 'Reset Onboarding',
              onTap: () {
                HapticFeedbackHelper.lightImpact();
                _showResetOnboardingDialog(context);
              },
            ),
            const Divider(color: Colors.white24),
            _buildSectionTitle('Support'),
            _buildSettingsTile(
              icon: Icons.help_outline,
              title: 'Help Center',
              onTap: () {
                HapticFeedbackHelper.lightImpact();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HelpCenterScreen(),
                  ),
                );
              },
            ),
            _buildSettingsTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              onTap: () {
                HapticFeedbackHelper.lightImpact();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrivacyPolicyScreen(),
                  ),
                );
              },
            ),
            _buildSettingsTile(
              icon: Icons.description_outlined,
              title: 'Terms of Service',
              onTap: () {
                HapticFeedbackHelper.lightImpact();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TermsOfServiceScreen(),
                  ),
                );
              },
            ),
            const Divider(color: Colors.white24),
            _buildSectionTitle('Account'),
            _buildLogoutTile(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white70,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildThemeTile(ThemeController controller) {
    return GetBuilder<ThemeController>(
      builder: (controller) => ListTile(
        leading: Icon(
          controller.isDarkMode
              ? Icons.dark_mode
              : controller.isSystemTheme
                  ? Icons.brightness_auto
                  : Icons.light_mode,
          color: Colors.white,
        ),
        title: Text(
          'Theme',
          style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          controller.isDarkMode
              ? 'Dark'
              : controller.isSystemTheme
                  ? 'System Default'
                  : 'Light',
          style: TextStyle(color: Colors.white70, fontSize: 13.sp),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.5)),
        onTap: () {
          Get.dialog(
            AlertDialog(
              title: const Text('Select Theme'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.brightness_auto),
                    title: const Text('System Default'),
                    onTap: () {
                      controller.setSystemTheme();
                      Get.back();
                    },
                    selected: controller.isSystemTheme,
                  ),
                  ListTile(
                    leading: const Icon(Icons.light_mode),
                    title: const Text('Light'),
                    onTap: () {
                      controller.setLightTheme();
                      Get.back();
                    },
                    selected: !controller.isDarkMode && !controller.isSystemTheme,
                  ),
                  ListTile(
                    leading: const Icon(Icons.dark_mode),
                    title: const Text('Dark'),
                    onTap: () {
                      controller.setDarkTheme();
                      Get.back();
                    },
                    selected: controller.isDarkMode && !controller.isSystemTheme,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 24.sp),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.white.withOpacity(0.5),
        size: 24.sp,
      ),
      onTap: onTap,
    );
  }

  Widget _buildLogoutTile() {
    return ListTile(
      leading: Icon(Icons.logout, color: Colors.red, size: 24.sp),
      title: Text(
        'Logout',
        style: TextStyle(
          color: Colors.red,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: _logout,
    );
  }

  Future<void> _logout() async {
    final controller = Get.find<AuthController>();
    try {
      await controller.logout();
    } catch (e) {
      print('Error during logout: $e');
      // Even if logout fails, clear local data and navigate
      controller.userProfile.value = null;
      controller.isLoggedIn.value = false;
      Get.offAllNamed('/onboarding');
    }
  }

  void _showResetOnboardingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset Onboarding'),
          content: const Text(
            'This will reset the onboarding flow. You will see the welcome screens again on the next app launch. Continue?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final authController = Get.find<AuthController>();
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('onboarding_completed');
                Get.snackbar(
                  'Onboarding Reset',
                  'Onboarding has been reset. Restart the app to see the welcome screens.',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }
} 