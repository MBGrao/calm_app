import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:async';

// Voice model
class Voice {
  final String id;
  final String name;
  final String language;
  final String gender;
  final double quality;
  final bool isPremium;

  const Voice({
    required this.id,
    required this.name,
    required this.language,
    required this.gender,
    this.quality = 1.0,
    this.isPremium = false,
  });

  @override
  String toString() {
    return 'Voice(id: $id, name: $name, language: $language, gender: $gender)';
  }
}

// TTS settings model
class TTSSettings {
  final String voiceId;
  final double speed;
  final double pitch;
  final double volume;
  final bool autoPlay;

  const TTSSettings({
    this.voiceId = 'en-US-1',
    this.speed = 1.0,
    this.pitch = 1.0,
    this.volume = 1.0,
    this.autoPlay = true,
  });

  TTSSettings copyWith({
    String? voiceId,
    double? speed,
    double? pitch,
    double? volume,
    bool? autoPlay,
  }) {
    return TTSSettings(
      voiceId: voiceId ?? this.voiceId,
      speed: speed ?? this.speed,
      pitch: pitch ?? this.pitch,
      volume: volume ?? this.volume,
      autoPlay: autoPlay ?? this.autoPlay,
    );
  }
}

// TTS service interface
abstract class TTSServiceInterface {
  Future<bool> initialize();
  Future<void> speak(String text, {String? voice, double? speed, double? pitch, double? volume});
  Future<void> stop();
  Future<void> pause();
  Future<void> resume();
  Future<bool> isAvailable();
  Future<List<Voice>> getAvailableVoices();
  Future<TTSSettings> getSettings();
  Future<void> updateSettings(TTSSettings settings);
  Future<void> dispose();
}

// Main TTS service implementation
class TTSService implements TTSServiceInterface {
  static TTSService? _instance;
  static TTSService get instance => _instance ??= TTSService._();

  TTSService._();

  // State management
  bool _isInitialized = false;
  bool _isSpeaking = false;
  bool _isPaused = false;
  
  // Current settings
  TTSSettings _settings = const TTSSettings();
  
  // Available voices
  final List<Voice> _availableVoices = [
    const Voice(
      id: 'en-US-1',
      name: 'Emma',
      language: 'en-US',
      gender: 'female',
      quality: 0.95,
    ),
    const Voice(
      id: 'en-US-2',
      name: 'James',
      language: 'en-US',
      gender: 'male',
      quality: 0.93,
    ),
    const Voice(
      id: 'en-GB-1',
      name: 'Sophie',
      language: 'en-GB',
      gender: 'female',
      quality: 0.94,
    ),
    const Voice(
      id: 'en-GB-2',
      name: 'Oliver',
      language: 'en-GB',
      gender: 'male',
      quality: 0.92,
    ),
    const Voice(
      id: 'es-ES-1',
      name: 'Isabella',
      language: 'es-ES',
      gender: 'female',
      quality: 0.91,
    ),
    const Voice(
      id: 'fr-FR-1',
      name: 'Marie',
      language: 'fr-FR',
      gender: 'female',
      quality: 0.90,
    ),
    const Voice(
      id: 'de-DE-1',
      name: 'Hans',
      language: 'de-DE',
      gender: 'male',
      quality: 0.89,
    ),
    const Voice(
      id: 'it-IT-1',
      name: 'Giulia',
      language: 'it-IT',
      gender: 'female',
      quality: 0.88,
    ),
    const Voice(
      id: 'pt-BR-1',
      name: 'Ana',
      language: 'pt-BR',
      gender: 'female',
      quality: 0.87,
    ),
    const Voice(
      id: 'ja-JP-1',
      name: 'Yuki',
      language: 'ja-JP',
      gender: 'female',
      quality: 0.86,
    ),
  ];

  // Speech queue
  final List<String> _speechQueue = [];
  Timer? _speechTimer;
  String? _currentText;

