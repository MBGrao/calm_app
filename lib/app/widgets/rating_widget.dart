import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RatingWidget extends StatelessWidget {
  final double rating;
  final double size;
  final Color? color;
  final bool showText;

  const RatingWidget({
    Key? key,
    required this.rating,
    this.size = 16.0,
    this.color,
    this.showText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) {
          final starValue = index + 1;
          final isFilled = starValue <= rating;
          final isHalfFilled = starValue - 0.5 <= rating && starValue > rating;
          
          return Icon(
            isFilled
                ? Icons.star
                : isHalfFilled
                    ? Icons.star_half
                    : Icons.star_border,
            size: size.sp,
            color: color ?? Colors.amber,
          );
        }),
        if (showText) ...[
          SizedBox(width: 4.w),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: (size * 0.75).sp,
              fontWeight: FontWeight.w500,
              color: color ?? Colors.amber,
            ),
          ),
        ],
      ],
    );
  }
} 