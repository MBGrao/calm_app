import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'home_explore_button.dart';

class CategoryIconGrid extends StatelessWidget {
  const CategoryIconGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'Explore by Category',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        // Category Grid
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ExploreButton(
                image: 'assets/icons/home_screen/circle_white.png',
                label: 'Meditation',
                description: 'Mindful practices',
              ),
              ExploreButton(
                image: 'assets/icons/home_screen/moon.png',
                label: 'Sleep',
                description: 'Restful stories',
              ),
              ExploreButton(
                image: 'assets/icons/home_screen/music.png',
                label: 'Music',
                description: 'Soothing sounds',
              ),
            ],
          ),
        ),
      ],
    );
  }
}