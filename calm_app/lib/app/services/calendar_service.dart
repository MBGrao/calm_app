import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class CalendarEvent {
  final String id;
  final DateTime date;
  final String title;
  final String description;
  final String type; // 'meditation', 'gratitude', 'reflection', 'mood', 'sleep'
  final int duration; // in minutes
  final double rating; // 1-5 stars
  final Map<String, dynamic> metadata;

  CalendarEvent({
    required this.id,
    required this.date,
    required this.title,
    required this.description,
    required this.type,
    this.duration = 0,
    this.rating = 0.0,
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'title': title,
      'description': description,
      'type': type,
      'duration': duration,
      'rating': rating,
      'metadata': metadata,
    };
  }

  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
      id: json['id'],
      date: DateTime.parse(json['date']),
      title: json['title'],
      description: json['description'],
      type: json['type'],
      duration: json['duration'] ?? 0,
      rating: json['rating']?.toDouble() ?? 0.0,
      metadata: json['metadata'] ?? {},
    );
  }
}

class CalendarService {
  static final CalendarService _instance = CalendarService._internal();
  factory CalendarService() => _instance;
  CalendarService._internal();

  // Calendar data
  List<CalendarEvent> _events = [];
  DateTime _currentMonth = DateTime.now();
  
  // Streak tracking
  int _currentStreak = 0;
  int _longestStreak = 0;
  DateTime? _lastActivityDate;
  
  // Progress tracking
  Map<String, int> _typeCounts = {};
  int _totalMinutes = 0;
  int _totalSessions = 0;

  // Get current month
  DateTime get currentMonth => _currentMonth;
  
  // Get events for a specific date
  List<CalendarEvent> getEventsForDate(DateTime date) {
    return _events.where((event) => 
      event.date.year == date.year && 
      event.date.month == date.month && 
      event.date.day == date.day
    ).toList();
  }

  // Get events for current month
  List<CalendarEvent> getEventsForMonth(DateTime month) {
    return _events.where((event) => 
      event.date.year == month.year && 
      event.date.month == month.month
    ).toList();
  }

  // Add new event
  Future<void> addEvent(CalendarEvent event) async {
    _events.add(event);
    _updateStats();
    _updateStreaks();
    await _saveEvents();
  }

