import 'package:flutter/material.dart';
import '../../../widgets/interactive_feedback.dart';

class MoodCheckInFlow extends StatefulWidget {
  const MoodCheckInFlow({Key? key}) : super(key: key);

  @override
  State<MoodCheckInFlow> createState() => _MoodCheckInFlowState();
}

class _MoodCheckInFlowState extends State<MoodCheckInFlow> {
  int? selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1B4B6F),
              Color(0xFF0B1A4A),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Text(
                      'Mood Check-Ins',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.add, color: Colors.white),
                          onPressed: () {
                            HapticFeedbackHelper.lightImpact();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MoodSelectionScreen(),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.list, color: Colors.white),
                          onPressed: () {
                            // Show list view
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Calendar view
              Expanded(
                child: _buildCalendarView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarView() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        // height: 2,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Month navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, color: Colors.white),
                    onPressed: () {},
                  ),
                  const Text(
                    'May',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
              
              const SizedBox(height: 10),
              
              // Days of week (aligned with grid)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  _WeekDayLabel('S'),
                  _WeekDayLabel('M'),
                  _WeekDayLabel('T'),
                  _WeekDayLabel('W'),
                  _WeekDayLabel('T'),
                  _WeekDayLabel('F'),
                  _WeekDayLabel('S'),
                ],
              ),
              
              const SizedBox(height: 6),
              
              // Calendar grid (compact)
              _buildMonthGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthGrid() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildWeekRow([1, 2, 3, 4, 5, 6, 7]),
        _buildWeekRow([8, 9, 10, 11, 12, 13, 14]),
        _buildWeekRow([15, 16, 17, 18, 19, 20, 21]),
        _buildWeekRow([22, 23, 24, 25, 26, 27, 28]),
        _buildWeekRow([29, 30, 31, null, null, null, null]),
      ],
    );
  }

  Widget _buildWeekRow(List<int?> days) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: days.map((day) => _buildDayCell(day)).toList(),
      ),
    );
  }

  Widget _buildDayCell(int? day) {
    if (day == null) {
      return const SizedBox(width: 32);
    }
    final isSelected = selectedDay == day;
    return SizedBox(
      width: 32,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                selectedDay = day;
              });
              _showMoodCheckInDialog(DateTime(2025, 5, day));
            },
            child: Container(
              width: 24,
              height: 24,
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: isSelected ? Colors.green : Colors.black.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            day.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showMoodCheckInDialog(DateTime date) {
    HapticFeedbackHelper.lightImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1B4B6F),
        title: Text(
          'Mood Check-in for ${date.day}/${date.month}/${date.year}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Mood check-in functionality coming soon!',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: TextStyle(color: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeekDayLabel extends StatelessWidget {
  final String label;
  const _WeekDayLabel(this.label, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      child: Center(
        child: Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class MoodSelectionScreen extends StatefulWidget {
  const MoodSelectionScreen({Key? key}) : super(key: key);

  @override
  State<MoodSelectionScreen> createState() => _MoodSelectionScreenState();
}

class _MoodSelectionScreenState extends State<MoodSelectionScreen> {
  String? selectedMood;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1B4B6F),
              Color(0xFF0B1A4A),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Text(
                      'Good evening, Talha!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // How are you feeling?
              const Text(
                'How are you feeling?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Mood grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    shrinkWrap: true,
                    children: [
                      _buildMoodTile('Happy', '😊'),
                      _buildMoodTile('Excited', '😃'),
                      _buildMoodTile('Grateful', '😍'),
                      _buildMoodTile('Happy', '☺️'),
                      _buildMoodTile('Excited', '😁'),
                      _buildMoodTile('Grateful', '🥰'),
                      _buildMoodTile('Happy', '😌'),
                      _buildMoodTile('Excited', '😄'),
                      _buildMoodTile('Grateful', '😍'),
                      _buildMoodTile('Happy', '😊'),
                      _buildMoodTile('Excited', '😃'),
                      _buildMoodTile('Grateful', '🥰'),
                    ],
                  ),
                ),
              ),
              
              // Submit button
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: const BorderSide(color: Colors.white, width: 1),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  ),
                  onPressed: selectedMood != null ? () {
                    Navigator.pop(context);
                  } : null,
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoodTile(String label, String emoji) {
    final isSelected = selectedMood == label + emoji;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMood = label + emoji;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: isSelected 
            ? Border.all(color: Colors.white, width: 2) 
            : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji,
              style: const TextStyle(
                fontSize: 40,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 