import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../services/share_service.dart';
import '../../../widgets/interactive_feedback.dart';

class GratitudeCompletedScreen extends StatefulWidget {
  const GratitudeCompletedScreen({Key? key}) : super(key: key);

  @override
  State<GratitudeCompletedScreen> createState() => _GratitudeCompletedScreenState();
}

class _GratitudeCompletedScreenState extends State<GratitudeCompletedScreen> {
  // Track which images have been used
  bool _usedFallAsleepImage = false;
  bool _usedNatureImage = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF584378), // Purple at top
              Color(0xFF9E5E3B), // Orange at bottom
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App bar
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
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
                          'Gratitude Check-Ins',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 48.w), // Balance for back button
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 20.h),
                  
                  // Completed check-in card
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "You've completed your 2nd check-in",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        
                        SizedBox(height: 15.h),
                        
                        Text(
                          "MAY 17, 2025",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14.sp,
                          ),
                        ),
                        
                        SizedBox(height: 15.h),
                        
                        Text(
                          "What relationships are you thankful\nfor today",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                          ),
                        ),
                        
                        SizedBox(height: 20.h),
                        
                        // Response boxes
                        Container(
                          padding: EdgeInsets.all(15.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "friends",
                                  style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        SizedBox(height: 10.h),
                        
                        Container(
                          padding: EdgeInsets.all(15.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "family",
                                  style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        SizedBox(height: 10.h),
                        
                        Container(
                          padding: EdgeInsets.all(15.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "colleagues",
                                  style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        SizedBox(height: 15.h),
                        
                        Text(
                          "#DailyGratitude",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 20.h),
                  
                  // Share button
                  OutlinedButton(
                    onPressed: () {
                      HapticFeedbackHelper.mediumImpact();
                      ShareService.showShareDialog(
                        context: context,
                        contentType: 'gratitude',
                        title: 'Daily Gratitude Practice',
                        subtitle: 'What relationships are you thankful for today?',
                        description: 'Practicing gratitude for the meaningful relationships in my life.',
                        customMessage: 'Just completed my daily gratitude practice with Calm! 🙏 Taking time to appreciate the relationships that matter most. #DailyGratitude',
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                    ),
                    child: Text(
                      'Share',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 20.h),
                  Divider(color: Colors.white30),
                  SizedBox(height: 20.h),
                  
                  // Week calendar
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Column(
                      children: [
                        // Week header
                        Text(
                          'Week of May 11',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        
                        SizedBox(height: 15.h),
                        
                        // Day circles
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildDayCircle('S'),
                            _buildDayCircle('M'),
                            _buildDayCircle('T'),
                            _buildDayCircle('W'),
                            _buildDayCircle('T'),
                            _buildDayCircle('F'),
                            _buildDayCircle('S'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 20.h),
                  
                  // View History button
                  OutlinedButton(
                    onPressed: () {
                      HapticFeedbackHelper.lightImpact();
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                    ),
                    child: Text(
                      'View History',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 20.h),
                  Divider(color: Colors.white30),
                  SizedBox(height: 20.h),
                  
                  // Recommendations section
                  Text(
                    'Recommended for Feeling Grateful',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  SizedBox(height: 20.h),
                  
                  // Recommendation grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 10.h,
                    crossAxisSpacing: 10.w,
                    childAspectRatio: 1.5,
                    children: [
                      _buildRecommendationCard('Fall Asleep'),
                      _buildRecommendationCard('Nature'),
                      _buildRecommendationCard('Fall Asleep'),
                      _buildRecommendationCard('Nature'),
                    ],
                  ),
                  
                  SizedBox(height: 20.h),
                  Divider(color: Colors.white30),
                  SizedBox(height: 20.h),
                  
                  // Daily reminder section
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.notifications_outlined,
                        color: Colors.white,
                        size: 30.sp,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 15.h),
                  
                  Text(
                    'Set a Daily Reminder',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  SizedBox(height: 10.h),
                  
                  Text(
                    'Make gratitude a daily habit to feel\nthe benefits of this practice',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14.sp,
                    ),
                  ),
                  
                  SizedBox(height: 20.h),
                  
                  // Time buttons
                  OutlinedButton(
                    onPressed: () {
                      HapticFeedbackHelper.lightImpact();
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                    ),
                    child: Text(
                      'Morning',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 10.h),
                  
                  OutlinedButton(
                    onPressed: () {
                      HapticFeedbackHelper.lightImpact();
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                    ),
                    child: Text(
                      'Afternoon',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 10.h),
                  
                  OutlinedButton(
                    onPressed: () {
                      HapticFeedbackHelper.lightImpact();
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                    ),
                    child: Text(
                      'Night',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildDayCircle(String day) {
    return Column(
      children: [
        Container(
          width: 30.w,
          height: 30.h,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          day,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
  
  Widget _buildRecommendationCard(String title) {
    String imageUrl;
    
    // Select appropriate image URL based on the card title
    if (title == 'Fall Asleep') {
      // For the first Fall Asleep card (collage of images)
      if (title == 'Fall Asleep' && !_usedFallAsleepImage) {
        _usedFallAsleepImage = true;
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildNetworkImage('https://images.unsplash.com/photo-1505765050516-f72dcac9c60e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=200&q=80'),
                          ),
                          Expanded(
                            child: _buildNetworkImage('https://images.unsplash.com/photo-1470252649378-9c29740c9fa8?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=200&q=80'),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: _buildNetworkImage('https://images.unsplash.com/photo-1500479694472-551d1fb6258d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=400&q=80', width: double.infinity),
                    ),
                  ],
                ),
              ),
            ),
            _buildCardOverlay(title),
          ],
        );
      } else {
        // For the second Fall Asleep card (meditation woman)
        imageUrl = 'https://images.unsplash.com/photo-1545389336-cf090694435e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=400&q=80';
      }
    } else {
      // For Nature cards
      if (title == 'Nature' && !_usedNatureImage) {
        _usedNatureImage = true;
        imageUrl = 'https://images.unsplash.com/photo-1587502537104-aac10f5fb6f7?ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=400&q=80';
      } else {
        // For the second Nature card (meditation at sunset)
        imageUrl = 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=400&q=80';
      }
    }
    
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: _buildNetworkImage(imageUrl, width: double.infinity, height: double.infinity),
          ),
        ),
        _buildCardOverlay(title),
      ],
    );
  }
  
  Widget _buildNetworkImage(String url, {double? width, double? height}) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: width,
      height: height,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: width,
          height: height,
          color: Colors.black26,
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                  : null,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          color: Colors.black38,
          child: const Center(
            child: Icon(Icons.error_outline, color: Colors.white),
          ),
        );
      },
    );
  }
  
  Widget _buildCardOverlay(String title) {
    return Stack(
      children: [
        Positioned(
          bottom: 10.h,
          left: 10.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 10.h,
          right: 10.w,
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.file_download_outlined,
              color: Colors.white,
              size: 18.sp,
            ),
          ),
        ),
      ],
    );
  }
} 