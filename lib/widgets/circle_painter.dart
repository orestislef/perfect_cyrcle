import 'package:flutter/material.dart';
import '../models/circle_result.dart';
import '../config/app_config.dart';
import '../constants/app_strings.dart';

class CirclePainter extends CustomPainter {
  final List<Offset> points;
  final bool showGrid;
  final CircleResult? result;
  final int bestScore;
  final int attempts;
  final bool isDark;
  final ThemeData theme;

  CirclePainter({
    required this.points,
    required this.showGrid,
    this.result,
    required this.bestScore,
    required this.attempts,
    required this.isDark,
    required this.theme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (showGrid) {
      _drawGrid(canvas, size);
    }

    if (points.length > 1) {
      _drawCircle(canvas);
    }

    if (result != null) {
      _drawResultOverlay(canvas, size);
    }
  }

  void _drawGrid(Canvas canvas, Size size) {
    Paint gridPaint = Paint()
      ..color = theme.dividerColor
      ..strokeWidth = 1;

    for (double x = 0; x < size.width; x += AppConfig.gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += AppConfig.gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  void _drawCircle(Canvas canvas) {
    Paint linePaint = Paint()
      ..color = isDark ? Colors.white : Colors.black
      ..strokeWidth = AppConfig.strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    Path path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, linePaint);
  }

  void _drawResultOverlay(Canvas canvas, Size size) {
    // Draw semi-transparent background
    Paint overlayPaint = Paint()
      ..color = (isDark ? Colors.black : Colors.white).withValues(alpha: 0.92);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), overlayPaint);

    // Use high contrast colors for better visibility
    final textColor = isDark ? Colors.white : Colors.black;
    final shadowColor = isDark ? Colors.black : Colors.white;

    _drawScore(canvas, size, textColor, shadowColor);
    _drawMessage(canvas, size, textColor, shadowColor);
    _drawStats(canvas, size, textColor, shadowColor);
    _drawHint(canvas, size, textColor, shadowColor);
  }

  void _drawScore(Canvas canvas, Size size, Color textColor, Color shadowColor) {
    final scoreText = '${result!.score}/100';
    
    // Draw text shadow for better visibility
    TextPainter shadowPainter = TextPainter(
      text: TextSpan(
        text: scoreText,
        style: TextStyle(
          color: shadowColor.withValues(alpha: 0.3),
          fontSize: 72,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    shadowPainter.layout();
    shadowPainter.paint(
      canvas,
      Offset(
        (size.width - shadowPainter.width) / 2 + 2,
        size.height / 2 - 50 - shadowPainter.height / 2 + 2,
      ),
    );
    
    // Draw main text
    TextPainter scorePainter = TextPainter(
      text: TextSpan(
        text: scoreText,
        style: TextStyle(
          color: textColor,
          fontSize: 72,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    scorePainter.layout();
    scorePainter.paint(
      canvas,
      Offset(
        (size.width - scorePainter.width) / 2,
        size.height / 2 - 50 - scorePainter.height / 2,
      ),
    );
  }

  void _drawMessage(Canvas canvas, Size size, Color textColor, Color shadowColor) {
    // Draw shadow
    TextPainter shadowPainter = TextPainter(
      text: TextSpan(
        text: result!.message,
        style: TextStyle(
          color: shadowColor.withValues(alpha: 0.3),
          fontSize: 24,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    shadowPainter.layout(minWidth: 0, maxWidth: size.width - 40);
    shadowPainter.paint(
      canvas,
      Offset(
        (size.width - shadowPainter.width) / 2 + 1,
        size.height / 2 + 30 - shadowPainter.height / 2 + 1,
      ),
    );
    
    // Draw main text
    TextPainter messagePainter = TextPainter(
      text: TextSpan(
        text: result!.message,
        style: TextStyle(color: textColor, fontSize: 24),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    messagePainter.layout(minWidth: 0, maxWidth: size.width - 40);
    messagePainter.paint(
      canvas,
      Offset(
        (size.width - messagePainter.width) / 2,
        size.height / 2 + 30 - messagePainter.height / 2,
      ),
    );
  }

  void _drawStats(Canvas canvas, Size size, Color textColor, Color shadowColor) {
    final statsText = '${AppStrings.bestScore}: $bestScore | ${AppStrings.attempts}: $attempts';
    
    // Draw shadow
    TextPainter shadowPainter = TextPainter(
      text: TextSpan(
        text: statsText,
        style: TextStyle(
          color: shadowColor.withValues(alpha: 0.3),
          fontSize: 18,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    shadowPainter.layout();
    shadowPainter.paint(
      canvas,
      Offset(
        (size.width - shadowPainter.width) / 2 + 1,
        size.height / 2 + 70 - shadowPainter.height / 2 + 1,
      ),
    );
    
    // Draw main text
    TextPainter statsPainter = TextPainter(
      text: TextSpan(
        text: statsText,
        style: TextStyle(color: textColor.withValues(alpha: .8), fontSize: 18),
      ),
      textDirection: TextDirection.ltr,
    );
    statsPainter.layout();
    statsPainter.paint(
      canvas,
      Offset(
        (size.width - statsPainter.width) / 2,
        size.height / 2 + 70 - statsPainter.height / 2,
      ),
    );
  }

  void _drawHint(Canvas canvas, Size size, Color textColor, Color shadowColor) {
    const hintText = AppStrings.tapAnywhereToRedraw;
    
    // Draw shadow
    TextPainter shadowPainter = TextPainter(
      text: TextSpan(
        text: hintText,
        style: TextStyle(
          color: shadowColor.withValues(alpha: 0.2),
          fontSize: 14,
          fontStyle: FontStyle.italic,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    shadowPainter.layout();
    shadowPainter.paint(
      canvas,
      Offset(
        (size.width - shadowPainter.width) / 2 + 1,
        size.height / 2 + 110 - shadowPainter.height / 2 + 1,
      ),
    );
    
    // Draw main text
    TextPainter hintPainter = TextPainter(
      text: TextSpan(
        text: hintText,
        style: TextStyle(
          color: textColor.withValues(alpha: .5),
          fontSize: 14,
          fontStyle: FontStyle.italic,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    hintPainter.layout();
    hintPainter.paint(
      canvas,
      Offset(
        (size.width - hintPainter.width) / 2,
        size.height / 2 + 110 - hintPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