  @override
  Future<bool> initialize() async {
    try {
      // Simulate initialization delay
      await Future.delayed(const Duration(milliseconds: 300));
      
      _isInitialized = true;
      return true;
    } catch (e) {
      Get.snackbar(
        'TTS Error',
        'Failed to initialize text-to-speech: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  @override
  Future<void> speak(String text, {
    String? voice,
    double? speed,
    double? pitch,
    double? volume,
  }) async {
    if (!_isInitialized) {
      final initialized = await initialize();
      if (!initialized) return;
    }

    // Stop current speech if speaking
    if (_isSpeaking) {
      await stop();
    }

    // Update settings if provided
    if (voice != null || speed != null || pitch != null || volume != null) {
      _settings = _settings.copyWith(
        voiceId: voice ?? _settings.voiceId,
        speed: speed ?? _settings.speed,
        pitch: pitch ?? _settings.pitch,
        volume: volume ?? _settings.volume,
      );
    }

    // Add to queue
    _speechQueue.add(text);
    
    // Start speaking if not already speaking
    if (!_isSpeaking) {
      _processSpeechQueue();
    }
  }

  void _processSpeechQueue() async {
    if (_speechQueue.isEmpty || _isSpeaking) return;

    _isSpeaking = true;
    _currentText = _speechQueue.removeAt(0);

    try {
      // Simulate speech duration based on text length and speed
      final duration = _calculateSpeechDuration(_currentText!, _settings.speed);
      
      // Start speech timer
      _speechTimer = Timer(duration, () {
        _isSpeaking = false;
        _currentText = null;
        
        // Process next item in queue
        if (_speechQueue.isNotEmpty) {
          _processSpeechQueue();
        }
      });

      // Provide haptic feedback
      HapticFeedback.lightImpact();

    } catch (e) {
      _isSpeaking = false;
      _currentText = null;
      
      Get.snackbar(
        'TTS Error',
        'Failed to speak text: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Duration _calculateSpeechDuration(String text, double speed) {
    // Average speaking rate is about 150 words per minute
    final words = text.split(' ').length;
    final baseDuration = Duration(milliseconds: (words * 400)); // 400ms per word
    return Duration(milliseconds: (baseDuration.inMilliseconds / speed).round());
  }

  @override
  Future<void> stop() async {
    _speechTimer?.cancel();
    _speechQueue.clear();
    _isSpeaking = false;
    _isPaused = false;
    _currentText = null;
  }

  @override
  Future<void> pause() async {
    if (_isSpeaking && !_isPaused) {
      _speechTimer?.cancel();
      _isPaused = true;
    }
  }

  @override
  Future<void> resume() async {
    if (_isPaused && _currentText != null) {
      _isPaused = false;
      _processSpeechQueue();
    }
  }

  @override
  Future<bool> isAvailable() async {
    return _isInitialized;
  }

  @override
  Future<List<Voice>> getAvailableVoices() async {
    return List.from(_availableVoices);
  }

  @override
  Future<TTSSettings> getSettings() async {
    return _settings;
  }

  @override
  Future<void> updateSettings(TTSSettings settings) async {
    _settings = settings;
  }

  @override
  Future<void> dispose() async {
    try {
      await stop();
      _isInitialized = false;
    } catch (e) {
      debugPrint('TTS service disposal error: $e');
    }
  }

  // Get current speaking status
  bool get isSpeaking => _isSpeaking;
  bool get isPaused => _isPaused;
  String? get currentText => _currentText;
  int get queueLength => _speechQueue.length;

  // Get voice by ID
  Voice? getVoiceById(String voiceId) {
    try {
      return _availableVoices.firstWhere((voice) => voice.id == voiceId);
    } catch (e) {
      return null;
    }
  }

  // Get voices by language
  List<Voice> getVoicesByLanguage(String language) {
    return _availableVoices.where((voice) => voice.language == language).toList();
  }

  // Get premium voices
  List<Voice> getPremiumVoices() {
    return _availableVoices.where((voice) => voice.isPremium).toList();
  }

  // Get high quality voices (quality > 0.9)
  List<Voice> getHighQualityVoices() {
    return _availableVoices.where((voice) => voice.quality > 0.9).toList();
  }

  // Speak with specific voice
  Future<void> speakWithVoice(String text, String voiceId) async {
    final voice = getVoiceById(voiceId);
    if (voice == null) {
      throw Exception('Voice not found: $voiceId');
    }
    
    await speak(text, voice: voiceId);
  }

  // Speak with custom settings
  Future<void> speakWithSettings(String text, TTSSettings settings) async {
    await speak(
      text,
      voice: settings.voiceId,
      speed: settings.speed,
      pitch: settings.pitch,
      volume: settings.volume,
    );
  }

  // Queue multiple texts
  Future<void> queueTexts(List<String> texts) async {
    _speechQueue.addAll(texts);
    
    if (!_isSpeaking) {
      _processSpeechQueue();
    }
  }

  // Clear speech queue
  void clearQueue() {
    _speechQueue.clear();
  }

  // Get speech statistics
  Map<String, dynamic> getSpeechStats() {
    return {
      'isSpeaking': _isSpeaking,
      'isPaused': _isPaused,
      'queueLength': _speechQueue.length,
      'currentText': _currentText,
      'settings': {
        'voiceId': _settings.voiceId,
        'speed': _settings.speed,
        'pitch': _settings.pitch,
        'volume': _settings.volume,
        'autoPlay': _settings.autoPlay,
      },
      'availableVoices': _availableVoices.length,
    };
  }
}

// TTS Controller for GetX integration
class TTSController extends GetxController {
  final TTSService _ttsService = TTSService.instance;
  
  final RxBool isSpeaking = false.obs;
  final RxBool isPaused = false.obs;
  final RxString currentText = ''.obs;
  final RxInt queueLength = 0.obs;
  final RxList<Voice> availableVoices = <Voice>[].obs;
  final Rx<TTSSettings> settings = TTSSettings().obs;

  @override
  void onInit() {
    super.onInit();
    _initializeService();
  }

  Future<void> _initializeService() async {
    final initialized = await _ttsService.initialize();
    if (initialized) {
      final voices = await _ttsService.getAvailableVoices();
      availableVoices.assignAll(voices);
      
      final currentSettings = await _ttsService.getSettings();
      settings.value = currentSettings;
      
      // Start monitoring TTS state
      _startStateMonitoring();
    }
  }

  void _startStateMonitoring() {
    // Monitor TTS state changes
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      isSpeaking.value = _ttsService.isSpeaking;
      isPaused.value = _ttsService.isPaused;
      currentText.value = _ttsService.currentText ?? '';
      queueLength.value = _ttsService.queueLength;
    });
  }

  Future<void> speak(String text, {
    String? voice,
    double? speed,
    double? pitch,
    double? volume,
  }) async {
    await _ttsService.speak(
      text,
      voice: voice,
      speed: speed,
      pitch: pitch,
      volume: volume,
    );
  }

  Future<void> stop() async {
    await _ttsService.stop();
  }

  Future<void> pause() async {
    await _ttsService.pause();
  }

  Future<void> resume() async {
    await _ttsService.resume();
  }

  Future<void> updateSettings(TTSSettings newSettings) async {
    await _ttsService.updateSettings(newSettings);
    settings.value = newSettings;
  }

  Voice? getVoiceById(String voiceId) {
    return _ttsService.getVoiceById(voiceId);
  }

  List<Voice> getVoicesByLanguage(String language) {
    return _ttsService.getVoicesByLanguage(language);
  }

  Map<String, dynamic> getSpeechStats() {
    return _ttsService.getSpeechStats();
  }

  @override
  void onClose() {
    _ttsService.dispose();
    super.onClose();
  }
} 