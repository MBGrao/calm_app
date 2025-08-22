import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class DailyAiSuggestion extends StatefulWidget {
  const DailyAiSuggestion({Key? key}) : super(key: key);

  @override
  State<DailyAiSuggestion> createState() => _DailyAiSuggestionState();
}

class _DailyAiSuggestionState extends State<DailyAiSuggestion> {
  final List<String> _suggestions = [
    'Take a moment to breathe deeply and center yourself. Today\'s focus is on cultivating inner peace through mindful awareness.',
    'Practice gratitude by reflecting on three things you\'re thankful for today. Notice how this shifts your perspective.',
    'Find a quiet space and spend 5 minutes in mindful breathing. Focus on the sensation of air moving in and out of your body.',
    'Take a mindful walk today, paying attention to each step and the sensations in your body as you move.',
    'Practice loving-kindness meditation by sending positive thoughts to yourself and others.',
    'Notice the small moments of joy throughout your day - a warm cup of tea, a kind smile, or a beautiful sunset.',
    'Take a moment to stretch your body mindfully, paying attention to how each movement feels.',
    'Practice deep listening in your conversations today, giving your full attention to the person speaking.',
    'Take a digital detox for 30 minutes and connect with your surroundings.',
    'Write down three positive affirmations and repeat them to yourself throughout the day.',
  ];

  late String _currentSuggestion;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _currentSuggestion = _suggestions[_random.nextInt(_suggestions.length)];
  }

  void _refreshSuggestion() {
    setState(() {
      String newSuggestion;
      do {
        newSuggestion = _suggestions[_random.nextInt(_suggestions.length)];
      } while (newSuggestion == _currentSuggestion);
      _currentSuggestion = newSuggestion;
    });
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final formattedDate = DateFormat('MMMM d, yyyy').format(today);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Today\'s Guidance',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  formattedDate,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _currentSuggestion,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 12.sp,
                height: 1.5,
              ),
            ),
             SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _refreshSuggestion,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.refresh,
                        color: Colors.white.withOpacity(0.7),
                        size: 16,
                      ),
                       SizedBox(width: 4.w),
                      Text(
                        'Refresh',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 