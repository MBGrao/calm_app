import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();
  
  final _isDarkMode = false.obs;
  final _isSystemTheme = true.obs;
  
  bool get isDarkMode => _isDarkMode.value;
  bool get isSystemTheme => _isSystemTheme.value;
  
  ThemeMode get themeMode {
    if (_isSystemTheme.value) {
      return ThemeMode.system;
    }
    return _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;
  }
  
  ThemeData get lightTheme => AppTheme.lightTheme;
  ThemeData get darkTheme => AppTheme.darkTheme;
  
  @override
  void onInit() {
    super.onInit();
    _loadThemePreference();
  }
  
  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode.value = prefs.getBool('isDarkMode') ?? false;
      _isSystemTheme.value = prefs.getBool('isSystemTheme') ?? true;
    } catch (e) {
      // If SharedPreferences fails, use default values
      _isDarkMode.value = false;
      _isSystemTheme.value = true;
    }
  }
  
  Future<void> _saveThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkMode', _isDarkMode.value);
      await prefs.setBool('isSystemTheme', _isSystemTheme.value);
    } catch (e) {
      // Handle error silently
      debugPrint('Failed to save theme preference: $e');
    }
  }
  
  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    _isSystemTheme.value = false;
    _saveThemePreference();
    Get.changeThemeMode(themeMode);
  }
  
  void setLightTheme() {
    _isDarkMode.value = false;
    _isSystemTheme.value = false;
    _saveThemePreference();
    Get.changeThemeMode(ThemeMode.light);
  }
  
  void setDarkTheme() {
    _isDarkMode.value = true;
    _isSystemTheme.value = false;
    _saveThemePreference();
    Get.changeThemeMode(ThemeMode.dark);
  }
  
  void setSystemTheme() {
    _isSystemTheme.value = true;
    _saveThemePreference();
    Get.changeThemeMode(ThemeMode.system);
  }
  
  void updateSystemTheme(Brightness brightness) {
    if (_isSystemTheme.value) {
      _isDarkMode.value = brightness == Brightness.dark;
      Get.changeThemeMode(themeMode);
    }
  }
  
  // Helper methods for getting theme-aware colors
  Color getPrimaryColor() {
    return AppTheme.getPrimaryColor(_isDarkMode.value);
  }
  
  Color getBackgroundColor() {
    return AppTheme.getBackgroundColor(_isDarkMode.value);
  }
  
  Color getSurfaceColor() {
    return AppTheme.getSurfaceColor(_isDarkMode.value);
  }
  
  Color getTextColor() {
    return AppTheme.getTextColor(_isDarkMode.value);
  }
  
  Color getSecondaryTextColor() {
    return AppTheme.getSecondaryTextColor(_isDarkMode.value);
  }
  
  List<Color> getGradientColors() {
    return AppTheme.getGradientColors(_isDarkMode.value);
  }
  
  // Stream for listening to theme changes
  Stream<bool> get darkModeStream => _isDarkMode.stream;
  Stream<bool> get systemThemeStream => _isSystemTheme.stream;
} 