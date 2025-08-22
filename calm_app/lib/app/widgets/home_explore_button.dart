import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../modules/home/views/category_screen.dart';
import '../widgets/interactive_feedback.dart';

class ExploreButton extends StatelessWidget {
  final String image;
  final String label;
  final String? description;
  const ExploreButton({
    required this.image, 
    required this.label, 
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedbackHelper.lightImpact();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CategoryScreen(
              category: label,
              isSelected: false,
            ),
          ),
        );
      },
      child: Container(
        width: 100.w,
        height: description != null ? 90.h : 70.h,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Image.asset(image, height: 24.h, width: 24.w),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                color: Colors.white, 
                fontSize: 12.sp, 
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            if (description != null) ...[
              SizedBox(height: 2.h),
              Text(
                description!,
                style: TextStyle(
                  color: Colors.white70, 
                  fontSize: 10.sp,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

