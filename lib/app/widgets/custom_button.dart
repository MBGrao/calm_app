import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? height;
  final double? borderRadius;
  final bool isLoading;
  final bool isOutlined;

  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.height,
    this.borderRadius,
    this.isLoading = false,
    this.isOutlined = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SizedBox(
      height: height ?? 48.h,
      child: isOutlined
          ? OutlinedButton.icon(
              onPressed: isLoading ? null : onPressed,
              icon: _buildIcon(),
              label: _buildText(theme),
              style: OutlinedButton.styleFrom(
                foregroundColor: textColor ?? Colors.white,
                side: BorderSide(
                  color: borderColor ?? Colors.white,
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 8),
                ),
              ),
            )
          : ElevatedButton.icon(
              onPressed: isLoading ? null : onPressed,
              icon: _buildIcon(),
              label: _buildText(theme),
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor ?? theme.primaryColor,
                foregroundColor: textColor ?? Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius ?? 8),
                ),
              ),
            ),
    );
  }

  Widget _buildIcon() {
    if (isLoading) {
      return SizedBox(
        width: 16.w,
        height: 16.w,
        child: const CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }
    
    if (icon != null) {
      return Icon(icon, size: 20.sp);
    }
    
    return const SizedBox.shrink();
  }

  Widget _buildText(ThemeData theme) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: textColor ?? Colors.white,
      ),
    );
  }
} 