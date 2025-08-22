import 'package:flutter/material.dart';
import 'lib/app/modules/home/views/simple_ai_assistant_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple AI Assistant Test',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Direct Test'),
          backgroundColor: Colors.blue,
        ),
        body: const SimpleAIAssistantScreen(),
      ),
    );
  }
} 