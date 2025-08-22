import 'package:get/get.dart';

class OnboardingController extends GetxController {
  var currentStep = 0.obs;

  void nextStep() {
    if (currentStep.value < 4) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step <= 4) {
      currentStep.value = step;
    }
  }
} 