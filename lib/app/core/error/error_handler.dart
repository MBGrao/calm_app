import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/interactive_feedback.dart';

// Error types
enum ErrorType {
  network,
  authentication,
  permission,
  validation,
  server,
  unknown,
  offline,
  timeout,
}

// Error severity levels
enum ErrorSeverity {
  low,
  medium,
  high,
  critical,
}

// Error model
class AppError {
  final String message;
  final String? code;
  final ErrorType type;
  final ErrorSeverity severity;
  final dynamic originalError;
  final StackTrace? stackTrace;
  final DateTime timestamp;

  AppError({
    required this.message,
    this.code,
    required this.type,
    required this.severity,
    this.originalError,
    this.stackTrace,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() {
    return 'AppError(type: $type, severity: $severity, message: $message)';
  }
}

// Error handler service
class ErrorHandler {
  static ErrorHandler? _instance;
  static ErrorHandler get instance => _instance ??= ErrorHandler._();

  ErrorHandler._();

  // Error tracking
  final List<AppError> _errorHistory = [];
  bool _isOffline = false;
  bool _isInitialized = false;
  VoidCallback? _retryLastOperation;

  // Initialize error handler
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Check network connectivity
      await _checkConnectivity();
      
      // Set up error listeners
      _setupErrorListeners();
      
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error handler initialization failed: $e');
    }
  }

