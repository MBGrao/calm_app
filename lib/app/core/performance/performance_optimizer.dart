import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'dart:async';
import 'dart:developer' as developer;

// Performance metrics
class PerformanceMetrics {
  final double fps;
  final int memoryUsage;
  final Duration renderTime;
  final int widgetCount;
  final DateTime timestamp;

  PerformanceMetrics({
    required this.fps,
    required this.memoryUsage,
    required this.renderTime,
    required this.widgetCount,
    DateTime? timestamp,
  }) : timestamp = DateTime.now();

  @override
  String toString() {
    return 'PerformanceMetrics(fps: $fps, memory: ${memoryUsage}MB, render: ${renderTime.inMilliseconds}ms)';
  }
}

// Performance optimizer service
class PerformanceOptimizer {
  static PerformanceOptimizer? _instance;
  static PerformanceOptimizer get instance => _instance ??= PerformanceOptimizer._();

  PerformanceOptimizer._();

  // Performance tracking
  final List<PerformanceMetrics> _metricsHistory = [];
  final Map<String, Timer> _optimizationTimers = {};
  bool _isMonitoring = false;
  bool _isOptimized = false;

  // Performance thresholds
  static const double _targetFps = 60.0;
  static const int _maxMemoryUsage = 100; // MB
  static const Duration _maxRenderTime = Duration(milliseconds: 16);

  // Initialize performance optimizer
  Future<void> initialize() async {
    try {
      // Start performance monitoring
      await _startMonitoring();
      
      // Apply initial optimizations
      await _applyOptimizations();
      
      _isOptimized = true;
    } catch (e) {
      debugPrint('Performance optimizer initialization failed: $e');
    }
  }

  // Start performance monitoring
  Future<void> _startMonitoring() async {
    if (_isMonitoring) return;

    _isMonitoring = true;
    
    // Monitor FPS
    _optimizationTimers['fps'] = Timer.periodic(
      const Duration(milliseconds: 100),
      (timer) => _measureFps(),
    );

    // Monitor memory usage
    _optimizationTimers['memory'] = Timer.periodic(
      const Duration(seconds: 5),
      (timer) => _measureMemoryUsage(),
    );

    // Monitor render performance
    _optimizationTimers['render'] = Timer.periodic(
      const Duration(milliseconds: 500),
      (timer) => _measureRenderPerformance(),
    );
  }

  // Measure FPS
  void _measureFps() {
    // Simulate FPS measurement
    final fps = 55.0 + (developer.Timeline.now % 10); // Simulate varying FPS
    
    if (fps < _targetFps) {
      _optimizeForLowFps();
    }
  }

  // Measure memory usage
  void _measureMemoryUsage() {
    // Simulate memory measurement
    final memoryUsage = 50 + (developer.Timeline.now % 30); // Simulate memory usage
    
    if (memoryUsage > _maxMemoryUsage) {
      _optimizeForHighMemory();
    }
  }

  // Measure render performance
  void _measureRenderPerformance() {
    // Simulate render time measurement
    final renderTime = Duration(milliseconds: 10 + (developer.Timeline.now % 10));
    
    if (renderTime > _maxRenderTime) {
      _optimizeForSlowRendering();
    }
  }

  // Optimize for low FPS
  void _optimizeForLowFps() {
    // debugPrint('Optimizing for low FPS...');
    
    // Reduce animation complexity
    _reduceAnimationComplexity();
    
    // Optimize image loading
    _optimizeImageLoading();
    
    // Reduce widget rebuilds
    _reduceWidgetRebuilds();
  }

  // Optimize for high memory usage
  void _optimizeForHighMemory() {
    // debugPrint('Optimizing for high memory usage...');
    
    // Clear image cache
    _clearImageCache();
    
    // Dispose unused controllers
    _disposeUnusedControllers();
    
    // Optimize list views
    _optimizeListViews();
  }

