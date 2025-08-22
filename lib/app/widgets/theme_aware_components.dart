import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/controllers/theme_controller.dart';

// Theme-aware text widget
class ThemeAwareText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const ThemeAwareText(
    this.text, {
    Key? key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    
    return Text(
      text,
      style: style?.copyWith(
        color: style?.color ?? themeController.getTextColor(),
      ) ?? TextStyle(
        color: themeController.getTextColor(),
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

// Theme-aware container with gradient background
class ThemeAwareContainer extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final bool useGradient;
  final bool useSurfaceColor;

  const ThemeAwareContainer({
    Key? key,
    this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderRadius,
    this.useGradient = false,
    this.useSurfaceColor = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: useGradient ? LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: themeController.getGradientColors(),
        ) : null,
        color: useSurfaceColor ? themeController.getSurfaceColor() : null,
      ),
      child: child,
    );
  }
}

// Theme-aware card widget
class ThemeAwareCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  const ThemeAwareCard({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.elevation,
    this.borderRadius,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    
    Widget card = Card(
      elevation: elevation ?? 2.0,
      color: themeController.getSurfaceColor(),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(12),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16.0),
        child: child,
      ),
    );

    if (onTap != null) {
      card = InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        child: card,
      );
    }

    return Container(
      margin: margin,
      child: card,
    );
  }
}

// Theme-aware button widget
class ThemeAwareButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;

  const ThemeAwareButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.padding,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    
    if (isOutlined) {
      return SizedBox(
        width: width,
        height: height,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            side: BorderSide(color: themeController.getPrimaryColor()),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: _buildButtonContent(themeController),
        ),
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: themeController.getPrimaryColor(),
          foregroundColor: Colors.white,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: _buildButtonContent(themeController),
      ),
    );
  }

  Widget _buildButtonContent(ThemeController themeController) {
    if (isLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    }

    return Text(text);
  }
}

// Theme-aware input field
class ThemeAwareTextField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final int? maxLines;
  final int? maxLength;

  const ThemeAwareTextField({
    Key? key,
    this.labelText,
    this.hintText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.maxLines = 1,
    this.maxLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      maxLines: maxLines,
      maxLength: maxLength,
      style: TextStyle(
        color: themeController.getTextColor(),
      ),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: themeController.getSurfaceColor(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: themeController.getSecondaryTextColor().withOpacity(0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: themeController.getSecondaryTextColor().withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: themeController.getPrimaryColor(),
            width: 2,
          ),
        ),
        labelStyle: TextStyle(
          color: themeController.getSecondaryTextColor(),
        ),
        hintStyle: TextStyle(
          color: themeController.getSecondaryTextColor(),
        ),
      ),
    );
  }
}

// Theme-aware list tile
class ThemeAwareListTile extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool enabled;

  const ThemeAwareListTile({
    Key? key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    
    return ListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      onTap: enabled ? onTap : null,
      enabled: enabled,
      textColor: themeController.getTextColor(),
      iconColor: themeController.getTextColor(),
    );
  }
}

// Theme-aware divider
class ThemeAwareDivider extends StatelessWidget {
  final double? height;
  final double? thickness;
  final double? indent;
  final double? endIndent;

  const ThemeAwareDivider({
    Key? key,
    this.height,
    this.thickness,
    this.indent,
    this.endIndent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    
    return Divider(
      height: height,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      color: themeController.getSecondaryTextColor().withOpacity(0.3),
    );
  }
}

// Theme-aware icon
class ThemeAwareIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;

  const ThemeAwareIcon(
    this.icon, {
    Key? key,
    this.size,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    
    return Icon(
      icon,
      size: size,
      color: color ?? themeController.getTextColor(),
    );
  }
}

// Theme-aware loading indicator
class ThemeAwareLoadingIndicator extends StatelessWidget {
  final double? size;
  final Color? color;
  final double? strokeWidth;

  const ThemeAwareLoadingIndicator({
    Key? key,
    this.size,
    this.color,
    this.strokeWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth ?? 2.0,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? themeController.getPrimaryColor(),
        ),
      ),
    );
  }
} 