import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../services/calendar_service.dart';
import '../widgets/interactive_feedback.dart';
import 'dart:async';

class InteractiveCalendarWidget extends StatefulWidget {
  final Function(DateTime)? onDateSelected;
  final Function(CalendarEvent)? onEventCreated;
  final bool showNavigation;
  final bool showStreaks;
  final bool showProgress;

  const InteractiveCalendarWidget({
    Key? key,
    this.onDateSelected,
    this.onEventCreated,
    this.showNavigation = true,
    this.showStreaks = true,
    this.showProgress = true,
  }) : super(key: key);

  @override
  State<InteractiveCalendarWidget> createState() => _InteractiveCalendarWidgetState();
}

class _InteractiveCalendarWidgetState extends State<InteractiveCalendarWidget> with TickerProviderStateMixin {
  final CalendarService _calendarService = CalendarService();
  DateTime _selectedDate = DateTime.now();
  DateTime _currentMonth = DateTime.now();
  
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _streakController;
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadCalendarData();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _streakController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _streakController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  Future<void> _loadCalendarData() async {
    setState(() {
      _isLoading = true;
    });

    await _calendarService.loadEvents();
    
    // Generate sample data if no events exist
    if (_calendarService.totalSessions == 0) {
      _calendarService.generateSampleData();
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _onDateSelected(DateTime date) {
    HapticFeedbackHelper.lightImpact();
    setState(() {
      _selectedDate = date;
    });
    
    widget.onDateSelected?.call(date);
    
    // Show event details if date has activity
    final events = _calendarService.getEventsForDate(date);
    if (events.isNotEmpty) {
      _showEventDetailsDialog(events);
    } else {
      _showCreateEventDialog(date);
    }
  }

  void _showEventDetailsDialog(List<CalendarEvent> events) {
    showDialog(
      context: context,
      builder: (context) => _buildEventDetailsDialog(events),
    );
  }

  void _showCreateEventDialog(DateTime date) {
    showDialog(
      context: context,
      builder: (context) => _buildCreateEventDialog(date),
    );
  }

  Widget _buildEventDetailsDialog(List<CalendarEvent> events) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1B4B6F),
      title: Text(
        'Activities on ${_formatDate(_selectedDate)}',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...events.map((event) => _buildEventCard(event)),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showCreateEventDialog(_selectedDate);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Add Activity'),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _exportCalendarData();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Colors.white),
                    ),
                    child: Text('Export'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Close',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      ],
    );
  }

