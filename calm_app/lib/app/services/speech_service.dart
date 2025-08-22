import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:math' as math;

// Speech recognition result model
class SpeechResult {
  final String text;
  final double confidence;
  final bool isFinal;
  final String language;
  final DateTime timestamp;

  SpeechResult({
    required this.text,
    required this.confidence,
    required this.isFinal,
    required this.language,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'SpeechResult(text: $text, confidence: $confidence, isFinal: $isFinal, language: $language)';
  }
}

// Speech recognition error model
class SpeechError {
  final String message;
  final String code;
  final DateTime timestamp;

  SpeechError({
    required this.message,
    required this.code,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'SpeechError(message: $message, code: $code)';
  }
}

// Supported languages for speech recognition
class SupportedLanguage {
  final String code;
  final String name;
  final String nativeName;
  final double accuracy;

  const SupportedLanguage({
    required this.code,
    required this.name,
    required this.nativeName,
    this.accuracy = 1.0,
  });
}

// Speech service interface
abstract class SpeechServiceInterface {
  Future<bool> initialize();
  Future<void> startListening({
    String? languageCode,
    Duration? timeout,
    Function(SpeechResult)? onResult,
    Function(SpeechError)? onError,
  });
  Future<void> stopListening();
  Future<void> cancel();
  Future<bool> isAvailable();
  Future<List<SupportedLanguage>> getSupportedLanguages();
  Future<void> dispose();
}

// Main speech service implementation
class SpeechService implements SpeechServiceInterface {
  static SpeechService? _instance;
  static SpeechService get instance => _instance ??= SpeechService._();

  SpeechService._();

  // State management
  bool _isInitialized = false;
  bool _isListening = false;
  Timer? _timeoutTimer;
  Timer? _confidenceTimer;
  
  // Callbacks
  Function(SpeechResult)? _onResultCallback;
  Function(SpeechError)? _onErrorCallback;
  
  // Configuration
  String _currentLanguage = 'en-US';
  Duration _timeout = const Duration(seconds: 30);
  double _confidenceThreshold = 0.7;
  
  // Real-time transcription buffer
  final List<SpeechResult> _transcriptionBuffer = [];
  final StreamController<SpeechResult> _transcriptionController = StreamController<SpeechResult>.broadcast();
  
  // Accuracy optimization
  final Map<String, List<double>> _confidenceHistory = {};
  final Map<String, int> _languageUsageCount = {};

  @override
  Future<bool> initialize() async {
    try {
      // Simulate initialization delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      _isInitialized = true;
      _initializeConfidenceOptimization();
      
      return true;
    } catch (e) {
      _handleError('Failed to initialize speech service: $e', 'INIT_ERROR');
      return false;
    }
  }

  void _initializeConfidenceOptimization() {
    // Initialize confidence history for supported languages
    getSupportedLanguages().then((languages) {
      for (final language in languages) {
        _confidenceHistory[language.code] = [];
        _languageUsageCount[language.code] = 0;
      }
    });
  }

  @override
  Future<void> startListening({
    String? languageCode,
    Duration? timeout,
    Function(SpeechResult)? onResult,
    Function(SpeechError)? onError,
  }) async {
    if (!_isInitialized) {
      final initialized = await initialize();
      if (!initialized) return;
    }

    if (_isListening) {
      await stopListening();
    }

    try {
      _isListening = true;
      _currentLanguage = languageCode ?? _currentLanguage;
      _timeout = timeout ?? _timeout;
      _onResultCallback = onResult;
      _onErrorCallback = onError;
      
      // Clear previous transcription
      _transcriptionBuffer.clear();
      
      // Start timeout timer
      _timeoutTimer = Timer(_timeout, () {
        if (_isListening) {
          stopListening();
        }
      });

      // Start confidence optimization timer
      _confidenceTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        if (_isListening) {
          _simulateRealTimeTranscription();
        } else {
          timer.cancel();
        }
      });

      // Update language usage count
      _languageUsageCount[_currentLanguage] = (_languageUsageCount[_currentLanguage] ?? 0) + 1;

    } catch (e) {
      _handleError('Failed to start listening: $e', 'START_ERROR');
    }
  }

  @override
  Future<void> stopListening() async {
    if (!_isListening) return;

    try {
      _isListening = false;
      _timeoutTimer?.cancel();
      _confidenceTimer?.cancel();

      // Process final transcription
      if (_transcriptionBuffer.isNotEmpty) {
        final finalResult = _createFinalResult();
        _onResultCallback?.call(finalResult);
        _transcriptionController.add(finalResult);
      }

    } catch (e) {
      _handleError('Failed to stop listening: $e', 'STOP_ERROR');
    }
  }

  @override
  Future<void> cancel() async {
    _isListening = false;
    _timeoutTimer?.cancel();
    _confidenceTimer?.cancel();
    _transcriptionBuffer.clear();
  }

  @override
  Future<bool> isAvailable() async {
    return _isInitialized;
  }

