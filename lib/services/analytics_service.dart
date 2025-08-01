import 'package:flutter/foundation.dart';
import '../config/app_config.dart';
import '../models/circle_result.dart';

class AnalyticsService {
  static const String _sessionStartEvent = 'session_start';
  static const String _circleDrawnEvent = 'circle_drawn';
  static const String _gameCompletedEvent = 'game_completed';
  static const String _perfectScoreEvent = 'perfect_score_achieved';

  static AnalyticsService? _instance;
  static AnalyticsService get instance => _instance ??= AnalyticsService._();

  AnalyticsService._();

  void initialize() {
    if (!AppConfig.analyticsEnabled) return;
    
    // Initialize your analytics service here
    // Example: Firebase Analytics, Mixpanel, etc.
    _logEvent(_sessionStartEvent, {
      'app_version': AppConfig.version,
      'platform': defaultTargetPlatform.name,
    });
  }

  void logCircleDrawn(CircleResult result, int drawTimeSeconds) {
    if (!AppConfig.analyticsEnabled) return;

    _logEvent(_circleDrawnEvent, {
      'score': result.score,
      'is_closed': result.isClosed,
      'draw_time_seconds': drawTimeSeconds,
      'score_category': _getScoreCategory(result.score),
    });

    if (result.score >= AppConfig.perfectScoreThreshold) {
      _logEvent(_perfectScoreEvent, {
        'score': result.score,
        'draw_time_seconds': drawTimeSeconds,
      });
    }
  }

  void logGameStats(Map<String, dynamic> stats) {
    if (!AppConfig.analyticsEnabled) return;

    _logEvent(_gameCompletedEvent, {
      'best_score': stats['bestScore'],
      'total_attempts': stats['attempts'],
      'total_play_time_seconds': stats['totalPlayTimeSeconds'],
      'average_score': stats['averageScore'],
    });
  }

  void logUserAction(String action, Map<String, dynamic>? parameters) {
    if (!AppConfig.analyticsEnabled) return;

    _logEvent(action, parameters ?? {});
  }

  void setUserProperty(String name, String value) {
    if (!AppConfig.analyticsEnabled) return;

    // Set user properties for analytics
    debugPrint('Analytics: Setting user property $name = $value');
  }

  void _logEvent(String eventName, Map<String, dynamic> parameters) {
    // Log to your analytics service
    // For now, just debug print in development
    if (kDebugMode) {
      debugPrint('Analytics Event: $eventName');
      debugPrint('Parameters: $parameters');
    }

    // TODO: Implement actual analytics logging
    // Example implementations:
    // - Firebase Analytics: FirebaseAnalytics.instance.logEvent(name: eventName, parameters: parameters)
    // - Mixpanel: Mixpanel.getInstance().track(eventName, parameters)
    // - Custom analytics: Your custom implementation
  }

  String _getScoreCategory(int score) {
    if (score >= AppConfig.perfectScoreThreshold) return 'perfect';
    if (score >= AppConfig.excellentScoreThreshold) return 'excellent';
    if (score >= AppConfig.goodScoreThreshold) return 'good';
    if (score >= AppConfig.decentScoreThreshold) return 'decent';
    if (score >= AppConfig.poorScoreThreshold) return 'poor';
    if (score >= AppConfig.badScoreThreshold) return 'bad';
    return 'very_bad';
  }
}