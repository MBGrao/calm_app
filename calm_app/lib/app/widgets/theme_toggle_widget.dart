import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/controllers/theme_controller.dart';

class ThemeToggleWidget extends StatelessWidget {
  const ThemeToggleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (controller) {
        return PopupMenuButton<ThemeMode>(
          icon: Icon(
            controller.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            color: Theme.of(context).iconTheme.color,
          ),
          onSelected: (ThemeMode mode) {
            switch (mode) {
              case ThemeMode.light:
                controller.setLightTheme();
                break;
              case ThemeMode.dark:
                controller.setDarkTheme();
                break;
              case ThemeMode.system:
                controller.setSystemTheme();
                break;
            }
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem<ThemeMode>(
              value: ThemeMode.light,
              child: Row(
                children: [
                  Icon(
                    Icons.light_mode,
                    color: controller.isDarkMode ? null : Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Light',
                    style: TextStyle(
                      color: controller.isDarkMode ? null : Theme.of(context).primaryColor,
                      fontWeight: controller.isDarkMode ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem<ThemeMode>(
              value: ThemeMode.dark,
              child: Row(
                children: [
                  Icon(
                    Icons.dark_mode,
                    color: controller.isDarkMode ? Theme.of(context).primaryColor : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Dark',
                    style: TextStyle(
                      color: controller.isDarkMode ? Theme.of(context).primaryColor : null,
                      fontWeight: controller.isDarkMode ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem<ThemeMode>(
              value: ThemeMode.system,
              child: Row(
                children: [
                  Icon(
                    Icons.settings_system_daydream,
                    color: controller.isSystemTheme ? Theme.of(context).primaryColor : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'System',
                    style: TextStyle(
                      color: controller.isSystemTheme ? Theme.of(context).primaryColor : null,
                      fontWeight: controller.isSystemTheme ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class ThemeToggleCard extends StatelessWidget {
  const ThemeToggleCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (controller) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Theme Settings',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                _buildThemeOption(
                  context,
                  controller,
                  ThemeMode.light,
                  'Light Theme',
                  'Use light colors',
                  Icons.light_mode,
                ),
                const SizedBox(height: 8),
                _buildThemeOption(
                  context,
                  controller,
                  ThemeMode.dark,
                  'Dark Theme',
                  'Use dark colors',
                  Icons.dark_mode,
                ),
                const SizedBox(height: 8),
                _buildThemeOption(
                  context,
                  controller,
                  ThemeMode.system,
                  'System Theme',
                  'Follow system settings',
                  Icons.settings_system_daydream,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    ThemeController controller,
    ThemeMode mode,
    String title,
    String subtitle,
    IconData icon,
  ) {
    final isSelected = (mode == ThemeMode.light && !controller.isDarkMode && !controller.isSystemTheme) ||
                      (mode == ThemeMode.dark && controller.isDarkMode && !controller.isSystemTheme) ||
                      (mode == ThemeMode.system && controller.isSystemTheme);

    return InkWell(
      onTap: () {
        switch (mode) {
          case ThemeMode.light:
            controller.setLightTheme();
            break;
          case ThemeMode.dark:
            controller.setDarkTheme();
            break;
          case ThemeMode.system:
            controller.setSystemTheme();
            break;
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
            width: 2,
          ),
          color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).iconTheme.color,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Theme.of(context).primaryColor : null,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isSelected ? Theme.of(context).primaryColor : null,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).primaryColor,
              ),
          ],
        ),
      ),
    );
  }
} 