import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import 'checkin_detail_screen.dart';
import 'sleep_checkin_flow.dart';
import 'gratitude_checkin_flow.dart';
import '../../../widgets/interactive_calendar_widget.dart';
import '../../../widgets/interactive_feedback.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String selectedTab = 'Dashboard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Container(
             decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1B517E),
              Color(0xFF0D3550),
              Color(0xFF32366F),
              Color(0xFF1B517E),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          children: [
            // Top bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.settings, color: Colors.white, size: 28),
                  onPressed: () => Get.toNamed(AppRoutes.settings),
                ),
                const Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                      height: 40.h,
                      width: 40.w,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(100),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFFDD015),
                            Color(0xFFBE8926),
                            Color(0xFFFDD015),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/icons/home_screen/gift.png',
                          height: 24.h,
                          width: 24.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
              ],
            ),
            const SizedBox(height: 18),
            // Tab bar
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _tabChip('Dashboard', selected: selectedTab == 'Dashboard', onTap: () => setState(() => selectedTab = 'Dashboard')),
                  _tabChip('Library', selected: selectedTab == 'Library', onTap: () => setState(() => selectedTab = 'Library')),
                  _tabChip('History', selected: selectedTab == 'History', onTap: () => setState(() => selectedTab = 'History')),
                  _tabChip('Check-Ins', selected: selectedTab == 'Check-Ins', onTap: () => setState(() => selectedTab = 'Check-Ins')),
                ],
              ),
            ),
            const SizedBox(height: 18),
            if (selectedTab == 'Dashboard') ..._dashboardContent(),
            if (selectedTab == 'History') ..._historyContent(),
            if (selectedTab == 'Check-Ins') ..._checkInsContent(),
          ],
        ),
      ),
    );
  }

  Widget _tabChip(String label, {bool selected = false, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.white24,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 11.sp,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _dashboardContent() {
    return [
      // Gift card
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
                   gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFDD015),
                Color(0xFFFDB815),
                Color(0xFFFDD015),
                Color(0xFFFDA015),
              ],
              stops: [0.0, 0.3, 0.7, 1.0],
            ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
             Image.asset('assets/icons/home_screen/gift.png',height: 38.h,width: 38.w,),
            const SizedBox(height: 10),
             Text(
              'Give the gift of Calm',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(30),
              ),
              child:  Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 18),
      // Quote card
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF010649),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children:  [
            Image.asset('assets/icons/home_screen/prize.png',height: 28.h,width: 28.w,),
            SizedBox(height: 10),
            Text(
              'I concentrate on whats right below my feet as I take this step, not whats a mile down the highway',
              style: TextStyle(color: Colors.white, fontSize: 11.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'LEBRON JAMES',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.sp),
            ),
          ],
        ),
      ),
      const SizedBox(height: 18),
      // Unlock Calm Premium
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            Image.asset('assets/icons/home_screen/lock.png',height: 26,width: 26,),
            SizedBox(width: 8),
            Center(
              child: Text(
                'Unlock Calm Premium',
                style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14.sp),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 28),
      // My stats
       Text(
        'My stats',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.sp),
      ),
       SizedBox(height: 12.h),
      Container(
        padding: const EdgeInsets.all(20),
         decoration: BoxDecoration(
          color: const Color(0xFF010649),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            const Text('0', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 32)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                _StatItem(image: 'assets/icons/home_screen/glasses.png', label: 'Total Sessions', value: '0'),
                _StatItem(image: 'assets/icons/home_screen/clock.png', label: 'Longest Streak', value: '0 days'),
                _StatItem(image: 'assets/icons/home_screen/share.png', label: 'Mindful Minutes', value: '0'),
              ],
            ),
            const SizedBox(height: 10),
             Text(
              'begin meditating to see your stats',
              style: TextStyle(color: Colors.white70, fontSize: 13.sp),
            ),
             SizedBox(height: 14.h),
            Container(
              width: 260.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child:  Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon(Icons.upload, color: Colors.black54),
                      Image.asset('assets/icons/home_screen/share_arrow.png',height: 26.h,width: 26.w,),
                      SizedBox(width: 8),
                      Text(
                        'Share My Stats',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
       SizedBox(height: 28.h),
      // My streaks
      const Text(
        'My streaks',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
      ),
      const SizedBox(height: 12),
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF010649),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                _StatItem(image: 'assets/icons/home_screen/glasses.png', label: 'Total Sessions', value: '0'),
                _StatItem(image: 'assets/icons/home_screen/clock.png', label: 'Longest Streak', value: '0 days'),
                _StatItem(image: 'assets/icons/home_screen/share.png', label: 'Mindful Minutes', value: '0'),
              ],
            ),
             SizedBox(height: 10.h),
            _CalendarWidget(),
             SizedBox(height: 14.w),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child:  Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                                            Image.asset('assets/icons/home_screen/share_arrow.png',height: 26.h,width: 26.w,),

                      SizedBox(width: 8.w),
                      Text(
                        'Share My Streaks',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _historyContent() {
    return [
      // My Calendar
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:  [
          Text('My Calendar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.sp)),
          GestureDetector(
            onTap: () {
              HapticFeedbackHelper.lightImpact();
              // Show quick add dialog
              _showQuickAddDialog();
            },
            child: Text('+ Add Session', style: TextStyle(color: Colors.white54, fontSize: 15.sp)),
          ),
        ],
      ),
       SizedBox(height: 14.h),
      InteractiveCalendarWidget(
        onDateSelected: (date) {
          // Handle date selection
        },
        onEventCreated: (event) {
          // Handle event creation
          setState(() {});
        },
        showNavigation: true,
        showStreaks: true,
        showProgress: true,
      ),
       SizedBox(height: 32.sp),
       Text('My History', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.sp)),
       SizedBox(height: 8.h),
       Text(
        'Your history will show her after your first session',
        style: TextStyle(color: Colors.white54, fontSize: 15.sp),
      ),
    ];
  }

  List<Widget> _checkInsContent() {
    return [
       SizedBox(height: 12.h),
      _checkInTile(Icons.edit, 'Quick Journal', () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => CheckInDetailScreen(title: 'Quick Journal')));
      }),
       Divider(color: Colors.white24, indent: 40, endIndent: 0, height: 0),
      _checkInTile(Icons.wb_sunny_outlined, 'Daily medit Reflection', () {
        Navigator.push(context, MaterialPageRoute(builder: (_) =>  GratitudeCheckInFlow()));
      }),
       Divider(color: Colors.white24, indent: 40, endIndent: 0, height: 0),
      _checkInTile(Icons.auto_awesome, 'Gratitude Check-In', () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => GratitudeCheckInFlow()));
      }),
       Divider(color: Colors.white24, indent: 40, endIndent: 0, height: 0),
      _checkInTile(Icons.emoji_emotions, 'Mood Check-In', () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const GratitudeCheckInFlow()));
      }),
       Divider(color: Colors.white24, indent: 40, endIndent: 0, height: 0),
      _checkInTile(Icons.nightlight_round, 'Sleep Check-In', () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => SleepCheckInFlow()));
      }),
    ];
  }

  Widget _checkInTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 28.sp),
      title: Text(
        title,
        style:  TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 19.sp),
      ),
      trailing:  Icon(Icons.chevron_right, color: Colors.white, size: 28.sp),
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
      onTap: onTap,
    );
  }

  void _showQuickAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1B4B6F),
        title: Text(
          'Quick Add Session',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Quick add session functionality coming soon!',
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

class _StatItem extends StatelessWidget {
  final String image;
  final String label;
  final String value;
  const _StatItem({required this.image, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Icon(icon, color: Colors.white, size: 22),
        Image.asset(image,height: 24.h,width: 24.w,),
         SizedBox(height: 4.h),
        Text(
          value,
          style:  TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.sp),
        ),
         SizedBox(height: 2.h),
        Text(
          label,
          style:  TextStyle(color: Colors.white70, fontSize: 11.sp),
        ),
      ],
    );
  }
}

