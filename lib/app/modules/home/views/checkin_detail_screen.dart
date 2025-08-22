import 'package:flutter/material.dart';

class CheckInDetailScreen extends StatelessWidget {
  final String title;
  const CheckInDetailScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B4B6F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B4B6F),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Center(
        child: Text(
          '$title Details',
          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
} 