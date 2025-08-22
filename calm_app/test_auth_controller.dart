import 'package:get/get.dart';
import 'lib/app/modules/auth/controllers/auth_controller.dart';

void main() {
  // Test AuthController initialization
  print('🧪 Testing AuthController Initialization');
  print('========================================\n');

  try {
    // Initialize AuthController
    final authController = Get.put(AuthController());
    print('✅ AuthController initialized successfully');

    // Test finding AuthController
    Get.find<AuthController>();
    print('✅ AuthController found successfully');

    // Test initial state
    print('Initial state:');
    print('- isLoading: ${authController.isLoading.value}');
    print('- isLoggedIn: ${authController.isLoggedIn.value}');
    print('- userProfile: ${authController.userProfile.value}');
    print('- authError: ${authController.authError.value}');

    print('\n🎉 AuthController test passed!');
    print('The controller is properly initialized and accessible.');

  } catch (e) {
    print('❌ AuthController test failed: $e');
  }
} 