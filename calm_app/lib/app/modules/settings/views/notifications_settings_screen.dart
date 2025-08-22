import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../widgets/interactive_feedback.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsSettingsScreen> createState() => _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState extends State<NotificationsSettingsScreen> {
  // Push notification toggles
  bool _pushNotificationsEnabled = true;
  bool _meditationReminders = true;
  bool _dailyMotivation = true;
  bool _sleepReminders = false;
  bool _weeklyProgress = true;
  bool _newContentAlerts = false;
  
  // Email notification preferences
  bool _emailNotificationsEnabled = false;
  bool _weeklyReports = false;
  bool _achievementEmails = true;
  bool _newsletterEmails = false;
  
  // Time settings
  TimeOfDay _meditationReminderTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _sleepReminderTime = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _motivationTime = const TimeOfDay(hour: 9, minute: 0);
  
  // Notification sound
  String _selectedSound = 'Gentle Chime';
  final List<String> _notificationSounds = [
    'Gentle Chime',
    'Soft Bell',
    'Nature Sounds',
    'Zen Gong',
    'Ocean Waves',
    'Forest Birds',
    'None'
  ];
  
  // Days for reminders
  final Map<String, bool> _reminderDays = {
    'Monday': true,
    'Tuesday': true,
    'Wednesday': true,
    'Thursday': true,
    'Friday': true,
    'Saturday': false,
    'Sunday': false,
  };
  
  bool _isSaving = false;

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
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

  Future<void> _selectTime(BuildContext context, TimeOfDay currentTime, Function(TimeOfDay) onTimeSelected) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: currentTime,
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
      onTimeSelected(picked);
      HapticFeedbackHelper.lightImpact();
    }
  }

  Future<void> _savePreferences() async {
    setState(() {
      _isSaving = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 1500));
      
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
        _showSuccessSnackBar('Notification preferences saved successfully!');
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
        _showErrorSnackBar('Failed to save preferences: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B4B6F),
      appBar: AppBar(
        title: const Text(
          'Notifications',
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
                    Padding(
          padding: EdgeInsets.all(16.0),
          child: SizedBox(
            width: 20,
            height: 20,
            child: const CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        )
          else
            TextButton(
              onPressed: _savePreferences,
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Push Notifications Section
            _buildPushNotificationsSection(),
            SizedBox(height: 24.h),
            
            // Email Notifications Section
            _buildEmailNotificationsSection(),
            SizedBox(height: 24.h),
            
            // Reminder Times Section
            _buildReminderTimesSection(),
            SizedBox(height: 24.h),
            
            // Reminder Days Section
            _buildReminderDaysSection(),
            SizedBox(height: 24.h),
            
            // Notification Sound Section
            _buildNotificationSoundSection(),
            SizedBox(height: 32.h),
            
            // Save Button
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildPushNotificationsSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.notifications_active, color: Colors.white, size: 24.sp),
              SizedBox(width: 12.w),
              Text(
                'Push Notifications',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          
          // Main toggle
          _buildToggleTile(
            title: 'Enable Push Notifications',
            subtitle: 'Receive notifications on your device',
            value: _pushNotificationsEnabled,
            onChanged: (value) {
              setState(() {
                _pushNotificationsEnabled = value;
                if (!value) {
                  // Disable all push notifications if main toggle is off
                  _meditationReminders = false;
                  _dailyMotivation = false;
                  _sleepReminders = false;
                  _weeklyProgress = false;
                  _newContentAlerts = false;
                }
              });
              HapticFeedbackHelper.lightImpact();
            },
          ),
          
          if (_pushNotificationsEnabled) ...[
            SizedBox(height: 8.h),
            _buildToggleTile(
              title: 'Meditation Reminders',
              subtitle: 'Daily reminders to meditate',
              value: _meditationReminders,
              onChanged: (value) {
                setState(() {
                  _meditationReminders = value;
                });
                HapticFeedbackHelper.lightImpact();
              },
            ),
            SizedBox(height: 8.h),
            _buildToggleTile(
              title: 'Daily Motivation',
              subtitle: 'Inspirational quotes and messages',
              value: _dailyMotivation,
              onChanged: (value) {
                setState(() {
                  _dailyMotivation = value;
                });
                HapticFeedbackHelper.lightImpact();
              },
            ),
            SizedBox(height: 8.h),
            _buildToggleTile(
              title: 'Sleep Reminders',
              subtitle: 'Reminders to prepare for sleep',
              value: _sleepReminders,
              onChanged: (value) {
                setState(() {
                  _sleepReminders = value;
                });
                HapticFeedbackHelper.lightImpact();
              },
            ),
            SizedBox(height: 8.h),
            _buildToggleTile(
              title: 'Weekly Progress',
              subtitle: 'Summary of your meditation journey',
              value: _weeklyProgress,
              onChanged: (value) {
                setState(() {
                  _weeklyProgress = value;
                });
                HapticFeedbackHelper.lightImpact();
              },
            ),
            SizedBox(height: 8.h),
            _buildToggleTile(
              title: 'New Content Alerts',
              subtitle: 'New meditations and features',
              value: _newContentAlerts,
              onChanged: (value) {
                setState(() {
                  _newContentAlerts = value;
                });
                HapticFeedbackHelper.lightImpact();
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmailNotificationsSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.email, color: Colors.white, size: 24.sp),
              SizedBox(width: 12.w),
              Text(
                'Email Notifications',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          
          _buildToggleTile(
            title: 'Enable Email Notifications',
            subtitle: 'Receive notifications via email',
            value: _emailNotificationsEnabled,
            onChanged: (value) {
              setState(() {
                _emailNotificationsEnabled = value;
                if (!value) {
                  // Disable all email notifications if main toggle is off
                  _weeklyReports = false;
                  _achievementEmails = false;
                  _newsletterEmails = false;
                }
              });
              HapticFeedbackHelper.lightImpact();
            },
          ),
          
          if (_emailNotificationsEnabled) ...[
            SizedBox(height: 8.h),
            _buildToggleTile(
              title: 'Weekly Reports',
              subtitle: 'Detailed weekly meditation summary',
              value: _weeklyReports,
              onChanged: (value) {
                setState(() {
                  _weeklyReports = value;
                });
                HapticFeedbackHelper.lightImpact();
              },
            ),
            SizedBox(height: 8.h),
            _buildToggleTile(
              title: 'Achievement Emails',
              subtitle: 'Celebrate your milestones',
              value: _achievementEmails,
              onChanged: (value) {
                setState(() {
                  _achievementEmails = value;
                });
                HapticFeedbackHelper.lightImpact();
              },
            ),
            SizedBox(height: 8.h),
            _buildToggleTile(
              title: 'Newsletter',
              subtitle: 'Tips, stories, and updates',
              value: _newsletterEmails,
              onChanged: (value) {
                setState(() {
                  _newsletterEmails = value;
                });
                HapticFeedbackHelper.lightImpact();
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReminderTimesSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.access_time, color: Colors.white, size: 24.sp),
              SizedBox(width: 12.w),
              Text(
                'Reminder Times',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          
          // Meditation Reminder Time
          if (_meditationReminders) ...[
            _buildTimeTile(
              title: 'Meditation Reminder',
              subtitle: 'Daily meditation reminder time',
              time: _meditationReminderTime,
              onTap: () => _selectTime(context, _meditationReminderTime, (time) {
                setState(() {
                  _meditationReminderTime = time;
                });
              }),
            ),
            SizedBox(height: 12.h),
          ],
          
          // Daily Motivation Time
          if (_dailyMotivation) ...[
            _buildTimeTile(
              title: 'Daily Motivation',
              subtitle: 'Time for inspirational messages',
              time: _motivationTime,
              onTap: () => _selectTime(context, _motivationTime, (time) {
                setState(() {
                  _motivationTime = time;
                });
              }),
            ),
            SizedBox(height: 12.h),
          ],
          
          // Sleep Reminder Time
          if (_sleepReminders) ...[
            _buildTimeTile(
              title: 'Sleep Reminder',
              subtitle: 'Time to prepare for sleep',
              time: _sleepReminderTime,
              onTap: () => _selectTime(context, _sleepReminderTime, (time) {
                setState(() {
                  _sleepReminderTime = time;
                });
              }),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReminderDaysSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today, color: Colors.white, size: 24.sp),
              SizedBox(width: 12.w),
              Text(
                'Reminder Days',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          
          Text(
            'Select days for meditation reminders',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 12.h),
          
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: _reminderDays.entries.map((entry) {
              return FilterChip(
                label: Text(
                  entry.key,
                  style: TextStyle(
                    color: entry.value ? Colors.white : Colors.white70,
                    fontSize: 12.sp,
                  ),
                ),
                selected: entry.value,
                onSelected: (selected) {
                  setState(() {
                    _reminderDays[entry.key] = selected;
                  });
                  HapticFeedbackHelper.lightImpact();
                },
                backgroundColor: Colors.transparent,
                selectedColor: Colors.orange.withOpacity(0.3),
                side: BorderSide(
                  color: entry.value ? Colors.orange : Colors.white30,
                ),
                checkmarkColor: Colors.orange,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSoundSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.volume_up, color: Colors.white, size: 24.sp),
              SizedBox(width: 12.w),
              Text(
                'Notification Sound',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white30),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedSound,
                dropdownColor: const Color(0xFF1B2631),
                style: const TextStyle(color: Colors.white),
                items: _notificationSounds.map((String sound) {
                  return DropdownMenuItem<String>(
                    value: sound,
                    child: Text(sound),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedSound = newValue;
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

  Widget _buildToggleTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.orange,
        ),
      ],
    );
  }

  Widget _buildTimeTile({
    required String title,
    required String subtitle,
    required TimeOfDay time,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white30),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              time.format(context),
              style: TextStyle(
                color: Colors.orange,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8.w),
            const Icon(Icons.access_time, color: Colors.white70, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: _isSaving ? null : _savePreferences,
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
                'Save Preferences',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
} 