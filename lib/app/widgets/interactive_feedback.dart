import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:ui';
import '../core/controllers/theme_controller.dart';

// Haptic feedback helper
class HapticFeedbackHelper {
  static void lightImpact() {
    HapticFeedback.lightImpact();
  }

  static void mediumImpact() {
    HapticFeedback.mediumImpact();
  }

  static void heavyImpact() {
    HapticFeedback.heavyImpact();
  }

  static void selectionChanged() {
    HapticFeedback.selectionClick();
  }

  static void vibrate() {
    HapticFeedback.vibrate();
  }
}

// Animated button with haptic feedback
class AnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isSuccess;
  final bool isError;
  final Duration animationDuration;
  final double scaleFactor;

  const AnimatedButton({
    Key? key,
    required this.child,
    this.onPressed,
    this.isLoading = false,
    this.isSuccess = false,
    this.isError = false,
    this.animationDuration = const Duration(milliseconds: 150),
    this.scaleFactor = 0.95,
  }) : super(key: key);

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleFactor,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      setState(() => _isPressed = true);
      _controller.forward();
      HapticFeedbackHelper.lightImpact();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.onPressed != null && !widget.isLoading) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.isLoading ? null : widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: _getButtonColor(themeController),
                boxShadow: [
                  BoxShadow(
                    color: _getButtonColor(themeController).withOpacity(0.3),
                    blurRadius: _isPressed ? 2 : 4,
                    offset: Offset(0, _isPressed ? 1 : 2),
                  ),
                ],
              ),
              child: widget.isLoading
                  ? _buildLoadingContent()
                  : widget.isSuccess
                      ? _buildSuccessContent()
                      : widget.isError
                          ? _buildErrorContent()
                          : widget.child,
            ),
          );
        },
      ),
    );
  }

  Color _getButtonColor(ThemeController themeController) {
    if (widget.isSuccess) {
      return themeController.isDarkMode ? Colors.green : Colors.green;
    } else if (widget.isError) {
      return themeController.isDarkMode ? Colors.red : Colors.red;
    } else if (widget.isLoading) {
      return themeController.isDarkMode ? Colors.grey : Colors.grey;
    } else {
      return themeController.getPrimaryColor();
    }
  }

  Widget _buildLoadingContent() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }

  Widget _buildSuccessContent() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Icon(
        Icons.check,
        color: Colors.white,
        size: 24,
      ),
    );
  }

  Widget _buildErrorContent() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Icon(
        Icons.error,
        color: Colors.white,
        size: 24,
      ),
    );
  }
}

// Animated card with hover and press effects
class AnimatedCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final double elevation;
  final Duration animationDuration;

  const AnimatedCard({
    Key? key,
    required this.child,
    this.onTap,
    this.padding,
    this.elevation = 2.0,
    this.animationDuration = const Duration(milliseconds: 200),
  }) : super(key: key);

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _elevationAnimation = Tween<double>(
      begin: widget.elevation,
      end: widget.elevation * 0.5,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap != null) {
      _controller.forward();
      HapticFeedbackHelper.lightImpact();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.onTap != null) {
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.onTap != null) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Card(
              elevation: _elevationAnimation.value,
              color: themeController.getSurfaceColor(),
              child: Padding(
                padding: widget.padding ?? const EdgeInsets.all(16.0),
                child: widget.child,
              ),
            ),
          );
        },
      ),
    );
  }
}

// Loading overlay with blur effect
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;

  const LoadingOverlay({
    Key? key,
    required this.isLoading,
    required this.child,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        if (message != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            message!,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// Success/Error toast messages
class FeedbackToast {
  static void showSuccess(String message) {
    HapticFeedbackHelper.lightImpact();
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }

  static void showError(String message) {
    HapticFeedbackHelper.heavyImpact();
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      icon: const Icon(Icons.error, color: Colors.white),
    );
  }

  static void showInfo(String message) {
    HapticFeedbackHelper.selectionChanged();
    Get.snackbar(
      'Info',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      icon: const Icon(Icons.info, color: Colors.white),
    );
  }
}

// Animated progress indicator
class AnimatedProgressIndicator extends StatefulWidget {
  final double progress;
  final Color? color;
  final double height;
  final Duration animationDuration;

  const AnimatedProgressIndicator({
    Key? key,
    required this.progress,
    this.color,
    this.height = 8.0,
    this.animationDuration = const Duration(milliseconds: 500),
  }) : super(key: key);

  @override
  State<AnimatedProgressIndicator> createState() => _AnimatedProgressIndicatorState();
}

class _AnimatedProgressIndicatorState extends State<AnimatedProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.progress,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _progressAnimation = Tween<double>(
        begin: oldWidget.progress,
        end: widget.progress,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        return Container(
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.height / 2),
            color: themeController.getSecondaryTextColor().withOpacity(0.2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: _progressAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.height / 2),
                color: widget.color ?? themeController.getPrimaryColor(),
              ),
            ),
          ),
        );
      },
    );
  }
} 