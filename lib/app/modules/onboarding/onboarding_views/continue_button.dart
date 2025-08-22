import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContinueButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool enabled;

  const ContinueButton({
    Key? key,
    required this.onPressed,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              return Colors.white; // Always white
            },
          ),
          foregroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              return Colors.black; // Always black text
            },
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
          ),
          elevation: WidgetStateProperty.all<double>(0),
          textStyle: WidgetStateProperty.all<TextStyle>(
             TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 19.sp,
            ),
          ),
        ),
        onPressed: enabled ? onPressed : null,
        child: const Text('Continue'),
      ),
    );
  }
}