  @override
  Future<List<SupportedLanguage>> getSupportedLanguages() async {
    return [
      const SupportedLanguage(
        code: 'en-US',
        name: 'English (US)',
        nativeName: 'English',
        accuracy: 0.95,
      ),
      const SupportedLanguage(
        code: 'en-GB',
        name: 'English (UK)',
        nativeName: 'English',
        accuracy: 0.93,
      ),
      const SupportedLanguage(
        code: 'es-ES',
        name: 'Spanish',
        nativeName: 'Español',
        accuracy: 0.92,
      ),
      const SupportedLanguage(
        code: 'fr-FR',
        name: 'French',
        nativeName: 'Français',
        accuracy: 0.91,
      ),
      const SupportedLanguage(
        code: 'de-DE',
        name: 'German',
        nativeName: 'Deutsch',
        accuracy: 0.90,
      ),
      const SupportedLanguage(
        code: 'it-IT',
        name: 'Italian',
        nativeName: 'Italiano',
        accuracy: 0.89,
      ),
      const SupportedLanguage(
        code: 'pt-BR',
        name: 'Portuguese (Brazil)',
        nativeName: 'Português',
        accuracy: 0.88,
      ),
      const SupportedLanguage(
        code: 'ja-JP',
        name: 'Japanese',
        nativeName: '日本語',
        accuracy: 0.87,
      ),
      const SupportedLanguage(
        code: 'ko-KR',
        name: 'Korean',
        nativeName: '한국어',
        accuracy: 0.86,
      ),
      const SupportedLanguage(
        code: 'zh-CN',
        name: 'Chinese (Simplified)',
        nativeName: '中文',
        accuracy: 0.85,
      ),
    ];
  }

  @override
  Future<void> dispose() async {
    await cancel();
    await _transcriptionController.close();
  }

  // Real-time transcription simulation
  void _simulateRealTimeTranscription() {
    if (!_isListening) return;

    final simulatedTexts = _getSimulatedTextsForLanguage(_currentLanguage);
    final randomText = simulatedTexts[math.Random().nextInt(simulatedTexts.length)];
    
    // Simulate partial and final results
    final isFinal = math.Random().nextDouble() > 0.7;
    final confidence = _calculateOptimizedConfidence();
    
    final result = SpeechResult(
      text: isFinal ? randomText : randomText.substring(0, math.min(randomText.length, math.Random().nextInt(randomText.length) + 1)),
      confidence: confidence,
      isFinal: isFinal,
      language: _currentLanguage,
      timestamp: DateTime.now(),
    );

    _transcriptionBuffer.add(result);
    
    // Update confidence history
    _confidenceHistory[_currentLanguage]?.add(confidence);
    if (_confidenceHistory[_currentLanguage]!.length > 100) {
      _confidenceHistory[_currentLanguage]!.removeAt(0);
    }

    // Send result to callbacks
    _onResultCallback?.call(result);
    _transcriptionController.add(result);
  }

  // Get simulated texts for different languages
  List<String> _getSimulatedTextsForLanguage(String languageCode) {
    switch (languageCode) {
      case 'en-US':
      case 'en-GB':
        return [
          "I need some meditation",
          "Play calming music",
          "Start a breathing exercise",
          "Help me relax",
          "I want to sleep better",
          "Reduce my anxiety",
          "Focus on mindfulness",
          "Nature sounds please",
        ];
      case 'es-ES':
        return [
          "Necesito meditación",
          "Reproduce música relajante",
          "Inicia un ejercicio de respiración",
          "Ayúdame a relajarme",
          "Quiero dormir mejor",
          "Reduce mi ansiedad",
          "Enfócate en la atención plena",
          "Sonidos de la naturaleza por favor",
        ];
      case 'fr-FR':
        return [
          "J'ai besoin de méditation",
          "Joue de la musique apaisante",
          "Commence un exercice de respiration",
          "Aide-moi à me détendre",
          "Je veux mieux dormir",
          "Réduis mon anxiété",
          "Concentre-toi sur la pleine conscience",
          "Sons de la nature s'il te plaît",
        ];
      case 'de-DE':
        return [
          "Ich brauche Meditation",
          "Spiele beruhigende Musik",
          "Starte eine Atemübung",
          "Hilf mir zu entspannen",
          "Ich will besser schlafen",
          "Reduziere meine Angst",
          "Konzentriere dich auf Achtsamkeit",
          "Naturgeräusche bitte",
        ];
      default:
        return [
          "I need some meditation",
          "Play calming music",
          "Start a breathing exercise",
          "Help me relax",
        ];
    }
  }

  // Calculate optimized confidence based on language usage and history
  double _calculateOptimizedConfidence() {
    final baseConfidence = 0.7 + (math.Random().nextDouble() * 0.25);
    final languageAccuracy = 0.9; // Default accuracy for mock implementation
    final usageBonus = _getUsageBonus(_currentLanguage);
    
    return math.min(1.0, baseConfidence * languageAccuracy * usageBonus);
  }