  // Update event
  Future<void> updateEvent(CalendarEvent event) async {
    final index = _events.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      _events[index] = event;
      _updateStats();
      await _saveEvents();
    }
  }

  // Delete event
  Future<void> deleteEvent(String eventId) async {
    _events.removeWhere((event) => event.id == eventId);
    _updateStats();
    await _saveEvents();
  }

  // Navigate to previous month
  void previousMonth() {
    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
  }

  // Navigate to next month
  void nextMonth() {
    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
  }

  // Navigate to specific month
  void goToMonth(DateTime month) {
    _currentMonth = DateTime(month.year, month.month);
  }

  // Get current streak
  int get currentStreak => _currentStreak;
  
  // Get longest streak
  int get longestStreak => _longestStreak;
  
  // Get total sessions
  int get totalSessions => _totalSessions;
  
  // Get total minutes
  int get totalMinutes => _totalMinutes;
  
  // Get type counts
  Map<String, int> get typeCounts => _typeCounts;

  // Check if date has activity
  bool hasActivity(DateTime date) {
    return getEventsForDate(date).isNotEmpty;
  }

  // Get activity count for date
  int getActivityCount(DateTime date) {
    return getEventsForDate(date).length;
  }

  // Get primary activity type for date
  String? getPrimaryActivityType(DateTime date) {
    final events = getEventsForDate(date);
    if (events.isEmpty) return null;
    
    // Return the most recent event type
    events.sort((a, b) => b.date.compareTo(a.date));
    return events.first.type;
  }

  // Get average rating for date
  double getAverageRating(DateTime date) {
    final events = getEventsForDate(date);
    if (events.isEmpty) return 0.0;
    
    final totalRating = events.fold(0.0, (sum, event) => sum + event.rating);
    return totalRating / events.length;
  }

  // Update statistics
  void _updateStats() {
    _totalSessions = _events.length;
    _totalMinutes = _events.fold(0, (sum, event) => sum + event.duration);
    
    _typeCounts.clear();
    for (final event in _events) {
      _typeCounts[event.type] = (_typeCounts[event.type] ?? 0) + 1;
    }
  }

  // Update streaks
  void _updateStreaks() {
    if (_events.isEmpty) return;
    
    // Sort events by date
    _events.sort((a, b) => b.date.compareTo(a.date));
    final latestEvent = _events.first;
    
    // Check if this is a new day
    if (_lastActivityDate == null || 
        !_isSameDay(latestEvent.date, _lastActivityDate!)) {
      
      // Check if it's consecutive
      if (_lastActivityDate == null || 
          _isConsecutiveDay(latestEvent.date, _lastActivityDate!)) {
        _currentStreak++;
      } else {
        _currentStreak = 1;
      }
      
      _lastActivityDate = latestEvent.date;
      
      // Update longest streak
      if (_currentStreak > _longestStreak) {
        _longestStreak = _currentStreak;
      }
    }
  }

  // Check if two dates are the same day
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && 
           date1.month == date2.month && 
           date1.day == date2.day;
  }

  // Check if two dates are consecutive
  bool _isConsecutiveDay(DateTime date1, DateTime date2) {
    final difference = date1.difference(date2).inDays;
    return difference == 1;
  }

  // Export calendar data
  Future<String> exportCalendarData() async {
    final data = {
      'events': _events.map((e) => e.toJson()).toList(),
      'stats': {
        'totalSessions': _totalSessions,
        'totalMinutes': _totalMinutes,
        'currentStreak': _currentStreak,
        'longestStreak': _longestStreak,
        'typeCounts': _typeCounts,
      },
      'exportDate': DateTime.now().toIso8601String(),
    };
    
    return jsonEncode(data);
  }

  // Save events to local storage
  Future<void> _saveEvents() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/calendar_events.json');
      final data = _events.map((e) => e.toJson()).toList();
      await file.writeAsString(jsonEncode(data));
    } catch (e) {
      print('Error saving calendar events: $e');
    }
  }

  // Load events from local storage
  Future<void> loadEvents() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/calendar_events.json');
      
      if (await file.exists()) {
        final data = await file.readAsString();
        final jsonList = jsonDecode(data) as List;
        _events = jsonList.map((json) => CalendarEvent.fromJson(json)).toList();
        _updateStats();
        _updateStreaks();
      }
    } catch (e) {
      print('Error loading calendar events: $e');
    }
  }

  // Generate sample data for testing
  void generateSampleData() {
    final now = DateTime.now();
    final sampleEvents = [
      CalendarEvent(
        id: '1',
        date: now.subtract(const Duration(days: 1)),
        title: 'Morning Meditation',
        description: 'Started the day with a peaceful meditation session',
        type: 'meditation',
        duration: 15,
        rating: 4.5,
      ),
      CalendarEvent(
        id: '2',
        date: now.subtract(const Duration(days: 2)),
        title: 'Gratitude Practice',
        description: 'Expressed gratitude for family and friends',
        type: 'gratitude',
        duration: 10,
        rating: 5.0,
      ),
      CalendarEvent(
        id: '3',
        date: now.subtract(const Duration(days: 3)),
        title: 'Evening Reflection',
        description: 'Reflected on the day\'s experiences',
        type: 'reflection',
        duration: 20,
        rating: 4.0,
      ),
      CalendarEvent(
        id: '4',
        date: now.subtract(const Duration(days: 4)),
        title: 'Mood Check-in',
        description: 'Feeling grateful and content today',
        type: 'mood',
        duration: 5,
        rating: 4.5,
      ),
      CalendarEvent(
        id: '5',
        date: now.subtract(const Duration(days: 5)),
        title: 'Sleep Preparation',
        description: 'Prepared for a restful night\'s sleep',
        type: 'sleep',
        duration: 30,
        rating: 4.0,
      ),
    ];
    
    _events.addAll(sampleEvents);
    _updateStats();
    _updateStreaks();
  }

  // Get calendar grid data for a month
  List<List<DateTime?>> getCalendarGrid(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    
    final firstWeekday = firstDay.weekday;
    final daysInMonth = lastDay.day;
    
    final grid = <List<DateTime?>>[];
    List<DateTime?> currentWeek = [];
    
    // Add empty cells for days before the first day of the month
    for (int i = 1; i < firstWeekday; i++) {
      currentWeek.add(null);
    }
    
    // Add all days of the month
    for (int day = 1; day <= daysInMonth; day++) {
      currentWeek.add(DateTime(month.year, month.month, day));
      
      if (currentWeek.length == 7) {
        grid.add(currentWeek);
        currentWeek = [];
      }
    }
    
    // Add remaining days to complete the last week
    while (currentWeek.length < 7) {
      currentWeek.add(null);
    }
    
    if (currentWeek.isNotEmpty) {
      grid.add(currentWeek);
    }
    
    return grid;
  }

  // Get activity summary for a date
  Map<String, dynamic> getActivitySummary(DateTime date) {
    final events = getEventsForDate(date);
    
    if (events.isEmpty) {
      return {
        'hasActivity': false,
        'activityCount': 0,
        'primaryType': null,
        'averageRating': 0.0,
        'totalDuration': 0,
      };
    }
    
    final totalDuration = events.fold(0, (sum, event) => sum + event.duration);
    final averageRating = events.fold(0.0, (sum, event) => sum + event.rating) / events.length;
    
    // Get most common type
    final typeCounts = <String, int>{};
    for (final event in events) {
      typeCounts[event.type] = (typeCounts[event.type] ?? 0) + 1;
    }
    final primaryType = typeCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
    
    return {
      'hasActivity': true,
      'activityCount': events.length,
      'primaryType': primaryType,
      'averageRating': averageRating,
      'totalDuration': totalDuration,
      'events': events,
    };
  }
} 