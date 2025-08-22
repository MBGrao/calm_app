import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class AuthView extends StatefulWidget {
  const AuthView({Key? key}) : super(key: key);

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> with TickerProviderStateMixin {
  final controller = Get.find<AuthController>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  
  bool isLoginMode = true;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          child: Stack(
            children: [
              // Main content
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Back button
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 24.sp,
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 40.h),
                        
                        // Title
                        Text(
                          isLoginMode ? 'Welcome Back!' : 'Create Account',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        
                        SizedBox(height: 8.h),
                        
                        Text(
                          isLoginMode 
                              ? 'Sign in to continue your journey'
                              : 'Join us and start your wellness journey',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16.sp,
                          ),
                        ),
                        
                        SizedBox(height: 40.h),
                        
                        // Error message
                        Obx(() => controller.authError.value.isNotEmpty
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
                                        controller.authError.value,
                                        style: TextStyle(
                                          color: Colors.red[100],
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => controller.setAuthError(''),
                                      child: Icon(Icons.close, color: Colors.red[100], size: 20.sp),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox.shrink()),
                        
                        // Name field (signup only)
                        if (!isLoginMode) ...[
                          _buildTextField(
                            controller: nameController,
                            label: 'Full Name',
                            icon: Icons.person_outline,
                          ),
                          SizedBox(height: 16.h),
                        ],
                        
                        // Email field
                        _buildTextField(
                          controller: emailController,
                          label: 'Email',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        
                        SizedBox(height: 16.h),
                        
                        // Password field
                        _buildTextField(
                          controller: passwordController,
                          label: 'Password',
                          icon: Icons.lock_outline,
                          isPassword: true,
                          isPasswordVisible: isPasswordVisible,
                          onPasswordToggle: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                        
                        // Confirm password field (signup only)
                        if (!isLoginMode) ...[
                          SizedBox(height: 16.h),
                          _buildTextField(
                            controller: confirmPasswordController,
                            label: 'Confirm Password',
                            icon: Icons.lock_outline,
                            isPassword: true,
                            isPasswordVisible: isConfirmPasswordVisible,
                            onPasswordToggle: () {
                              setState(() {
                                isConfirmPasswordVisible = !isConfirmPasswordVisible;
                              });
                            },
                          ),
                        ],
                        
                        // Forgot password (login only)
                        if (isLoginMode) ...[
                          SizedBox(height: 16.h),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () => _showForgotPasswordDialog(),
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                        
                        SizedBox(height: 32.h),
                        
                        // Login/Signup button
                        Obx(() => SizedBox(
                          width: double.infinity,
                          height: 50.h,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 0,
                            ),
                            onPressed: controller.isLoading.value ? null : () {
                              _handleAuth();
                            },
                            child: controller.isLoading.value
                                ? SizedBox(
                                    width: 24.w,
                                    height: 24.h,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[600]!),
                                    ),
                                  )
                                : Text(
                                    isLoginMode ? 'Sign In' : 'Create Account',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        )),
                        
                        SizedBox(height: 24.h),
                        
                        // Switch mode
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isLoginMode ? "Don't have an account? " : 'Already have an account? ',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14.sp,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isLoginMode = !isLoginMode;
                                  // Clear form
                                  emailController.clear();
                                  passwordController.clear();
                                  nameController.clear();
                                  confirmPasswordController.clear();
                                  controller.setAuthError('');
                                });
                              },
                              child: Text(
                                isLoginMode ? 'Sign Up' : 'Sign In',
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Success animation overlay
              Obx(() => controller.isLoggedIn.value
                  ? _LoginSuccessAnimation()
                  : const SizedBox.shrink()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onPasswordToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && !isPasswordVisible,
        keyboardType: keyboardType,
        style: TextStyle(color: Colors.white, fontSize: 16.sp),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white70, fontSize: 14.sp),
          prefixIcon: Icon(icon, color: Colors.white70, size: 20.sp),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white70,
                    size: 20.sp,
                  ),
                  onPressed: onPasswordToggle,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  void _handleAuth() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    
    if (email.isEmpty || password.isEmpty) {
      controller.setAuthError('Please fill in all fields');
      return;
    }
    
    if (!isLoginMode) {
      final name = nameController.text.trim();
      final confirmPassword = confirmPasswordController.text.trim();
      
      if (name.isEmpty) {
        controller.setAuthError('Please enter your name');
        return;
      }
      
      if (password != confirmPassword) {
        controller.setAuthError('Passwords do not match');
        return;
      }
      
      if (password.length < 6) {
        controller.setAuthError('Password must be at least 6 characters');
        return;
      }

      // Split name into first and last name
      final nameParts = name.split(' ');
      final firstName = nameParts.first;
      final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
      
      // For signup, we'll navigate to privacy policy first
      _showPrivacyPolicyDialog(email, password, firstName, lastName);
    } else {
      controller.signInWithEmail(email, password);
    }
  }

  void _showPrivacyPolicyDialog(String email, String password, String firstName, String lastName) {
    bool acceptPrivacyPolicy = false;
    bool acceptTermsOfService = false;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: const Color(0xFF1B4B6F),
          title: Text(
            'Privacy Policy & Terms of Service',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Before creating your account, please review and accept our Privacy Policy and Terms of Service.',
                  style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                ),
                SizedBox(height: 16.h),
                
                // Privacy Policy Checkbox
                Row(
                  children: [
                    Checkbox(
                      value: acceptPrivacyPolicy,
                      onChanged: (value) {
                        setState(() {
                          acceptPrivacyPolicy = value ?? false;
                        });
                      },
                      activeColor: Colors.orange,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            acceptPrivacyPolicy = !acceptPrivacyPolicy;
                          });
                        },
                        child: Text(
                          'I accept the Privacy Policy',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                // Terms of Service Checkbox
                Row(
                  children: [
                    Checkbox(
                      value: acceptTermsOfService,
                      onChanged: (value) {
                        setState(() {
                          acceptTermsOfService = value ?? false;
                        });
                      },
                      activeColor: Colors.orange,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            acceptTermsOfService = !acceptTermsOfService;
                          });
                        },
                        child: Text(
                          'I accept the Terms of Service',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            TextButton(
              onPressed: acceptPrivacyPolicy && acceptTermsOfService
                  ? () {
                      Navigator.pop(context);
                      controller.signUp(
                        email,
                        password,
                        firstName,
                        lastName,
                        acceptPrivacyPolicy: acceptPrivacyPolicy,
                        acceptTermsOfService: acceptTermsOfService,
                      );
                    }
                  : null,
              child: Text(
                'Create Account',
                style: TextStyle(
                  color: acceptPrivacyPolicy && acceptTermsOfService
                      ? Colors.orange
                      : Colors.white30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showForgotPasswordDialog() {
    final emailController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1B4B6F),
        title: Text(
          'Reset Password',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Enter your email address to receive a password reset link',
              style: TextStyle(color: Colors.white70, fontSize: 14.sp),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.white70, fontSize: 12.sp),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white30),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          TextButton(
            onPressed: () {
              final email = emailController.text.trim();
              if (email.isNotEmpty) {
                controller.forgotPassword(email);
                Navigator.pop(context);
              }
            },
            child: Text(
              'Send',
              style: TextStyle(color: Colors.orange),
            ),
          ),
        ],
      ),
    );
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
        return Container(
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
        );
      },
    );
  }
} 