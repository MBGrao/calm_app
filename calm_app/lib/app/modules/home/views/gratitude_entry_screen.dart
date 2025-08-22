import 'package:flutter/material.dart';
import 'gratitude_completed_screen.dart';

class GratitudeEntryScreen extends StatelessWidget {
  const GratitudeEntryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1B29),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1B29),
        elevation: 0,
        leading: IconButton(
          icon: const Text('X', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Navigate to completed screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GratitudeCompletedScreen(),
                ),
              );
            },
            child: const Text(
              'Done',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Prompt
            const Center(
              child: Text(
                'What made you smile or',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Center(
              child: Text(
                'laugh today?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            const SizedBox(height: 10),
            
            // Dots
            const Text(
              '...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 10),
            
            // Change prompt button
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.shuffle, color: Colors.grey),
              label: const Text(
                'Change prompt',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            
            const SizedBox(height: 60),
            
            // Input fields
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildNumberedInputField(1),
                  const SizedBox(height: 20),
                  _buildNumberedInputField(2),
                  const SizedBox(height: 20),
                  _buildNumberedInputField(3),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildNumberedInputField(int number) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$number.',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                height: 1,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }
} 