  double _getUsageBonus(String languageCode) {
    final usageCount = _languageUsageCount[languageCode] ?? 0;
    // More usage = better accuracy (learning effect)
    return 1.0 + (usageCount * 0.01);
  }

  // Create final result from transcription buffer
  SpeechResult _createFinalResult() {
    if (_transcriptionBuffer.isEmpty) {
      return SpeechResult(
        text: '',
        confidence: 0.0,
        isFinal: true,
        language: _currentLanguage,
        timestamp: DateTime.now(),
      );
    }

    // Get the best result (highest confidence)
    final bestResult = _transcriptionBuffer.reduce((a, b) => a.confidence > b.confidence ? a : b);
    
    return SpeechResult(
      text: bestResult.text,
      confidence: bestResult.confidence,
      isFinal: true,
      language: _currentLanguage,
      timestamp: DateTime.now(),
    );
  }

  void _handleError(String message, String code) {
    final error = SpeechError(
      message: message,
      code: code,
      timestamp: DateTime.now(),
    );
    
    _onErrorCallback?.call(error);
    _isListening = false;
    _timeoutTimer?.cancel();
    _confidenceTimer?.cancel();
  }

  // Public methods for accessing transcription stream
  Stream<SpeechResult> get transcriptionStream => _transcriptionController.stream;

  // Get confidence statistics for a language
  Map<String, dynamic> getConfidenceStats(String languageCode) {
    final history = _confidenceHistory[languageCode] ?? [];
    if (history.isEmpty) {
      return {
        'average': 0.0,
        'min': 0.0,
        'max': 0.0,
        'count': 0,
      };
    }

    final average = history.reduce((a, b) => a + b) / history.length;
    final min = history.reduce((a, b) => a < b ? a : b);
    final max = history.reduce((a, b) => a > b ? a : b);

    return {
      'average': average,
      'min': min,
      'max': max,
      'count': history.length,
    };
  }

  // Get recommended language based on usage and accuracy
  String getRecommendedLanguage() {
    // For mock implementation, return default language
    return 'en-US';
  }

  // Reset confidence history for a language
  void resetConfidenceHistory(String languageCode) {
    _confidenceHistory[languageCode]?.clear();
    _languageUsageCount[languageCode] = 0;
  }

  // Set confidence threshold
  void setConfidenceThreshold(double threshold) {
    _confidenceThreshold = math.max(0.0, math.min(1.0, threshold));
  }

  // Get current confidence threshold
  double get confidenceThreshold => _confidenceThreshold;
}

// Speech service controller for GetX integration
class SpeechServiceController extends GetxController {
  final SpeechService _speechService = SpeechService.instance;
  
  final RxBool isListening = false.obs;
  final RxBool isInitialized = false.obs;
  final RxString currentLanguage = 'en-US'.obs;
  final RxString currentText = ''.obs;
  final RxDouble currentConfidence = 0.0.obs;
  final RxList<SpeechResult> transcriptionHistory = <SpeechResult>[].obs;
  final RxList<SupportedLanguage> supportedLanguages = <SupportedLanguage>[].obs;
  
  StreamSubscription<SpeechResult>? _transcriptionSubscription;

  @override
  void onInit() {
    super.onInit();
    _initializeService();
  }

  Future<void> _initializeService() async {
    final initialized = await _speechService.initialize();
    isInitialized.value = initialized;
    
    if (initialized) {
      final languages = await _speechService.getSupportedLanguages();
      supportedLanguages.assignAll(languages);
      
      // Subscribe to transcription stream
      _transcriptionSubscription = _speechService.transcriptionStream.listen((result) {
        if (result.isFinal) {
          transcriptionHistory.add(result);
          currentText.value = result.text;
          currentConfidence.value = result.confidence;
        } else {
          currentText.value = result.text;
          currentConfidence.value = result.confidence;
        }
      });
    }
  }

  Future<void> startListening({String? languageCode}) async {
    if (!isInitialized.value) return;

    await _speechService.startListening(
      languageCode: languageCode ?? currentLanguage.value,
      onResult: (result) {
        if (result.isFinal) {
          transcriptionHistory.add(result);
        }
        currentText.value = result.text;
        currentConfidence.value = result.confidence;
      },
      onError: (error) {
        Get.snackbar(
          'Speech Recognition Error',
          error.message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
    );

    isListening.value = true;
    currentLanguage.value = languageCode ?? currentLanguage.value;
  }

  Future<void> stopListening() async {
    await _speechService.stopListening();
    isListening.value = false;
  }

  Future<void> cancelListening() async {
    await _speechService.cancel();
    isListening.value = false;
    currentText.value = '';
  }

  void setLanguage(String languageCode) {
    currentLanguage.value = languageCode;
  }

  String getRecommendedLanguage() {
    return _speechService.getRecommendedLanguage();
  }

  Map<String, dynamic> getConfidenceStats(String languageCode) {
    return _speechService.getConfidenceStats(languageCode);
  }

  @override
  void onClose() {
    _transcriptionSubscription?.cancel();
    _speechService.dispose();
    super.onClose();
  }
} 