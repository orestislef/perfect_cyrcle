class AppConfig {
  static const String appName = 'Perfect Circle';
  static const String version = '1.0.0';
  
  // Game Configuration
  static const int minPointsForEvaluation = 10;
  static const double maxClosureDistanceRatio = 0.2;
  static const double maxVarianceRatio = 0.5;
  static const double varianceWeight = 0.6;
  static const double closureWeight = 0.4;
  
  // UI Configuration
  static const double gridSize = 40.0;
  static const double strokeWidth = 3.0;
  static const double overlayOpacity = 0.95;
  
  // Score thresholds
  static const int perfectScoreThreshold = 95;
  static const int excellentScoreThreshold = 85;
  static const int goodScoreThreshold = 75;
  static const int decentScoreThreshold = 60;
  static const int poorScoreThreshold = 40;
  static const int badScoreThreshold = 20;
  
  // Accessibility
  static const double minTouchTargetSize = 44.0;
  static const Duration hapticFeedbackDuration = Duration(milliseconds: 50);
  
  // Performance
  static const int maxPointsInPath = 1000;
  static const Duration debounceTime = Duration(milliseconds: 16); // ~60fps
  
  // Analytics (if enabled)
  static const bool analyticsEnabled = false;
  static const bool crashReportingEnabled = false;
}