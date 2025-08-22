import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:developer' as developer;

class SimpleAIAssistantScreen extends StatefulWidget {
  const SimpleAIAssistantScreen({Key? key}) : super(key: key);

  @override
  State<SimpleAIAssistantScreen> createState() => _SimpleAIAssistantScreenState();
}

class _SimpleAIAssistantScreenState extends State<SimpleAIAssistantScreen> {
  @override
  void initState() {
    super.initState();
    developer.log('🎯 Simple AI Assistant Screen - initState called', name: 'SimpleAIAssistantScreen');
  }

  @override
  Widget build(BuildContext context) {
    developer.log('🎯 Simple AI Assistant Screen - build called', name: 'SimpleAIAssistantScreen');
    return Scaffold(
      backgroundColor: const Color(0xFF1B4B6F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            developer.log('🎯 Simple AI Assistant Screen - Back button pressed', name: 'SimpleAIAssistantScreen');
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          'Simple AI Assistant',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.psychology,
              color: Colors.white,
              size: 80.sp,
            ),
            SizedBox(height: 24.h),
            Text(
              'Simple AI Assistant Screen',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'This is a simplified version for testing',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 32.h),
            ElevatedButton(
              onPressed: () {
                developer.log('🎯 Simple AI Assistant Screen - Test button pressed', name: 'SimpleAIAssistantScreen');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Test button works!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text('Test Button'),
            ),
          ],
        ),
      ),
    );
  }
} 