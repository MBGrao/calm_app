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
          title: 'AI Assistant Test',
          home: Scaffold(
            appBar: AppBar(
              title: Text('Test Navigation'),
              backgroundColor: Colors.blue,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Testing AI Assistant Navigation',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      print('🎯 Test: Opening AI Assistant Screen');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) {
                            print('🎯 Test: Building AI Assistant Screen');
                            return const AIAssistantScreen();
                          },
                        ),
                      );
                    },
                    child: Text('Open AI Assistant'),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'If the screen opens, navigation is working!',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
} 