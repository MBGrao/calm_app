import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TagChip extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isSelected;

  const TagChip({
    Key? key,
    required this.label,
    this.onTap,
    this.backgroundColor,
    this.textColor,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: backgroundColor ?? 
                 (isSelected ? Colors.blue : Colors.white.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(20),
          border: isSelected 
              ? Border.all(color: Colors.blue, width: 1.5)
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: textColor ?? 
                   (isSelected ? Colors.white : Colors.white70),
            fontSize: 12.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
} 