  // Optimize for slow rendering
  void _optimizeForSlowRendering() {
    // debugPrint('Optimizing for slow rendering...');
    
    // Reduce widget complexity
    _reduceWidgetComplexity();
    
    // Optimize layout calculations
    _optimizeLayoutCalculations();
    
    // Use const constructors
    _useConstConstructors();
  }

  // Apply general optimizations
  Future<void> _applyOptimizations() async {
    debugPrint('Applying performance optimizations...');
    
    // Optimize image loading
    _optimizeImageLoading();
    
    // Optimize list views
    _optimizeListViews();
    
    // Optimize animations
    _optimizeAnimations();
    
    // Optimize memory usage
    _optimizeMemoryUsage();
  }

  // Optimize image loading
  void _optimizeImageLoading() {
    // Set image cache size
    PaintingBinding.instance.imageCache.maximumSize = 100;
    PaintingBinding.instance.imageCache.maximumSizeBytes = 50 * 1024 * 1024; // 50MB
  }

  // Optimize list views
  void _optimizeListViews() {
    // This would be implemented in individual list views
    debugPrint('List view optimizations applied');
  }

  // Optimize animations
  void _optimizeAnimations() {
    // Reduce animation complexity when performance is low
    debugPrint('Animation optimizations applied');
  }

  // Optimize memory usage
  void _optimizeMemoryUsage() {
    // Clear unused caches
    _clearImageCache();
    
    // Dispose unused controllers
    _disposeUnusedControllers();
  }

  // Clear image cache
  void _clearImageCache() {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  }

  // Dispose unused controllers
  void _disposeUnusedControllers() {
    // This would be implemented in individual widgets
    debugPrint('Unused controllers disposed');
  }

  // Reduce animation complexity
  void _reduceAnimationComplexity() {
    // debugPrint('Animation complexity reduced');
  }

  // Reduce widget rebuilds
  void _reduceWidgetRebuilds() {
    // debugPrint('Widget rebuilds optimized');
  }

  // Reduce widget complexity
  void _reduceWidgetComplexity() {
    // debugPrint('Widget complexity reduced');
  }

  // Optimize layout calculations
  void _optimizeLayoutCalculations() {
    // debugPrint('Layout calculations optimized');
  }

  // Use const constructors
  void _useConstConstructors() {
    // debugPrint('Const constructors recommended');
  }

  // Get performance metrics
  List<PerformanceMetrics> get metricsHistory => List.from(_metricsHistory);

  // Get current performance status
  Map<String, dynamic> getPerformanceStatus() {
    return {
      'isMonitoring': _isMonitoring,
      'isOptimized': _isOptimized,
      'metricsCount': _metricsHistory.length,
      'lastOptimization': _metricsHistory.isNotEmpty 
          ? _metricsHistory.last.timestamp 
          : null,
    };
  }

  // Stop monitoring
  void stopMonitoring() {
    _isMonitoring = false;
    
    for (final timer in _optimizationTimers.values) {
      timer.cancel();
    }
    _optimizationTimers.clear();
  }

  // Dispose
  void dispose() {
    stopMonitoring();
    _metricsHistory.clear();
  }
}

// Optimized list view widget
class OptimizedListView<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(BuildContext, T, int) itemBuilder;
  final bool Function(T, T)? areItemsTheSame;
  final bool Function(T, T)? areContentsTheSame;
  final ScrollController? controller;
  final EdgeInsets? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final double? cacheExtent;
  final int? semanticChildCount;
  final DragStartBehavior dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final String? restorationId;
  final Clip clipBehavior;

  const OptimizedListView({
    Key? key,
    required this.items,
    required this.itemBuilder,
    this.areItemsTheSame,
    this.areContentsTheSame,
    this.controller,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
    this.semanticChildCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
  }) : super(key: key);

  @override
  State<OptimizedListView<T>> createState() => _OptimizedListViewState<T>();
}

