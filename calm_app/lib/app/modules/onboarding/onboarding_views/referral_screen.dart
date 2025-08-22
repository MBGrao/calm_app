import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'ai_logo_screen.dart';

class ReferralScreen extends StatefulWidget {
  const ReferralScreen({Key? key}) : super(key: key);

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  int? selectedOption;
  final List<String> options = [
    'App Store or Google',
    'Therapist or health professional',
    'YouTube Influencer',
    'Friend or family',
    'Social media or online Ad',
    'Article or blog',
    'SiriusXM or radio',
    'My employer',
    'Podcast ad',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
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
          padding:  EdgeInsets.symmetric(horizontal: 26.0, vertical: 40.dm),
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
                   padding: EdgeInsets.all(4.w),
                   child: Image.asset(
                     'assets/icons/onboarding_icons/cross.png',
                     height: 26.h,
                     width: 26.w,
                   ),
                 ),
               ),
               SizedBox(height: 60.h),
               Text(
                 'How did you hear about MeditAi',
                 style: TextStyle(
                   color: Colors.white,
                   fontSize: 18.sp,
                   fontWeight: FontWeight.bold,
                 ),
               ),
              //  SizedBox(height: 32.h),
               Expanded(
                 child: ListView.builder(
                   itemCount: options.length,
                   itemBuilder: (context, index) {
                     return Padding(
                       padding: EdgeInsets.symmetric(vertical: 8.h),
                       child: Row(
                         crossAxisAlignment: CrossAxisAlignment.center,
                         children: [
                           CustomRadio(
                             selected: selectedOption == index,
                             onTap: () {
                               setState(() {
                                 selectedOption = index;
                               });
                               Future.delayed(const Duration(seconds: 1), () {
                                 Get.off(() => const AiLogoScreen());
                               });
                             },
                           ),
                           SizedBox(width: 12.w),
                           Expanded(
                             child: Text(
                               options[index],
                               style: TextStyle(
                                 color: Colors.white,
                                 fontSize: 15.sp,
                                 fontWeight: FontWeight.w500,
                               ),
                             ),
                           ),
                         ],
                       ),
                     );
                   },
                 ),
               ),
             ],
          ),
        ),
      ),
    );
  }
}

class CustomRadio extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;

  const CustomRadio({required this.selected, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24.w,
        height: 24.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
        ),
        child: selected
            ? Center(
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            : null,
      ),
    );
  }
} 