class _CalendarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Dummy calendar for May 2025
    return Column(
      children: [
         SizedBox(height: 8.h),
         Text(
          'May 2025',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.sp),
        ),
         SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:  [
            Text('Sun', style: TextStyle(color: Colors.white70, fontSize: 12.sp)),
            Text('Mon', style: TextStyle(color: Colors.white70, fontSize: 12.sp)),
            Text('Tue', style: TextStyle(color: Colors.white70, fontSize: 12.sp)),
            Text('Wed', style: TextStyle(color: Colors.white70, fontSize: 12.sp)),
            Text('Thu', style: TextStyle(color: Colors.white70, fontSize: 12.sp)),
            Text('Fri', style: TextStyle(color: Colors.white70, fontSize: 12.sp)),
            Text('Sat', style: TextStyle(color: Colors.white70, fontSize: 12.sp)),
          ],
        ),
         SizedBox(height: 4.h),
        // Calendar days (dummy, not interactive)
        Column(
          children: List.generate(5, (week) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (day) {
                  int dayNum = week * 7 + day + 1;
                  if (dayNum > 31) return  SizedBox(width: 20.w);
                  bool isToday = dayNum == 18;
                  return Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isToday ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$dayNum',
                      style: TextStyle(
                        color: isToday ? const Color(0xFF1B4B6F) : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                    ),
                  );
                }),
              ),
            );
          }),
        ),
      ],
    );
  }
} 