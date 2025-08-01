import 'package:flutter/foundation.dart';
import '../config/app_config.dart';

class CrashReportingService {
  static CrashReportingService? _instance;
  static CrashReportingService get instance => _instance ??= CrashReportingService._();

  CrashReportingService._();

  void initialize() {
    if (!AppConfig.crashReportingEnabled) return;

    // Initialize crash reporting service
    // Example: Firebase Crashlytics, Sentry, Bugsnag, etc.
    
    // Set up global error handling
    FlutterError.onError = (FlutterErrorDetails details) {
      recordFlutterError(details);
      // Also print to console in debug mode
      if (kDebugMode) {
        FlutterError.presentError(details);
      }
    };

    // Handle platform-specific errors
    PlatformDispatcher.instance.onError = (error, stack) {
      recordError(error, stack);
      return true;
    };
  }

  void recordError(Object error, StackTrace stackTrace, {
    String? reason,
    Map<String, dynamic>? customData,
    bool fatal = false,
  }) {
    if (!AppConfig.crashReportingEnabled) return;

    if (kDebugMode) {
      debugPrint('Crash Report: $error');
      debugPrint('Stack Trace: $stackTrace');
      debugPrint('Reason: $reason');
      debugPrint('Custom Data: $customData');
      debugPrint('Fatal: $fatal');
    }

    // TODO: Implement actual crash reporting
    // Examples:
    // - Firebase Crashlytics: FirebaseCrashlytics.instance.recordError(error, stackTrace, reason: reason, information: customData, fatal: fatal)
    // - Sentry: Sentry.captureException(error, stackTrace: stackTrace, withScope: (scope) => scope.setContexts('custom', customData))
  }

  void recordFlutterError(FlutterErrorDetails details) {
    if (!AppConfig.crashReportingEnabled) return;

    recordError(
      details.exception,
      details.stack ?? StackTrace.current,
      reason: details.context?.toString(),
      customData: {
        'library': details.library,
        'context': details.context?.toString(),
        'silent': details.silent,
      },
      fatal: false, // FlutterErrorDetails doesn't have fatal property
    );
  }

  void setUserIdentifier(String userId) {
    if (!AppConfig.crashReportingEnabled) return;

    if (kDebugMode) {
      debugPrint('Crash Reporting: Setting user ID: $userId');
    }

    // TODO: Set user identifier for crash reporting
    // Examples:
    // - Firebase Crashlytics: FirebaseCrashlytics.instance.setUserIdentifier(userId)
    // - Sentry: Sentry.configureScope((scope) => scope.user = SentryUser(id: userId))
  }

  void setCustomKey(String key, dynamic value) {
    if (!AppConfig.crashReportingEnabled) return;

    if (kDebugMode) {
      debugPrint('Crash Reporting: Setting custom key: $key = $value');
    }

    // TODO: Set custom keys for crash reporting
    // Examples:
    // - Firebase Crashlytics: FirebaseCrashlytics.instance.setCustomKey(key, value)
    // - Sentry: Sentry.configureScope((scope) => scope.setTag(key, value.toString()))
  }

  void logMessage(String message, {String? level}) {
    if (!AppConfig.crashReportingEnabled) return;

    if (kDebugMode) {
      debugPrint('Crash Reporting Log [$level]: $message');
    }

    // TODO: Log messages to crash reporting service
    // Examples:
    // - Firebase Crashlytics: FirebaseCrashlytics.instance.log(message)
    // - Sentry: Sentry.addBreadcrumb(Breadcrumb(message: message, level: SentryLevel.info))
  }
}