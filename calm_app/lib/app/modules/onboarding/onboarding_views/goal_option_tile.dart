import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GoalOptionTile extends StatelessWidget {
  final String iconPath;
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const GoalOptionTile({
    Key? key,
    required this.iconPath,
    required this.text,
    required this.selected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: selected ? Colors.white.withOpacity(0.08) : Colors.transparent,
          border: Border.all(
            color: selected ? Colors.white : Colors.white54,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Image.asset(
              iconPath,
              height: 26.h,
              width: 26.w,
            ),
             SizedBox(width: 12.w),
            Expanded(
              child: Text(
                text,
                style:  TextStyle(
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 