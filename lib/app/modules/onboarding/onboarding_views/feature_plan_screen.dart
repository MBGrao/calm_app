import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'referral_screen.dart';

class FeaturePlanScreen extends StatefulWidget {
  const FeaturePlanScreen({Key? key}) : super(key: key);

  @override
  State<FeaturePlanScreen> createState() => _FeaturePlanScreenState();
}

class _FeaturePlanScreenState extends State<FeaturePlanScreen> {
  int selectedPlan = 0; // 0 = yearly, 1 = monthly

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1B517E),
              Color(0xFF0D3550),
              Color(0xFF32366F),
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.black54,
                        ),
                        padding: const EdgeInsets.all(4),
                        child: Image.asset(
                          'assets/icons/onboarding_icons/cross.png',
                          height: 26.h,
                          width: 26.w,
                        ),
                      ),
                    ),
                     SizedBox(height: 38.h),
                     Text(
                      'Your plan is ready',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18.sp,
                        // fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                     Text(
                      'Unlock MeditAi for free',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                     SizedBox(height: 16.h),
                    _FeatureItem(
                      image: 'assets/icons/onboarding_icons/infinity.png',
                      text: 'Unlimited free access for 7 days',
                    ),
                    const Divider(color: Colors.white24, height: 32),
                    _FeatureItem(
                      image: 'assets/icons/onboarding_icons/headset.png',
                      text:
                          '50000+ minutes of audio designed\nto relieve anxiety, stress, and more',
                    ),
                    const Divider(color: Colors.white24, height: 32),
                    _FeatureItem(
                      image: 'assets/icons/onboarding_icons/music.png',
                      text: 'Exclusive music for sleep and relaxation',
                    ),
                    const Divider(color: Colors.white24, height: 32),
                    _FeatureItem(
                      image: 'assets/icons/onboarding_icons/pink_moon.png',
                      text: 'Soothing Sleep Stories narrated by familiar voices',
                    ),
                    const Divider(color: Colors.white24, height: 32),
                    _FeatureItem(
                      image: 'assets/icons/onboarding_icons/cloud.png',
                      text: 'Access to latest content first',
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              top: false,
              bottom: false,
              child: Container(
                height: 300.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xff000104),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 16,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PlanSelector(
                      selectedPlan: selectedPlan,
                      onChanged: (val) {
                        setState(() {
                          selectedPlan = val;
                        });
                      },
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          Get.off(() => const ReferralScreen());
                        },
                        child:  Text('Try Free & Subscribe',style: TextStyle(fontSize: 14.sp),),
                      ),
                    ),
                    const SizedBox(height: 14),
                     Text(
                      'Totally free for 7 days, then Rs 675/month, billed annually at Rs 8,100/yr Cancel anytime.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
         
          ],
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String image;
  final String text;
  // final Color iconColor;
  const _FeatureItem({
    required this.image,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon(icon, color: iconColor, size: 28),
        Image.asset(image, height: 28.h, width: 28.w),
         SizedBox(width: 16.w),
        Expanded(
          child: Text(
            text,
            style:  TextStyle(color: Colors.white, fontSize: 13 .sp),
          ),
        ),
      ],
    );
  }
}

class PlanSelector extends StatelessWidget {
  final int selectedPlan;
  final ValueChanged<int> onChanged;
  const PlanSelector({required this.selectedPlan, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            GestureDetector(
              onTap: () => onChanged(0),
              child: Container(

                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color:
                      selectedPlan == 0 ? Colors.white10 : Colors.transparent,
                  border: Border.all(
                    color: selectedPlan == 0 ? Colors.yellow : Colors.white54,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  [
                          Text('Yearly',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('Rs 25,500  Rs 8,100/yr.mo.',
                              style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 13.sp,
                                  decoration: TextDecoration.lineThrough)),
                        ],
                      ),
                    ),
                     Text('Rs 675/mo',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.yellow[700],
                  borderRadius: BorderRadius.circular(8),
                ),
                child:  Text('7-Day Free Trial',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () => onChanged(1),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            decoration: BoxDecoration(
              color: selectedPlan == 1 ? Colors.white10 : Colors.transparent,
              border: Border.all(
                color: selectedPlan == 1 ? Colors.yellow : Colors.white54,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children:  [
                Expanded(
                  child: Text('Monthly',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold)),
                ),
                Text('Rs 2,100/mo',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
