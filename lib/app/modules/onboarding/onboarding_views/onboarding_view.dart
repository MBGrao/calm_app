import 'package:calm_app/app/modules/onboarding/onboarding_views/feature_plan_screen.dart';
import 'package:calm_app/app/modules/onboarding/onboarding_views/referral_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';
import 'welcome_screen.dart';
import 'goal_selection_screen.dart';
import 'signup_screen.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());
    return Obx(() {
      switch (controller.currentStep.value) {
        case 0:
          return const WelcomeScreen();
        case 1:
          return const GoalSelectionScreen();
        case 2:
          return const SignupScreen();
        case 3:
          return const FeaturePlanScreen();
        case 4:
          return const ReferralScreen();
        default:
          return const WelcomeScreen();
      }
    });
  }
} 