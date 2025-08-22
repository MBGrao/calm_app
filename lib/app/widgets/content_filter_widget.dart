import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../data/models/content_model.dart';

class ContentFilterWidget extends StatefulWidget {
  final Function(ContentFilter) onFilterChanged;
  final ContentFilter currentFilter;

  const ContentFilterWidget({
    Key? key,
    required this.onFilterChanged,
    required this.currentFilter,
  }) : super(key: key);

  @override
  State<ContentFilterWidget> createState() => _ContentFilterWidgetState();
}

class _ContentFilterWidgetState extends State<ContentFilterWidget> {
  late ContentFilter _filter;

  final List<String> _categories = [
    'All',
    'Meditation',
    'Sleep',
    'Breathing',
    'Relaxation',
    'Nature',
    'Music',
  ];

  final List<String> _moods = [
    'All',
    'Calm',
    'Energetic',
    'Focused',
    'Relaxed',
    'Peaceful',
    'Stressed',
    'Anxious',
  ];

  final List<DurationFilter> _durationFilters = [
    DurationFilter(label: 'Any', minDuration: null, maxDuration: null),
    DurationFilter(label: 'Under 5 min', minDuration: null, maxDuration: 300),
    DurationFilter(label: '5-15 min', minDuration: 300, maxDuration: 900),
    DurationFilter(label: '15-30 min', minDuration: 900, maxDuration: 1800),
    DurationFilter(label: 'Over 30 min', minDuration: 1800, maxDuration: null),
  ];

  @override
  void initState() {
    super.initState();
    _filter = widget.currentFilter;
  }

  void _updateFilter() {
    widget.onFilterChanged(_filter);
  }

  void _resetFilters() {
    setState(() {
      _filter = ContentFilter();
    });
    _updateFilter();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1B4B6F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filters',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: _resetFilters,
                child: Text(
                  'Reset',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          // Categories
          _buildSectionTitle('Categories'),
          SizedBox(height: 8.h),
          _buildCategoryChips(),
          
          SizedBox(height: 20.h),
          
          // Duration
          _buildSectionTitle('Duration'),
          SizedBox(height: 8.h),
          _buildDurationChips(),
          
          SizedBox(height: 20.h),
          
          // Mood
          _buildSectionTitle('Mood'),
          SizedBox(height: 8.h),
          _buildMoodChips(),
          
          SizedBox(height: 20.h),
          
          // Premium Toggle
          _buildPremiumToggle(),
          
          SizedBox(height: 16.h),
          
          // Apply Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _updateFilter,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF1B4B6F),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Apply Filters',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: _categories.map((category) {
        final isSelected = _filter.categories.contains(category) || 
                          (category == 'All' && _filter.categories.isEmpty);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (category == 'All') {
                _filter.categories.clear();
              } else {
                _filter.categories.remove('All');
                if (isSelected) {
                  _filter.categories.remove(category);
                } else {
                  _filter.categories.add(category);
                }
              }
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
              ),
            ),
            child: Text(
              category,
              style: TextStyle(
                color: isSelected ? const Color(0xFF1B4B6F) : Colors.white,
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDurationChips() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: _durationFilters.map((durationFilter) {
        final isSelected = _filter.durationFilter == durationFilter;
        return GestureDetector(
          onTap: () {
            setState(() {
              _filter.durationFilter = durationFilter;
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
              ),
            ),
            child: Text(
              durationFilter.label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF1B4B6F) : Colors.white,
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMoodChips() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: _moods.map((mood) {
        final isSelected = _filter.moods.contains(mood) || 
                          (mood == 'All' && _filter.moods.isEmpty);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (mood == 'All') {
                _filter.moods.clear();
              } else {
                _filter.moods.remove('All');
                if (isSelected) {
                  _filter.moods.remove(mood);
                } else {
                  _filter.moods.add(mood);
                }
              }
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
              ),
            ),
            child: Text(
              mood,
              style: TextStyle(
                color: isSelected ? const Color(0xFF1B4B6F) : Colors.white,
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPremiumToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Premium Content Only',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        Switch(
          value: _filter.premiumOnly,
          onChanged: (value) {
            setState(() {
              _filter.premiumOnly = value;
            });
          },
          activeColor: Colors.yellow,
          activeTrackColor: Colors.yellow.withOpacity(0.3),
          inactiveThumbColor: Colors.white70,
          inactiveTrackColor: Colors.white.withOpacity(0.3),
        ),
      ],
    );
  }
}

class ContentFilter {
  Set<String> categories;
  Set<String> moods;
  DurationFilter durationFilter;
  bool premiumOnly;

  ContentFilter({
    Set<String>? categories,
    Set<String>? moods,
    DurationFilter? durationFilter,
    this.premiumOnly = false,
  }) : 
    categories = categories ?? <String>{},
    moods = moods ?? <String>{},
    durationFilter = durationFilter ?? DurationFilter(label: 'Any', minDuration: null, maxDuration: null);

  bool matchesContent(ContentModel content) {
    // Category filter
    if (categories.isNotEmpty && !categories.contains('All')) {
      if (!categories.contains(content.categoryDisplayName)) {
        return false;
      }
    }

    // Duration filter
    if (durationFilter.minDuration != null && content.duration < durationFilter.minDuration!) {
      return false;
    }
    if (durationFilter.maxDuration != null && content.duration > durationFilter.maxDuration!) {
      return false;
    }

    // Mood filter
    if (moods.isNotEmpty && !moods.contains('All')) {
      final contentMoods = content.tags.where((tag) => 
        moods.any((mood) => tag.toLowerCase().contains(mood.toLowerCase()))
      );
      if (contentMoods.isEmpty) {
        return false;
      }
    }

    // Premium filter
    if (premiumOnly && !content.isPremium) {
      return false;
    }

    return true;
  }

  List<ContentModel> applyToContent(List<ContentModel> content) {
    return content.where((item) => matchesContent(item)).toList();
  }

  bool get hasActiveFilters {
    return categories.isNotEmpty || 
           moods.isNotEmpty || 
           durationFilter.label != 'Any' || 
           premiumOnly;
  }

  void reset() {
    categories.clear();
    moods.clear();
    durationFilter = DurationFilter(label: 'Any', minDuration: null, maxDuration: null);
    premiumOnly = false;
  }
}

class DurationFilter {
  final String label;
  final int? minDuration; // in seconds
  final int? maxDuration; // in seconds

  DurationFilter({
    required this.label,
    this.minDuration,
    this.maxDuration,
  });
} 