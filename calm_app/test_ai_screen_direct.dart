import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'lib/app/modules/home/views/ai_assistant_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'AI Assistant Direct Test',
          home: Scaffold(
            appBar: AppBar(
              title: Text('Direct AI Assistant Test'),
              backgroundColor: Colors.blue,
            ),
            body: const AIAssistantScreen(),
          ),
        );
      },
    );
  }
} 