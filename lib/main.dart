import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app/routes/app_pages.dart';
import 'app/core/controllers/theme_controller.dart';
import 'app/modules/auth/controllers/auth_controller.dart';
import 'app/modules/home/views/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize controllers
    Get.put(ThemeController());
    Get.put(AuthController());
    
    // Don't wait for auth controller to initialize - make it non-blocking
    // The auth controller will handle its own initialization in the background
    
    runApp(const MyApp());
  } catch (e, stackTrace) {
    print('Error in main: $e');
    print('Stack trace: $stackTrace');
    // Run the app even if there's an error
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      final themeController = Get.find<ThemeController>();
      
      return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (context, child) => GetMaterialApp(
          title: 'MeditAi',
          theme: themeController.lightTheme,
          darkTheme: themeController.darkTheme,
          themeMode: themeController.themeMode,
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.initial,
          getPages: AppPages.routes,
          home: const HomeView(),
        ),
        child: const HomeView(),
      );
    } catch (e, stackTrace) {
      print('Error in MyApp build: $e');
      print('Stack trace: $stackTrace');
      // Fallback to a basic MaterialApp if theme controller fails
      return MaterialApp(
        title: 'MeditAi',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomeView(),
      );
    }
  }
}
