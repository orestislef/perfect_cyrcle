import 'dart:math' as dart_math;

import 'package:flutter_test/flutter_test.dart';
import 'package:perfect_cyrcle/services/circle_evaluator.dart';
import 'package:perfect_cyrcle/config/app_config.dart';

void main() {
  group('CircleEvaluator', () {
    test('should return score 0 for insufficient points', () {
      // Arrange
      final points = [
        const Offset(100, 100),
        const Offset(102, 100),
        const Offset(104, 100),
      ];

      // Act
      final result = CircleEvaluator.evaluateCircle(points);

      // Assert
      expect(result.score, equals(0));
      expect(result.isClosed, isFalse);
    });

    test('should return high score for perfect circle', () {
      // Arrange - Generate points for a perfect circle
      final points = <Offset>[];
      const center = Offset(200, 200);
      const radius = 100.0;
      
      for (int i = 0; i < 50; i++) {
        final angle = (i * 2 * 3.14159) / 50;
        final x = center.dx + radius * 0.999 * dart_math.cos(angle);
        final y = center.dy + radius * 0.999 * dart_math.sin(angle);
        points.add(Offset(x, y));
      }

      // Act
      final result = CircleEvaluator.evaluateCircle(points);

      // Assert
      expect(result.score, greaterThan(AppConfig.excellentScoreThreshold));
      expect(result.isClosed, isTrue);
    });

    test('should return moderate score for square shape', () {
      // Arrange - Generate points for a square
      final points = [
        const Offset(100, 100),
        const Offset(200, 100),
        const Offset(200, 200),
        const Offset(100, 200),
        const Offset(100, 100),
        const Offset(100, 100), // Add more points to meet minimum
        const Offset(200, 100),
        const Offset(200, 200),
        const Offset(100, 200),
        const Offset(100, 100),
        const Offset(100, 100),
      ];

      // Act
      final result = CircleEvaluator.evaluateCircle(points);

      // Assert - Square gets moderate score due to closure but poor circularity
      expect(result.score, lessThan(AppConfig.excellentScoreThreshold));
      expect(result.score, greaterThan(0));
    });

    test('should detect closed vs open shapes', () {
      // Arrange - Open shape (arc)
      final openPoints = <Offset>[];
      for (int i = 0; i < 20; i++) {
        final angle = (i * 3.14159) / 20; // Half circle
        final x = 200 + 100 * dart_math.cos(angle);
        final y = 200 + 100 * dart_math.sin(angle);
        openPoints.add(Offset(x, y));
      }

      // Arrange - Closed shape (complete circle)
      final closedPoints = <Offset>[];
      for (int i = 0; i < 20; i++) {
        final angle = (i * 2 * 3.14159) / 20; // Full circle
        final x = 200 + 100 * dart_math.cos(angle);
        final y = 200 + 100 * dart_math.sin(angle);
        closedPoints.add(Offset(x, y));
      }

      // Act
      final openResult = CircleEvaluator.evaluateCircle(openPoints);
      final closedResult = CircleEvaluator.evaluateCircle(closedPoints);

      // Assert - Closed circles score higher than open arcs
      expect(closedResult.score, greaterThan(openResult.score));
    });
  });
}