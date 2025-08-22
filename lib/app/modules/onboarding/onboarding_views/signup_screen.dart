import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/views/auth_view.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(OnboardingController());
    final authController = Get.find<AuthController>();
    
    return Scaffold(
      backgroundColor: const Color(0xFF1A3A6B),
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
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Back button
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => Get.back(),
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
                ),
                
                SizedBox(height: 16.h),
                
                // App title
                Text(
                  'MeditAi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                SizedBox(height: 90.h),
                
                // Description
                Text(
                  'Create an account to save your progress',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                
                SizedBox(height: 32.h),
                
                // Error message
                Obx(() => authController.authError.value.isNotEmpty
                    ? Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.withOpacity(0.5)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline, color: Colors.red, size: 20.sp),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                authController.authError.value,
                                style: TextStyle(
                                  color: Colors.red[100],
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => authController.setAuthError(''),
                              child: Icon(Icons.close, color: Colors.red[100], size: 20.sp),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink()),
                
                // Social login buttons
                _SocialLoginButton(
                  image: 'assets/icons/onboarding_icons/email.png',
                  text: 'Continue with Email',
                  isLoading: authController.isLoading,
                  onTap: () {
                    Get.to(() => const AuthView());
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Terms and Privacy
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'By tapping Continue or logging into an existing MeditAi account, you agree to our ',
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      TextSpan(
                        text: 'Terms',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                          decorationThickness: 2,
                        ),
                      ),
                      TextSpan(
                        text: ' and acknowledge that you have read our ',
                        style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w600),
                      ),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                          decorationThickness: 2,
                        ),
                      ),
                      TextSpan(
                        text: ', which explains how to opt out of offers and promos',
                        style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: 16.h),
                
                // Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Have an account? ',
                      style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w600),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const AuthView());
                      },
                      child: Text(
                        'Log in',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                          decoration: TextDecoration.underline,
                          decorationThickness: 2,
                          decorationColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 20.h),
                
                // Success animation overlay
                Obx(() => authController.isLoggedIn.value
                    ? _LoginSuccessAnimation()
                    : const SizedBox.shrink()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialLoginButton extends StatelessWidget {
  final String image;
  final String text;
  final RxBool isLoading;
  final VoidCallback onTap;

  const _SocialLoginButton({
    required this.image,
    required this.text,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => InkWell(
      onTap: isLoading.value ? null : onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        decoration: BoxDecoration(
          color: isLoading.value 
              ? const Color(0xFFFDF6ED).withOpacity(0.7)
              : const Color(0xFFFDF6ED),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            if (isLoading.value)
              SizedBox(
                width: 28.w,
                height: 28.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[600]!),
                ),
              )
            else
              Image.asset(image, height: 28.h, width: 28.w),
            
            SizedBox(width: 16.w),
            
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: isLoading.value ? Colors.grey[600] : Colors.black,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

class _LoginSuccessAnimation extends StatefulWidget {
  @override
  State<_LoginSuccessAnimation> createState() => _LoginSuccessAnimationState();
}

class _LoginSuccessAnimationState extends State<_LoginSuccessAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.7, 1.0),
    ));
    
    _controller.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.offAllNamed('/home');
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.3 * _fadeAnimation.value),
            child: Center(
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: 120.w,
                  height: 120.h,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 60.sp,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
} 