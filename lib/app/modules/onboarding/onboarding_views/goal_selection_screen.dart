import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';
import 'goal_option_tile.dart';
import 'continue_button.dart';

class GoalSelectionScreen extends StatefulWidget {
  const GoalSelectionScreen({Key? key}) : super(key: key);

  @override
  State<GoalSelectionScreen> createState() => _GoalSelectionScreenState();
}

class _GoalSelectionScreenState extends State<GoalSelectionScreen> {
  final List<String> goals = [
    'Build Self Esteem',
    'Increase Happiness',
    'Better Sleep',
    'Reduce Anxiety',
    'Improve Performance',
    'Develop Gratitude',
  ];
  final List<String> iconPaths = [
    'assets/icons/onboarding_icons/cricle_three.png',
    'assets/icons/onboarding_icons/smile_free.png',
    'assets/icons/onboarding_icons/moon.png',
    'assets/icons/onboarding_icons/drop.png',
    'assets/icons/onboarding_icons/walk.png',
    'assets/icons/onboarding_icons/leaf.png',
  ];
  final Set<int> selectedGoals = {};

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());
    return Scaffold(
     
      body: Container(
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 50),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.black54,
                          ),
                          padding:  EdgeInsets.all(4),
                          child: Image.asset(
                            'assets/icons/onboarding_icons/cross.png',
                            height: 26.h,
                            width: 26.w,
                          ),
                        ),
                      ),
                      // const SizedBox(height: 50),
                      Center(
                        child: Text(
                          'MeditAi',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                       SizedBox(height: 16.h),
                       Text(
                        'What brings you to MeditAi?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                       Text(
                        "We'll personalize recommendations based on your goals",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14.sp,
                        ),
                      ),
                       SizedBox(height: 40.h),
                      ...List.generate(goals.length, (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: GoalOptionTile(
                          iconPath: iconPaths[index],
                          text: goals[index],
                          selected: selectedGoals.contains(index),
                          onTap: () {
                            setState(() {
                              if (selectedGoals.contains(index)) {
                                selectedGoals.remove(index);
                              } else {
                                selectedGoals.add(index);
                              }
                            });
                          },
                        ),
                      )),
                      // const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              ContinueButton(
                onPressed: selectedGoals.isNotEmpty ? controller.nextStep : null,
                enabled: selectedGoals.isNotEmpty,
              ),
              // const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
} 