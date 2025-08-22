import 'package:calm_app/app/widgets/custom_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/controllers/auth_controller.dart';

class AiLogoScreen extends StatefulWidget {
  const AiLogoScreen({Key? key}) : super(key: key);

  @override
  State<AiLogoScreen> createState() => _AiLogoScreenState();
}

class _AiLogoScreenState extends State<AiLogoScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () async {
      // Mark onboarding as completed
      final authController = Get.find<AuthController>();
      await authController.markOnboardingCompleted();
      
      // Navigate to main app
      Get.offAll(() =>  ShoesBottomNavigationBar());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
       decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1B517E), // 1st color
              Color(0xFF0D3550), // 2nd color
              Color(0xFF32366F), // 3rd color
            ],
          ),
        ),
        child: Center(
          child: Container(
            width: 220,
            height: 220,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(
                'assets/icons/onboarding_icons/ai_logo.png',
                width: 160,
                height: 160,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
