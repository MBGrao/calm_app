
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PremiumCardBox extends StatelessWidget {
  final VoidCallback? onTap;
  
  const PremiumCardBox({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14.r),
      ),
      padding:
          EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: Star + Text
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFCB7915),
                      Color(0xFFFFE26A),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.all(6.r),
                child: const Icon(Icons.star,
                    color: Colors.white, size: 22),
              ),
              SizedBox(width: 14.w),
              InkWell(
                onTap: onTap,
                child: Text(
                  'Unlock everything with\nCalm Premium',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
    
          // Right side: Arrow icon
          Icon(Icons.arrow_forward_ios,
              color: Colors.white30, size: 16.sp),
        ],
      ),
    ),
                  );
  }
} 