import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'gratitude_checkin_flow.dart';

class SleepCheckInFlow extends StatefulWidget {
  const SleepCheckInFlow({Key? key}) : super(key: key);

  @override
  State<SleepCheckInFlow> createState() => _SleepCheckInFlowState();
}

class _SleepCheckInFlowState extends State<SleepCheckInFlow> {
  int step = 0;
  int selectedMood = 2;
  bool showHistory = false;

  @override
  Widget build(BuildContext context) {
    if (showHistory) {
      return _buildSleepHistoryScreen();
    }
    
    return Scaffold(
      backgroundColor: const Color(0xFF2B2E6B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2E6B),
        elevation: 0,
        automaticallyImplyLeading: step > 0,
        title: Text(
          step == 0 ? 'Sleep History' : '',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          if (step == 0)
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () {},
            ),
          if (step == 1 || step == 2)
            IconButton(
              icon: const Icon(Icons.calendar_today, color: Colors.white),
              onPressed: () {},
            ),
          if (step == 2)
            TextButton(
              onPressed: () {},
              child: const Text('Skip', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
        ],
        leading: step > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  setState(() {
                    step--;
                  });
                },
              )
            : null,
      ),
      body: _buildStep(),
    );
  }

  Widget _buildStep() {
    switch (step) {
      case 0:
        return _sleepHistory();
      case 1:
        return _moodSelection();
      case 2:
        return _sleepDuration();
      default:
        return Container();
    }
  }

  Widget _sleepHistory() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "You haven't completed any sleep check-ins yet",
            style: TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white, width: 2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            onPressed: () {
              setState(() {
                step = 1;
              });
            },
            child: const Text(
              'Start Sleep Check-in',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 32),
          TextButton(
            onPressed: () {
              setState(() {
                showHistory = true;
              });
            },
            child: const Text(
              'View Sleep History',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GratitudeCheckInFlow()),
              );
            },
            child: const Text(
              'Go to Gratitude Check-ins',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepHistoryScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFF2B2E6B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2E6B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            setState(() {
              showHistory = false;
            });
          },
        ),
        title: const Text(
          'Sleep History',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              setState(() {
                showHistory = false;
                step = 1;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Week navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, color: Colors.white),
                    onPressed: () {},
                  ),
                  const Text(
                    'Week of May 11',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
              
              // Sleep chart with hours
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Stack(
                  children: [
                    // Horizontal time lines
                    Column(
                      children: [
                        _buildTimeLine('10 am'),
                        SizedBox(height: 20),
                        _buildTimeLine('11 am'),
                        SizedBox(height: 20),
                        _buildTimeLine('12 am'),
                        SizedBox(height: 20),
                        _buildTimeLine('1 pm'),
                        SizedBox(height: 20),
                        _buildTimeLine('2 pm'),
                        SizedBox(height: 20),
                        _buildTimeLine('3 pm'),
                        SizedBox(height: 30),
                      ],
                    ),
                    
                    // Sleep duration indicator
                    Positioned(
                      right: 60.w,
                      top: 0,
                      bottom: 30.h,
                      child: Container(
                        width: 40.w,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color.fromARGB(255, 26, 20, 26),
                              Color(0xFF7B61FF),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Padding(
                            padding:  EdgeInsets.only(top: 20),
                            child: Text(
                              '5h',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    // Days of week at bottom
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 60.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:  [
                          Text('sun', style: TextStyle(color: Colors.white, fontSize: 14.sp)),
                          Text('mon', style: TextStyle(color: Colors.white, fontSize: 14.sp)),
                          Text('tus', style: TextStyle(color: Colors.white, fontSize: 14.sp)),
                          Text('wed', style: TextStyle(color: Colors.white, fontSize: 14.sp)),
                          Text('thu', style: TextStyle(color: Colors.white, fontSize: 14.sp)),
                          Text('fri', style: TextStyle(color: Colors.white, fontSize: 14.sp)),
                          Text('sat', style: TextStyle(color: Colors.white, fontSize: 14.sp)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
               SizedBox(height: 20.h),
              
               Divider(color: Colors.white24),
              
              // Average time asleep
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                     Icon(Icons.nightlight_round, color: Colors.white, size: 20.h),
                     SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:  [
                        Text('Average Time Asleep', 
                          style: TextStyle(color: Colors.white, fontSize: 14.sp)),
                        Text('5h', 
                          style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
              
               Divider(color: Colors.white24),
              
              // Your Insights
               Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Your Insights',
                  style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
              ),
               Text(
                'Last 30 days',
                style: TextStyle(color: Colors.white70, fontSize: 14.sp),
              ),
              
               SizedBox(height: 20.h),
              
              // Unlock insights button
              Container(
                width: double.infinity,
                padding:  EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient:  LinearGradient(
                    colors: [Color(0xFF8F7CFF), Color(0xFFB292FF)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child:  Center(
                  child: Text(
                    'keep checking in to unlock your sleep insights',
                    style: TextStyle(color: Colors.white, fontSize: 12.sp),
                  ),
                ),
              ),
              
               SizedBox(height: 20.h),
              
              // Good sleep card
              Container(
                width: double.infinity,
                padding:  EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color:  Color(0xFF232761),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                     Icon(Icons.trending_up, color: Colors.white, size: 24.h),
                     SizedBox(height: 8),
                     Text(
                      'Most Associated with Your Good Sleep',
                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    ),
                  ],
                ),
              ),
              
               SizedBox(height: 20.h),
              
              // Bad sleep card
              Container(
                width: double.infinity,
                padding:  EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color:  Color(0xFF232761),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                     Icon(Icons.trending_down, color: Colors.white, size: 24.h),
                     SizedBox(height: 8.h),
                     Text(
                      'Most Associated with Your Bad Sleep',
                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Date and mood
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A3F7E),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        // Date with arrow
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:  [
                            Text(
                              'May 16, 2025',
                              style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
                            ),
                            Icon(Icons.chevron_right, color: Colors.white, size: 30.h),
                          ],
                        ),
                        
                         SizedBox(height: 8.h),
                        
                        // Mood
                        Row(
                          children:  [
                            Text('😊', style: TextStyle(fontSize: 20.sp)),
                            SizedBox(width: 8),
                            Text('Okay', style: TextStyle(color: Colors.white, fontSize: 16.sp)),
                          ],
                        ),
                        
                         SizedBox(height: 30.h),
                        
                        // Sleep summary icons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Icon(Icons.nightlight_round, color: Colors.white, size: 28.h),
                                 SizedBox(height: 8.h),
                                Text(
                                  '5h',
                                  style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Total Sleep',
                                  style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14.sp),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Icon(Icons.king_bed_outlined, color: Colors.white, size: 28.h),
                                 SizedBox(height: 8),
                                Text(
                                  '10:00 AM',
                                  style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Bed time',
                                  style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14.sp),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Icon(Icons.wb_sunny_outlined, color: Colors.white, size: 28.h),
                                 SizedBox(height: 8),
                                Text(
                                  '03:00 PM',
                                  style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Wake time',
                                  style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14.sp),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
               SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeLine(String time) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: Colors.white.withOpacity(0.3),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 50,
          child: Text(
            time,
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ],
    );
  }



  Widget _moodSelection() {
    final emojis = ['😫', '😔', '😐', '😊', '😁'];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        LinearProgressIndicator(
          value: 0.5,
          backgroundColor: Colors.white24,
          color: Colors.white,
          minHeight: 3,
        ),
        const SizedBox(height: 60),
        const Text(
          'Tell us how you feel today',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(emojis.length, (i) {
            final isSelected = i == selectedMood;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedMood = i;
                });
                Future.delayed(const Duration(milliseconds: 200), () {
                  setState(() {
                    step = 2;
                  });
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
                  color: isSelected ? Colors.white24 : Colors.transparent,
                ),
                child: Text(
                  emojis[i],
                  style: TextStyle(fontSize: 36, color: isSelected ? Colors.white : Colors.white70),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _sleepDuration() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        LinearProgressIndicator(
          value: 1.0,
          backgroundColor: Colors.white24,
          color: Colors.white,
          minHeight: 3,
        ),
        const SizedBox(height: 40),
        const Text(
          'How many hours did you sleep last night?',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        const SizedBox(height: 30),
        _sleepChart(),
        const SizedBox(height: 40),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF2B2E6B),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                setState(() {
                  showHistory = true;
                });
              },
              child:  Text(
                'Continue',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
              ),
            ),
          ),
        ),
        SizedBox(height: 20.h,)
      ],
    );
  }

  Widget _sleepChart() {
    return Column(
      children: [
        Text('5h 0m', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)),
        Text('Total Sleep', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16)),
        const SizedBox(height: 20),
        SizedBox(
          width: 260,
          height: 260,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer circle (dark ring)
              CustomPaint(
                size: const Size(260, 260),
                painter: _SleepRingPainter(),
              ),
              
              // Time markers
              Positioned(
                top: 40,
                child: Text('12am', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
              ),
              Positioned(
                right: 40,
                child: Text('6am', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
              ),
              Positioned(
                bottom: 40,
                child: Text('12pm', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
              ),
              Positioned(
                left: 40,
                child: Text('6pm', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
              ),
              
              // Sleep arc (light purple)
              CustomPaint(
                size: const Size(260, 260),
                painter: _SleepArcPainter(),
              ),
              
              // Sun icon (wakeup)
              Positioned(
                left: 10,
                bottom: 80,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8F7CFF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.wb_sunny_outlined, color: Colors.white, size: 14),
                ),
              ),
              
              // Moon icon (bedtime)
              Positioned(
                right: 10,
                bottom: 80,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8F7CFF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.nightlight_round, color: Colors.white, size: 14),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Bedtime and Wakeup text
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 60),
              child: Column(
                children: const [
                  Text('02:00 PM', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                  Text('Wakeup', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 60),
              child: Column(
                children: const [
                  Text('08:00 AM', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                  Text('Bedtime', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SleepRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    
    final paint = Paint()
      ..color = const Color(0xFF232761)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 40;
    
    // Draw full circle ring
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SleepArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    final rect = Rect.fromCircle(center: center, radius: radius);
    
    final paint = Paint()
      ..color = const Color(0xFF8F7CFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 40
      ..strokeCap = StrokeCap.round;
    
    // Draw arc representing sleep duration (from bottom right to bottom left)
    // In the image, the arc goes from approximately 8:00 AM to 2:00 PM
    // Converting to radians where 0 is at 3 o'clock and going clockwise
    const double startAngle = 0.3; // Slightly past 3 o'clock (right side)
    const double sweepAngle = 2.6; // Arc covering approximately 5 hours (to bottom left)
    
    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 