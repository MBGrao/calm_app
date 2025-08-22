import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'lib/app/modules/home/views/simple_ai_assistant_screen.dart';

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
          title: 'AI Navigation Test',
          home: Scaffold(
            appBar: AppBar(
              title: const Text('AI Navigation Test'),
              backgroundColor: Colors.blue,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Testing AI Assistant Navigation',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      print('🎯 Test: Opening Simple AI Assistant Screen');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) {
                            print('🎯 Test: Building Simple AI Assistant Screen');
                            return const SimpleAIAssistantScreen();
                          },
                        ),
                      );
                    },
                    child: const Text('Open AI Assistant'),
                  ),
                  const SizedBox(height: 20),
                  const Text(
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