  void _setupErrorListeners() {
    // Listen for Flutter framework errors - only handle non-framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      // Don't handle framework-level errors like overflow or navigation issues
      if (details.exception.toString().contains('RenderFlex overflowed') ||
          details.exception.toString().contains('navigator.dart') ||
          details.exception.toString().contains('Build scheduled during frame')) {
        // Let Flutter handle these framework errors
        FlutterError.presentError(details);
        return;
      }
      
      _handleError(
        AppError(
          message: details.exception.toString(),
          type: ErrorType.unknown,
          severity: ErrorSeverity.high,
          originalError: details.exception,
          stackTrace: details.stack,
        ),
      );
    };
  }

  Future<void> _checkConnectivity() async {
    // Simulate connectivity check
    await Future.delayed(const Duration(milliseconds: 100));
    _isOffline = false; // In real app, check actual connectivity
  }

  // Handle errors
  void handleError(
    dynamic error, {
    ErrorType type = ErrorType.unknown,
    ErrorSeverity severity = ErrorSeverity.medium,
    String? customMessage,
    String? code,
  }) {
    final appError = AppError(
      message: customMessage ?? error.toString(),
      code: code,
      type: type,
      severity: severity,
      originalError: error,
      stackTrace: error is Error ? error.stackTrace : null,
    );

    _handleError(appError);
  }

  void _handleError(AppError error) {
    // Log error
    _logError(error);
    
    // Add to history
    _errorHistory.add(error);
    
    // Limit history size
    if (_errorHistory.length > 100) {
      _errorHistory.removeAt(0);
    }

    // Handle based on severity
    switch (error.severity) {
      case ErrorSeverity.low:
        _handleLowSeverityError(error);
        break;
      case ErrorSeverity.medium:
        _handleMediumSeverityError(error);
        break;
      case ErrorSeverity.high:
        _handleHighSeverityError(error);
        break;
      case ErrorSeverity.critical:
        _handleCriticalError(error);
        break;
    }
  }

  void _logError(AppError error) {
    debugPrint('''
=== ERROR LOG ===
Type: ${error.type}
Severity: ${error.severity}
Message: ${error.message}
Code: ${error.code}
Timestamp: ${error.timestamp}
Original Error: ${error.originalError}
================
''');
  }

  void _handleLowSeverityError(AppError error) {
    // Just log, no user notification
    debugPrint('Low severity error: ${error.message}');
  }

  void _handleMediumSeverityError(AppError error) {
    // Show snackbar notification
    FeedbackToast.showError(error.message);
  }

  void _handleHighSeverityError(AppError error) {
    // Show dialog with retry option
    _showErrorDialog(error, showRetry: true);
  }

  void _handleCriticalError(AppError error) {
    // Show critical error dialog
    _showErrorDialog(error, showRetry: true, isCritical: true);
  }

  void _showErrorDialog(AppError error, {
    bool showRetry = false,
    bool isCritical = false,
  }) {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(
              isCritical ? Icons.error : Icons.warning,
              color: isCritical ? Colors.red : Colors.orange,
            ),
            SizedBox(width: 8),
            Text(
              isCritical ? 'Critical Error' : 'Error',
              style: TextStyle(
                color: isCritical ? Colors.red : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(error.message),
            if (error.code != null) ...[
              SizedBox(height: 8),
              Text(
                'Error Code: ${error.code}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (showRetry)
            TextButton(
              onPressed: () {
                Get.back();
                // Trigger retry logic
                _retryLastOperation?.call();
              },
              child: const Text('Retry'),
            ),
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }



  // Check if offline
  bool get isOffline => _isOffline;

  // Get error history
  List<AppError> get errorHistory => List.from(_errorHistory);

  // Clear error history
  void clearErrorHistory() {
    _errorHistory.clear();
  }

  // Get recent errors
  List<AppError> getRecentErrors(int count) {
    return _errorHistory.take(count).toList();
  }

  // Check if has recent errors
  bool hasRecentErrors(Duration duration) {
    final cutoff = DateTime.now().subtract(duration);
    return _errorHistory.any((error) => error.timestamp.isAfter(cutoff));
  }

  // Get error statistics
  Map<String, dynamic> getErrorStatistics() {
    final now = DateTime.now();
    final last24h = now.subtract(const Duration(hours: 24));
    final last7d = now.subtract(const Duration(days: 7));

    final errors24h = _errorHistory.where((e) => e.timestamp.isAfter(last24h)).length;
    final errors7d = _errorHistory.where((e) => e.timestamp.isAfter(last7d)).length;

    final typeCounts = <ErrorType, int>{};
    final severityCounts = <ErrorSeverity, int>{};

    for (final error in _errorHistory) {
      typeCounts[error.type] = (typeCounts[error.type] ?? 0) + 1;
      severityCounts[error.severity] = (severityCounts[error.severity] ?? 0) + 1;
    }

    return {
      'totalErrors': _errorHistory.length,
      'errors24h': errors24h,
      'errors7d': errors7d,
      'typeCounts': typeCounts.map((k, v) => MapEntry(k.toString(), v)),
      'severityCounts': severityCounts.map((k, v) => MapEntry(k.toString(), v)),
      'isOffline': _isOffline,
    };
  }
}

// Loading state manager
class LoadingStateManager {
  static LoadingStateManager? _instance;
  static LoadingStateManager get instance => _instance ??= LoadingStateManager._();

  LoadingStateManager._();

  final Map<String, bool> _loadingStates = {};
  final Map<String, String> _loadingMessages = {};

  // Set loading state
  void setLoading(String key, bool isLoading, {String? message}) {
    _loadingStates[key] = isLoading;
    if (message != null) {
      _loadingMessages[key] = message;
    } else {
      _loadingMessages.remove(key);
    }
  }

  // Get loading state
  bool isLoading(String key) {
    return _loadingStates[key] ?? false;
  }

  // Get loading message
  String? getLoadingMessage(String key) {
    return _loadingMessages[key];
  }

  // Clear loading state
  void clearLoading(String key) {
    _loadingStates.remove(key);
    _loadingMessages.remove(key);
  }

  // Clear all loading states
  void clearAllLoading() {
    _loadingStates.clear();
    _loadingMessages.clear();
  }

  // Get all loading states
  Map<String, bool> get allLoadingStates => Map.from(_loadingStates);

  // Check if any loading
  bool get hasAnyLoading => _loadingStates.values.any((loading) => loading);
}

// Offline functionality manager
class OfflineManager {
  static OfflineManager? _instance;
  static OfflineManager get instance => _instance ??= OfflineManager._();

  OfflineManager._();

  bool _isOffline = false;
  final List<Map<String, dynamic>> _pendingOperations = [];

  // Check connectivity
  Future<bool> checkConnectivity() async {
    try {
      // Simulate connectivity check
      await Future.delayed(const Duration(milliseconds: 100));
      _isOffline = false;
      return true;
    } catch (e) {
      _isOffline = true;
      return false;
    }
  }

  // Get offline status
  bool get isOffline => _isOffline;

  // Add pending operation
  void addPendingOperation(String operation, Map<String, dynamic> data) {
    _pendingOperations.add({
      'operation': operation,
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  // Get pending operations
  List<Map<String, dynamic>> get pendingOperations => List.from(_pendingOperations);

  // Clear pending operations
  void clearPendingOperations() {
    _pendingOperations.clear();
  }

  // Process pending operations when online
  Future<void> processPendingOperations() async {
    if (_isOffline || _pendingOperations.isEmpty) return;

    final operations = List.from(_pendingOperations);
    _pendingOperations.clear();

    for (final operation in operations) {
      try {
        // Process operation based on type
        await _processOperation(operation);
      } catch (e) {
        // Re-add failed operations
        _pendingOperations.add(operation);
        ErrorHandler.instance.handleError(e, type: ErrorType.network);
      }
    }
  }

  Future<void> _processOperation(Map<String, dynamic> operation) async {
    // Simulate processing
    await Future.delayed(const Duration(milliseconds: 200));
    debugPrint('Processed operation: ${operation['operation']}');
  }
}

// Graceful degradation manager
class GracefulDegradationManager {
  static GracefulDegradationManager? _instance;
  static GracefulDegradationManager get instance => _instance ??= GracefulDegradationManager._();

  GracefulDegradationManager._();

  final Map<String, bool> _featureAvailability = {};
  final Map<String, dynamic> _fallbackData = {};

  // Set feature availability
  void setFeatureAvailable(String feature, bool available) {
    _featureAvailability[feature] = available;
  }

  // Check if feature is available
  bool isFeatureAvailable(String feature) {
    return _featureAvailability[feature] ?? true;
  }

  // Set fallback data
  void setFallbackData(String key, dynamic data) {
    _fallbackData[key] = data;
  }

  // Get fallback data
  dynamic getFallbackData(String key) {
    return _fallbackData[key];
  }

  // Get all available features
  List<String> get availableFeatures {
    return _featureAvailability.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
  }

  // Get unavailable features
  List<String> get unavailableFeatures {
    return _featureAvailability.entries
        .where((entry) => !entry.value)
        .map((entry) => entry.key)
        .toList();
  }
}

// Error handling mixin for widgets
mixin ErrorHandlingMixin<T extends StatefulWidget> on State<T> {
  final ErrorHandler _errorHandler = ErrorHandler.instance;
  final LoadingStateManager _loadingManager = LoadingStateManager.instance;
  final OfflineManager _offlineManager = OfflineManager.instance;

  // Handle errors with automatic UI updates
  void handleError(
    dynamic error, {
    ErrorType type = ErrorType.unknown,
    ErrorSeverity severity = ErrorSeverity.medium,
    String? customMessage,
    String? code,
    VoidCallback? onRetry,
  }) {
    _errorHandler.handleError(
      error,
      type: type,
      severity: severity,
      customMessage: customMessage,
      code: code,
    );

    if (onRetry != null) {
      // Store retry callback for later use
      _errorHandler._retryLastOperation = onRetry;
    }
  }

  // Set loading state with automatic UI updates
  void setLoading(String key, bool isLoading, {String? message}) {
    _loadingManager.setLoading(key, isLoading, message: message);
    if (mounted) {
      setState(() {});
    }
  }

  // Check if loading
  bool isLoading(String key) {
    return _loadingManager.isLoading(key);
  }

  // Get loading message
  String? getLoadingMessage(String key) {
    return _loadingManager.getLoadingMessage(key);
  }

  // Check offline status
  bool get isOffline => _offlineManager.isOffline;

  // Safe async operation with error handling
  Future<T?> safeAsync<T>(
    Future<T> Function() operation, {
    String? loadingKey,
    String? loadingMessage,
    ErrorType errorType = ErrorType.unknown,
    ErrorSeverity errorSeverity = ErrorSeverity.medium,
    T? fallbackValue,
  }) async {
    if (loadingKey != null) {
      setLoading(loadingKey, true, message: loadingMessage);
    }

    try {
      final result = await operation();
      if (loadingKey != null) {
        setLoading(loadingKey, false);
      }
      return result;
    } catch (e) {
      if (loadingKey != null) {
        setLoading(loadingKey, false);
      }
      handleError(
        e,
        type: errorType,
        severity: errorSeverity,
      );
      return fallbackValue;
    }
  }
} 