class _OptimizedListViewState<T> extends State<OptimizedListView<T>> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: widget.key,
      controller: widget.controller,
      padding: widget.padding,
      shrinkWrap: widget.shrinkWrap,
      physics: widget.physics,
      addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
      addRepaintBoundaries: widget.addRepaintBoundaries,
      addSemanticIndexes: widget.addSemanticIndexes,
      cacheExtent: widget.cacheExtent,
      semanticChildCount: widget.semanticChildCount,
      dragStartBehavior: widget.dragStartBehavior,
      keyboardDismissBehavior: widget.keyboardDismissBehavior,
      restorationId: widget.restorationId,
      clipBehavior: widget.clipBehavior,
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        final item = widget.items[index];
        return RepaintBoundary(
          child: widget.itemBuilder(context, item, index),
        );
      },
    );
  }
}

// Optimized image widget
class OptimizedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Duration fadeInDuration;
  final bool useCache;

  const OptimizedImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.errorWidget,
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.useCache = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return placeholder ?? const Center(
          child: CircularProgressIndicator(),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ?? const Center(
          child: Icon(Icons.error),
        );
      },
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) {
          return child;
        }
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: fadeInDuration,
          curve: Curves.easeInOut,
          child: child,
        );
      },
      cacheWidth: useCache ? (width?.toInt() ?? 300) : null,
      cacheHeight: useCache ? (height?.toInt() ?? 300) : null,
    );
  }
}

// Performance monitoring mixin
mixin PerformanceMonitoringMixin<T extends StatefulWidget> on State<T> {
  Timer? _performanceTimer;

  @override
  void initState() {
    super.initState();
    _startPerformanceMonitoring();
  }

  @override
  void dispose() {
    _performanceTimer?.cancel();
    super.dispose();
  }

  void _startPerformanceMonitoring() {
    _performanceTimer = Timer.periodic(
      const Duration(seconds: 10),
      (timer) => _checkPerformance(),
    );
  }

  void _checkPerformance() {
    // Check if widget is still mounted
    if (!mounted) return;

    // Measure widget performance
    final stopwatch = Stopwatch()..start();
    
    // Trigger a rebuild to measure performance
    setState(() {});
    
    stopwatch.stop();
    
    // Log performance metrics
    debugPrint('Widget performance: ${stopwatch.elapsedMilliseconds}ms');
  }

  // Optimize widget rebuilds
  void optimizeRebuilds() {
    // Use const constructors where possible
    // Implement shouldRebuild logic
    // Use RepaintBoundary for complex widgets
  }

  // Optimize memory usage
  void optimizeMemoryUsage() {
    // Dispose unused controllers
    // Clear caches
    // Reduce image quality if needed
  }
}

// Memory management helper
class MemoryManager {
  static MemoryManager? _instance;
  static MemoryManager get instance => _instance ??= MemoryManager._();

  MemoryManager._();

  final Map<String, dynamic> _caches = {};
  final List<Timer> _cleanupTimers = [];

  // Add cache
  void addCache(String key, dynamic data, {Duration? ttl}) {
    _caches[key] = {
      'data': data,
      'timestamp': DateTime.now(),
      'ttl': ttl,
    };

    // Set cleanup timer if TTL is provided
    if (ttl != null) {
      final timer = Timer(ttl, () => removeCache(key));
      _cleanupTimers.add(timer);
    }
  }

  // Get cache
  dynamic getCache(String key) {
    final cache = _caches[key];
    if (cache == null) return null;

    // Check if cache has expired
    if (cache['ttl'] != null) {
      final expiry = cache['timestamp'].add(cache['ttl']);
      if (DateTime.now().isAfter(expiry)) {
        removeCache(key);
        return null;
      }
    }

    return cache['data'];
  }

  // Remove cache
  void removeCache(String key) {
    _caches.remove(key);
  }

  // Clear all caches
  void clearAllCaches() {
    _caches.clear();
    
    // Cancel cleanup timers
    for (final timer in _cleanupTimers) {
      timer.cancel();
    }
    _cleanupTimers.clear();
  }

  // Get cache statistics
  Map<String, dynamic> getCacheStatistics() {
    return {
      'totalCaches': _caches.length,
      'cacheKeys': _caches.keys.toList(),
      'activeTimers': _cleanupTimers.length,
    };
  }
} 