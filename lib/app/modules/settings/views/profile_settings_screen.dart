import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../../../widgets/interactive_feedback.dart';
import '../../auth/controllers/auth_controller.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({Key? key}) : super(key: key);

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _bioController = TextEditingController();
  
  // Profile state
  File? _selectedImage;
  bool _isLoading = false;
  bool _isSaving = false;
  
  // Meditation preferences
  String _selectedDuration = '10 minutes';
  String _selectedType = 'Mindfulness';
  bool _enableReminders = true;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 8, minute: 0);
  
  // Language and timezone
  String _selectedLanguage = 'English';
  String _selectedTimezone = 'UTC+0';
  
  final List<String> _durations = ['5 minutes', '10 minutes', '15 minutes', '20 minutes', '30 minutes'];
  final List<String> _types = ['Mindfulness', 'Loving-Kindness', 'Body Scan', 'Breathing', 'Walking'];
  final List<String> _languages = ['English', 'Spanish', 'French', 'German', 'Chinese', 'Japanese'];
  final List<String> _timezones = ['UTC+0', 'UTC+1', 'UTC+2', 'UTC+3', 'UTC+4', 'UTC+5', 'UTC+6', 'UTC+7', 'UTC+8', 'UTC+9', 'UTC+10', 'UTC+11', 'UTC+12'];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load user data from auth controller
      final authController = Get.find<AuthController>();
      if (authController.userProfile.value != null) {
        final user = authController.userProfile.value!;
        final profile = user.profile;
        
        setState(() {
          _nameController.text = user.name;
          _emailController.text = user.email;
          _bioController.text = profile['bio'] ?? '';
          _selectedDuration = profile['preferredDuration'] ?? '10 minutes';
          _selectedType = profile['preferredType'] ?? 'Mindfulness';
          _enableReminders = profile['enableReminders'] ?? false;
          _selectedLanguage = profile['language'] ?? 'English';
          _selectedTimezone = profile['timezone'] ?? 'UTC+0';
          _isLoading = false;
        });
      } else {
        // If no user profile, try to load it from the backend
        await authController.loadUserProfile();
        if (authController.userProfile.value != null) {
          await _loadUserData(); // Recursive call to load the data
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        HapticFeedbackHelper.lightImpact();
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Removed unused function _showSuccessSnackBar

  Future<void> _selectReminderTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF1B4B6F),
              onPrimary: Colors.white,
              surface: Color(0xFF1B2631),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _reminderTime = picked;
      });
      HapticFeedbackHelper.lightImpact();
    }
  }

  bool _validateForm() {
    if (!_formKey.currentState!.validate()) {
      return false;
    }

    if (_nameController.text.trim().isEmpty) {
      _showErrorSnackBar('Name is required');
      return false;
    }

    if (_emailController.text.trim().isEmpty) {
      _showErrorSnackBar('Email is required');
      return false;
    }

    // Basic email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(_emailController.text.trim())) {
      _showErrorSnackBar('Please enter a valid email address');
      return false;
    }

    return true;
  }

  Future<void> _saveProfile() async {
    if (!_validateForm()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final authController = Get.find<AuthController>();
      
      // Prepare profile data
      final profileData = {
        'bio': _bioController.text.trim(),
        'preferredDuration': _selectedDuration,
        'preferredType': _selectedType,
        'enableReminders': _enableReminders,
        'reminderTime': _enableReminders ? _reminderTime.format(context) : null,
        'language': _selectedLanguage,
        'timezone': _selectedTimezone,
      };

      await authController.updateProfile(profileData);
      
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
        HapticFeedbackHelper.mediumImpact();
        
        // Navigate back after a short delay
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pop(context);
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
        _showErrorSnackBar('Failed to save profile: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B4B6F),
      appBar: AppBar(
        title: const Text(
          'Profile Settings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1B4B6F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _saveProfile,
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar Section
                    _buildAvatarSection(),
                    SizedBox(height: 24.h),
                    
                    // Profile Information
                    _buildProfileSection(),
                    SizedBox(height: 24.h),
                    
                    // Meditation Preferences
                    _buildMeditationSection(),
                    SizedBox(height: 24.h),
                    
                    // Language & Timezone
                    _buildLanguageTimezoneSection(),
                    SizedBox(height: 32.h),
                    
                    // Save Button
                    _buildSaveButton(),
                    SizedBox(height: 16.h),
                    
                    // Logout Button
                    _buildLogoutButton(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildAvatarSection() {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipOval(
                child: _selectedImage != null
                    ? Image.file(
                        _selectedImage!,
                        fit: BoxFit.cover,
                        width: 120.w,
                        height: 120.w,
                      )
                    : Container(
                        color: Colors.white.withOpacity(0.1),
                        child: const Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          TextButton(
            onPressed: _pickImage,
            child: const Text(
              'Change Photo',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profile Information',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          
          // Name Field
          TextFormField(
            controller: _nameController,
            style: const TextStyle(color: Colors.black, fontSize: 16),
            decoration: InputDecoration(
              labelText: 'Full Name',
              labelStyle: const TextStyle(color: Colors.black54),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Name is required';
              }
              return null;
            },
          ),
          SizedBox(height: 16.h),
          
          // Email Field
          TextFormField(
            controller: _emailController,
            style: const TextStyle(color: Colors.black, fontSize: 16),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: const TextStyle(color: Colors.black54),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Email is required';
              }
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value.trim())) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          SizedBox(height: 16.h),
          
          // Bio Field
          TextFormField(
            controller: _bioController,
            style: const TextStyle(color: Colors.black, fontSize: 16),
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Bio',
              labelStyle: const TextStyle(color: Colors.black54),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.white, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeditationSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Meditation Preferences',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          
          // Duration Preference
          Text(
            'Preferred Duration',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white30),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedDuration,
                dropdownColor: const Color(0xFF1B2631),
                style: const TextStyle(color: Colors.white),
                items: _durations.map((String duration) {
                  return DropdownMenuItem<String>(
                    value: duration,
                    child: Text(duration),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedDuration = newValue;
                    });
                    HapticFeedbackHelper.lightImpact();
                  }
                },
              ),
            ),
          ),
          SizedBox(height: 16.h),
          
          // Type Preference
          Text(
            'Preferred Type',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white30),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedType,
                dropdownColor: const Color(0xFF1B2631),
                style: const TextStyle(color: Colors.white),
                items: _types.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedType = newValue;
                    });
                    HapticFeedbackHelper.lightImpact();
                  }
                },
              ),
            ),
          ),
          SizedBox(height: 16.h),
          
          // Reminders
          Row(
            children: [
              Expanded(
                child: Text(
                  'Daily Reminders',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              Switch(
                value: _enableReminders,
                onChanged: (bool value) {
                  setState(() {
                    _enableReminders = value;
                  });
                  HapticFeedbackHelper.lightImpact();
                },
                activeColor: Colors.orange,
              ),
            ],
          ),
          
          if (_enableReminders) ...[
            SizedBox(height: 12.h),
            GestureDetector(
              onTap: _selectReminderTime,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time, color: Colors.white70, size: 20),
                    SizedBox(width: 8.w),
                    Text(
                      'Reminder Time: ${_reminderTime.format(context)}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_drop_down, color: Colors.white70),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLanguageTimezoneSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Language & Timezone',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          
          // Language
          Text(
            'Language',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white30),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedLanguage,
                dropdownColor: const Color(0xFF1B2631),
                style: const TextStyle(color: Colors.white),
                items: _languages.map((String language) {
                  return DropdownMenuItem<String>(
                    value: language,
                    child: Text(language),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedLanguage = newValue;
                    });
                    HapticFeedbackHelper.lightImpact();
                  }
                },
              ),
            ),
          ),
          SizedBox(height: 16.h),
          
          // Timezone
          Text(
            'Timezone',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white30),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedTimezone,
                dropdownColor: const Color(0xFF1B2631),
                style: const TextStyle(color: Colors.white),
                items: _timezones.map((String timezone) {
                  return DropdownMenuItem<String>(
                    value: timezone,
                    child: Text(timezone),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedTimezone = newValue;
                    });
                    HapticFeedbackHelper.lightImpact();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: _isSaving ? null : _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 4,
        ),
        child: _isSaving
            ? SizedBox(
                height: 20.h,
                width: 20.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                'Save Changes',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: _logout,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 4,
        ),
        child: Text(
          'Logout',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<void> _logout() async {
    try {
      final authController = Get.find<AuthController>();
      await authController.logout();
    } catch (e) {
      print('Error during logout: $e');
      // Even if logout fails, clear local data and navigate
      final authController = Get.find<AuthController>();
      authController.userProfile.value = null;
      authController.isLoggedIn.value = false;
      Get.offAllNamed('/onboarding');
    }
  }
} 