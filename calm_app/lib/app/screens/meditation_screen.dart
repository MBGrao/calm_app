import 'package:flutter/material.dart';
import '../components/breathing_bubble.dart';

class MeditationScreen extends StatelessWidget {
  const MeditationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
      // backgroundColor: Colors.red,
      body: 
      Container(
        decoration: BoxDecoration(
          
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1B4B6F),
              Color(0xFF1B4B6F)

              // Colors.blue.shade700,
      // backgroundColor: const Color(0xFF1B4B6F),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BreathingBubble(
                    
                    size: 250,
                    bubbleColor: Colors.white,
                    textColor: Colors.white,
                    breathDuration: Duration(seconds: 4),
                  ),
                  SizedBox(height: 32),
                  Text(
                    'Take deep breaths',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Follow the circle as it expands and contracts',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
          
          ],
        ),
      ),
   
    );
  }
} 