  Widget _buildEventCard(CalendarEvent event) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getEventIcon(event.type),
                color: _getEventColor(event.type),
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  event.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.yellow, size: 16.sp),
                  SizedBox(width: 4.w),
                  Text(
                    event.rating.toString(),
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            event.description,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12.sp,
            ),
          ),
          if (event.duration > 0) ...[
            SizedBox(height: 4.h),
            Text(
              'Duration: ${event.duration} minutes',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12.sp,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCreateEventDialog(DateTime date) {
    String selectedType = 'meditation';
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    double rating = 0.0;
    int duration = 10;

    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1B4B6F),
          title: Text(
            'Add Activity',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Activity type selector
              DropdownButtonFormField<String>(
                value: selectedType,
                dropdownColor: const Color(0xFF1B4B6F),
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
                decoration: InputDecoration(
                  labelText: 'Activity Type',
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                  ),
                ),
                items: [
                  DropdownMenuItem(value: 'meditation', child: Text('Meditation')),
                  DropdownMenuItem(value: 'gratitude', child: Text('Gratitude')),
                  DropdownMenuItem(value: 'reflection', child: Text('Reflection')),
                  DropdownMenuItem(value: 'mood', child: Text('Mood Check-in')),
                  DropdownMenuItem(value: 'sleep', child: Text('Sleep')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedType = value!;
                  });
                },
              ),
              SizedBox(height: 16.h),
              
              // Title input
              TextField(
                controller: titleController,
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              
              // Description input
              TextField(
                controller: descriptionController,
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              
              // Duration slider
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Duration: ${duration} minutes',
                    style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                  ),
                  Slider(
                    value: duration.toDouble(),
                    min: 1,
                    max: 120,
                    divisions: 119,
                    activeColor: Colors.orange,
                    onChanged: (value) {
                      setState(() {
                        duration = value.round();
                      });
                    },
                  ),
                ],
              ),
              
              // Rating
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rating: ${rating.toStringAsFixed(1)}',
                    style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        onPressed: () {
                          setState(() {
                            rating = index + 1.0;
                          });
                        },
                        icon: Icon(
                          Icons.star,
                          color: index < rating ? Colors.yellow : Colors.white54,
                          size: 24.sp,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  final event = CalendarEvent(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    date: date,
                    title: titleController.text,
                    description: descriptionController.text,
                    type: selectedType,
                    duration: duration,
                    rating: rating,
                  );
                  
                  _calendarService.addEvent(event);
                  widget.onEventCreated?.call(event);
                  
                  Navigator.pop(context);
                  setState(() {});
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Activity added successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _exportCalendarData() async {
    try {
      await _calendarService.exportCalendarData();
      // In a real app, this would save to a file or share
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Calendar data exported successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to export calendar data'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          // Header with navigation
          if (widget.showNavigation) _buildCalendarHeader(),
          
          // Streak information
          if (widget.showStreaks) _buildStreakInfo(),
          
          // Progress information
          if (widget.showProgress) _buildProgressInfo(),
          
          SizedBox(height: 16.h),
          
          // Calendar grid
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            HapticFeedbackHelper.lightImpact();
            setState(() {
              _calendarService.previousMonth();
              _currentMonth = _calendarService.currentMonth;
            });
          },
          icon: Icon(Icons.chevron_left, color: Colors.white),
        ),
        Text(
          _formatMonth(_currentMonth),
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          onPressed: () {
            HapticFeedbackHelper.lightImpact();
            setState(() {
              _calendarService.nextMonth();
              _currentMonth = _calendarService.currentMonth;
            });
          },
          icon: Icon(Icons.chevron_right, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildStreakInfo() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                '${_calendarService.currentStreak}',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Current Streak',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                '${_calendarService.longestStreak}',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Longest Streak',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressInfo() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                '${_calendarService.totalSessions}',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Total Sessions',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                '${_calendarService.totalMinutes}',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Total Minutes',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final grid = _calendarService.getCalendarGrid(_currentMonth);
    
    return Column(
      children: [
        // Day headers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day) {
            return SizedBox(
              width: 32.w,
              child: Center(
                child: Text(
                  day,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 8.h),
        
        // Calendar grid
        ...grid.map((week) => _buildWeekRow(week)),
      ],
    );
  }

  Widget _buildWeekRow(List<DateTime?> week) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: week.map((date) => _buildDayCell(date)).toList(),
      ),
    );
  }

  Widget _buildDayCell(DateTime? date) {
    if (date == null) {
      return SizedBox(width: 32.w, height: 32.h);
    }

    final isSelected = _isSameDay(date, _selectedDate);
    final isToday = _isSameDay(date, DateTime.now());
    final hasActivity = _calendarService.hasActivity(date);
    final activityCount = _calendarService.getActivityCount(date);
    final primaryType = _calendarService.getPrimaryActivityType(date);

    return GestureDetector(
      onTap: () => _onDateSelected(date),
      child: Container(
        width: 32.w,
        height: 32.h,
        decoration: BoxDecoration(
          color: isSelected 
              ? Colors.orange 
              : hasActivity 
                  ? _getEventColor(primaryType ?? 'meditation').withOpacity(0.3)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
          border: isToday 
              ? Border.all(color: Colors.white, width: 2)
              : null,
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                '${date.day}',
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (hasActivity && activityCount > 1)
              Positioned(
                top: 2.h,
                right: 2.w,
                child: Container(
                  width: 8.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${activityCount > 9 ? '9+' : activityCount}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 6.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && 
           date1.month == date2.month && 
           date1.day == date2.day;
  }

  String _formatMonth(DateTime date) {
    return '${_getMonthName(date.month)} ${date.year}';
  }

  String _formatDate(DateTime date) {
    return '${_getMonthName(date.month)} ${date.day}, ${date.year}';
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  IconData _getEventIcon(String type) {
    switch (type) {
      case 'meditation':
        return Icons.self_improvement;
      case 'gratitude':
        return Icons.favorite;
      case 'reflection':
        return Icons.edit;
      case 'mood':
        return Icons.emoji_emotions;
      case 'sleep':
        return Icons.nightlight_round;
      default:
        return Icons.event;
    }
  }

  Color _getEventColor(String type) {
    switch (type) {
      case 'meditation':
        return Colors.blue;
      case 'gratitude':
        return Colors.pink;
      case 'reflection':
        return Colors.purple;
      case 'mood':
        return Colors.orange;
      case 'sleep':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }
} 