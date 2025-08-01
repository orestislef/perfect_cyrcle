import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/circle_result.dart';
import '../config/app_config.dart';
import '../constants/app_strings.dart';

class CircleEvaluator {
  static CircleResult evaluateCircle(List<Offset> points) {
    if (points.length < AppConfig.minPointsForEvaluation) {
      return CircleResult(
        score: 0,
        message: AppStrings.drawFullCircle,
        isClosed: false,
      );
    }

    final center = _calculateCenter(points);
    final avgRadius = _calculateAverageRadius(points, center);
    final radiusVariance = _calculateRadiusVariance(points, center, avgRadius);
    final isClosed = _isCircleClosed(points, avgRadius);

    final score = _calculateScore(radiusVariance, avgRadius, isClosed);
    final message = _getScoreMessage(score);

    return CircleResult(
      score: score,
      message: message,
      isClosed: isClosed,
    );
  }

  static Offset _calculateCenter(List<Offset> points) {
    double centerX = points.map((p) => p.dx).reduce((a, b) => a + b) / points.length;
    double centerY = points.map((p) => p.dy).reduce((a, b) => a + b) / points.length;
    return Offset(centerX, centerY);
  }

  static double _calculateAverageRadius(List<Offset> points, Offset center) {
    double avgRadius = 0;
    for (var point in points) {
      double distance = (point - center).distance;
      avgRadius += distance;
    }
    return avgRadius / points.length;
  }

  static double _calculateRadiusVariance(List<Offset> points, Offset center, double avgRadius) {
    double radiusVariance = 0;
    for (var point in points) {
      double distance = (point - center).distance;
      radiusVariance += math.pow(distance - avgRadius, 2);
    }
    return math.sqrt(radiusVariance / points.length);
  }

  static bool _isCircleClosed(List<Offset> points, double avgRadius) {
    Offset startPoint = points.first;
    Offset endPoint = points.last;
    double closureDistance = (endPoint - startPoint).distance;
    double maxClosureDistance = avgRadius * AppConfig.maxClosureDistanceRatio;
    return closureDistance < maxClosureDistance;
  }

  static int _calculateScore(double radiusVariance, double avgRadius, bool isClosed) {
    double maxVariance = avgRadius * AppConfig.maxVarianceRatio;
    double varianceScore = math.max(0, 1 - (radiusVariance / maxVariance));
    double closureScore = isClosed ? 1.0 : 0.5;

    int totalScore = ((varianceScore * AppConfig.varianceWeight + 
                      closureScore * AppConfig.closureWeight) * 100).round();
    return math.max(0, math.min(100, totalScore));
  }

  static String _getScoreMessage(int score) {
    if (score >= AppConfig.perfectScoreThreshold) {
      return AppStrings.perfectCircle;
    } else if (score >= AppConfig.excellentScoreThreshold) {
      return AppStrings.excellent;
    } else if (score >= AppConfig.goodScoreThreshold) {
      return AppStrings.veryGood;
    } else if (score >= AppConfig.decentScoreThreshold) {
      return AppStrings.goodAttempt;
    } else if (score >= AppConfig.poorScoreThreshold) {
      return AppStrings.notBad;
    } else if (score >= AppConfig.badScoreThreshold) {
      return AppStrings.tryAgainMessage;
    } else {
      return AppStrings.abstractArt;
    }
  }
}