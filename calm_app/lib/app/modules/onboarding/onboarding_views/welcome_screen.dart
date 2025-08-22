import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();
    Future.delayed(const Duration(seconds: 2), controller.nextStep);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/welcome.png',
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.2),
          ),
          Positioned(
            top: 150,
            left: 45,
            child: Text(
              'Welcome!',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 