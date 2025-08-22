import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../services/share_service.dart';
import '../../../widgets/interactive_feedback.dart';

class ReflectionCheckInFlow extends StatefulWidget {
  const ReflectionCheckInFlow({Key? key}) : super(key: key);

  @override
  State<ReflectionCheckInFlow> createState() => _ReflectionCheckInFlowState();
}

class _ReflectionCheckInFlowState extends State<ReflectionCheckInFlow> {
  int selectedDay = 6; // Saturday selected by default

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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      'Daily Calm Reflections',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ReflectionEntryScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              // Week view
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 12.w),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.chevron_left, color: Colors.white),
                            Text(
                              'Week of May 11',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(Icons.chevron_right, color: Colors.white),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(7, (i) => _buildDayCircle(i)),
                        ),
                        SizedBox(height: 4.h),
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
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              // Reflection card
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(18.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Today, 8:45 PM',
                          style: TextStyle(color: Colors.white70, fontSize: 13.sp),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          'How helpful or unhelpful are the common themes to your thoughts?',
                          style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          '1.',
                          style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold),
                        ),
                      ],
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

  Widget _buildDayCircle(int i) {
    final isSelected = selectedDay == i;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDay = i;
        });
      },
      child: Container(
        width: 32.w,
        height: 32.h,
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.black.withOpacity(0.3),
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
        ),
        child: isSelected
            ? const Icon(Icons.check, color: Colors.white)
            : null,
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
      width: 32.w,
      child: Center(
        child: Text(
          label,
          style: TextStyle(color: Colors.white70, fontSize: 13.sp, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class ReflectionEntryScreen extends StatelessWidget {
  const ReflectionEntryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image from the internet
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1464983953574-0892a716854b?auto=format&fit=crop&w=800&q=80'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Semi-transparent overlay for the top area
          Container(
            height: 220.h,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.32),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40.r),
                bottomRight: Radius.circular(40.r),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.close, color: Colors.white, size: 28.sp),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const ReflectionSummaryScreen()),
                          );
                        },
                        child: Text('Done', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.sp)),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.h),
                // Question overlay
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Text(
                    'How helpful or unhelpful are the common themes to your thoughts?',
                    style: TextStyle(color: Colors.white, fontSize: 22.sp, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 60.h),
                // Reflection input area
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.w),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 0.w),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(0, 0, 0, 0.22),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32.r),
                        topRight: Radius.circular(32.r),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 24.w),
                      child: Text(
                        'Add a reflection ...',
                        style: TextStyle(color: Colors.white54, fontSize: 18.sp),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReflectionSummaryScreen extends StatefulWidget {
  const ReflectionSummaryScreen({Key? key}) : super(key: key);

  @override
  State<ReflectionSummaryScreen> createState() => _ReflectionSummaryScreenState();
}

class _ReflectionSummaryScreenState extends State<ReflectionSummaryScreen> {
  int selectedDay = 6;

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
              Color(0xFFB6C94B),
              Color(0xFFFFD600),
            ],
            stops: [0, 0.4, 0.7, 1],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Top card with image, title, subtitle
                  _imageCard(
                    imageUrl: 'https://images.unsplash.com/photo-1464983953574-0892a716854b?auto=format&fit=crop&w=800&q=80',
                    title: 'Nature',
                    subtitle: 'Nature, Tamara Levit\nMay 17, Bubbles',
                  ),
                  SizedBox(height: 16.h),
                  // Reflection card
                  _reflectionCard(),
                  SizedBox(height: 10.h),
                  _shareButton(),
                  SizedBox(height: 18.h),
                  Divider(color: Colors.white.withOpacity(0.2)),
                  SizedBox(height: 10.h),
                  // Week view
                  _weekView(),
                  SizedBox(height: 10.h),
                  _viewHistoryButton(),
                  SizedBox(height: 18.h),
                  // Reminder section
                  _reminderSection(),
                  SizedBox(height: 18.h),
                  Divider(color: Colors.white.withOpacity(0.2)),
                  SizedBox(height: 10.h),
                  // Bottom card with quote
                  _imageCard(
                    imageUrl: 'https://images.unsplash.com/photo-1464983953574-0892a716854b?auto=format&fit=crop&w=800&q=80',
                    title: 'Your thoughts are bubbles\nwaiting to be popped',
                    subtitle: '',
                    isQuote: true,
                  ),
                  SizedBox(height: 10.h),
                  _shareButton(filled: true),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageCard({required String imageUrl, required String title, required String subtitle, bool isQuote = false}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: Stack(
        children: [
          Image.network(
            imageUrl,
            height: 160.h,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          if (!isQuote)
            Positioned(
              left: 12.w,
              bottom: 12.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.sp)),
                  SizedBox(height: 2.h),
                  Text(subtitle, style: TextStyle(color: Colors.white70, fontSize: 12.sp)),
                ],
              ),
            ),
          if (isQuote)
            Positioned(
              left: 0,
              right: 0,
              bottom: 30.h,
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cursive',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _reflectionCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
        color: Colors.white.withOpacity(0.92),
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 18.w),
          child: Column(
            children: [
              Text(
                'How helpful or unhelpful are the common themes to your thoughts?',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16.sp),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              Text(
                'hello',
                style: TextStyle(color: Colors.black87, fontSize: 15.sp),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _shareButton({bool filled = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: filled ? Colors.white : Colors.transparent,
            side: BorderSide(color: Colors.white, width: 2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
            padding: EdgeInsets.symmetric(vertical: 12.h),
          ),
          onPressed: () {
            HapticFeedbackHelper.mediumImpact();
            ShareService.showShareDialog(
              context: context,
              contentType: 'reflection',
              title: 'Daily Reflection',
              subtitle: 'How helpful or unhelpful are the common themes to your thoughts?',
              description: 'A moment of self-reflection and mindfulness practice.',
              customMessage: 'Just completed my daily reflection practice with Calm! 📝✨ Taking time to understand my thoughts and emotions.',
            );
          },
          child: Text(
            'Share',
            style: TextStyle(
              color: filled ? const Color(0xFF1B4B6F) : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
        ),
      ),
    );
  }

  Widget _weekView() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.18),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        child: Column(
          children: [
            Text(
              'Week of May 11',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.sp),
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(7, (i) => _buildDayCircle(i)),
            ),
            SizedBox(height: 4.h),
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
          ],
        ),
      ),
    );
  }

  Widget _buildDayCircle(int i) {
    final isSelected = selectedDay == i;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDay = i;
        });
      },
      child: Container(
        width: 28.w,
        height: 28.h,
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.black.withOpacity(0.3),
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
        ),
        child: isSelected
            ? Icon(Icons.check, color: Colors.white, size: 18.sp)
            : null,
      ),
    );
  }

  Widget _viewHistoryButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.white, width: 2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
            padding: EdgeInsets.symmetric(vertical: 12.h),
          ),
          onPressed: () {
            HapticFeedbackHelper.lightImpact();
          },
          child: Text(
            'View History',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.sp),
          ),
        ),
      ),
    );
  }

  Widget _reminderSection() {
    return Column(
      children: [
        Icon(Icons.notifications, color: Colors.white70, size: 32.sp),
        SizedBox(height: 8.h),
        Text(
          'Set a Daily Reminder',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.sp),
        ),
        SizedBox(height: 6.h),
        Text(
          'Make gratitude a daily habit to fell\nthe benefits of this practice',
          style: TextStyle(color: Colors.white70, fontSize: 13.sp),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10.h),
        _reminderButton('Morning'),
        SizedBox(height: 8.h),
        _reminderButton('Afternoon'),
        SizedBox(height: 8.h),
        _reminderButton('Night'),
      ],
    );
  }

  Widget _reminderButton(String label) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.white, width: 2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
            padding: EdgeInsets.symmetric(vertical: 10.h),
          ),
          onPressed: () {
            HapticFeedbackHelper.lightImpact();
          },
          child: Text(
            label,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.sp),
          ),
        ),
      ),
    );
  }
} 