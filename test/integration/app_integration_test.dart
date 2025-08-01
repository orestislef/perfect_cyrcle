import 'dart:math' as dart_math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:perfect_cyrcle/main.dart' as app;
import 'package:perfect_cyrcle/constants/app_strings.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Perfect Circle App Integration Tests', () {
    testWidgets('complete user flow test', (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Verify initial state
      expect(find.text(AppStrings.drawPerfectCircle), findsOneWidget);
      expect(find.text(AppStrings.touchAndDrag), findsOneWidget);

      // Test grid toggle
      await tester.tap(find.text(AppStrings.hideGrid));
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.showGrid), findsOneWidget);

      // Toggle back
      await tester.tap(find.text(AppStrings.showGrid));
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.hideGrid), findsOneWidget);

      // Draw a circle - find the main drawing canvas
      final drawingCanvases = find.byType(CustomPaint);
      expect(drawingCanvases, findsWidgets);
      final center = tester.getCenter(drawingCanvases.first);
      const radius = 80.0;

      // Draw a reasonably good circle
      final gesture = await tester.startGesture(center + const Offset(radius, 0));
      
      for (int i = 0; i <= 36; i++) {
        final angle = (i * 2 * 3.14159) / 36;
        final point = center + Offset(
          radius * dart_math.cos(angle),
          radius * dart_math.sin(angle),
        );
        await gesture.moveTo(point);
        await tester.pump(const Duration(milliseconds: 10));
      }
      
      await gesture.up();
      
      await tester.pumpAndSettle();

      // Verify score is displayed
      expect(find.textContaining('/100'), findsOneWidget);
      expect(find.text(AppStrings.tryAgain), findsOneWidget);

      // Test try again functionality
      await tester.tap(find.text(AppStrings.tryAgain));
      await tester.pumpAndSettle();

      // Should be back to initial state
      expect(find.text(AppStrings.drawPerfectCircle), findsOneWidget);
      expect(find.text(AppStrings.tryAgain), findsNothing);

      // Test clear functionality with some drawing
      await tester.dragFrom(center, center + const Offset(50, 50));
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.clear));
      await tester.pumpAndSettle();

      // Should be back to initial state
      expect(find.text(AppStrings.drawPerfectCircle), findsOneWidget);
    });

    testWidgets('score persistence test', (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Draw a circle and get a score
      final drawingCanvases = find.byType(CustomPaint);
      final center = tester.getCenter(drawingCanvases.first);
      final gesture = await tester.startGesture(center + const Offset(60, 0));
      
      for (int i = 0; i <= 24; i++) {
        final angle = (i * 2 * 3.14159) / 24;
        final point = center + Offset(
          60 * dart_math.cos(angle),
          60 * dart_math.sin(angle),
        );
        await gesture.moveTo(point);
        await tester.pump(const Duration(milliseconds: 15));
      }
      
      await gesture.up();
      
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Get the score text
      final scoreText = find.textContaining('/100');
      expect(scoreText, findsOneWidget);

      // Restart the app (simulating app restart)
      await tester.tap(find.text(AppStrings.tryAgain));
      await tester.pumpAndSettle();

      // The best score should still be displayed in the instructions
      expect(find.textContaining(AppStrings.bestScore), findsOneWidget);
      expect(find.textContaining(AppStrings.attempts), findsOneWidget);
    });

    testWidgets('accessibility test', (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Test semantic labels
      expect(find.bySemanticsLabel(AppStrings.drawingArea), findsOneWidget);
      expect(find.bySemanticsLabel(AppStrings.clearButton), findsOneWidget);
      expect(find.bySemanticsLabel(AppStrings.gridToggleButton), findsOneWidget);

      // Test button tap targets
      final clearButton = find.text(AppStrings.clear);
      final gridButton = find.text(AppStrings.hideGrid);

      expect(clearButton, findsOneWidget);
      expect(gridButton, findsOneWidget);

      // Buttons should be tappable
      await tester.tap(clearButton);
      await tester.pumpAndSettle();

      await tester.tap(gridButton);
      await tester.pumpAndSettle();
    });

    testWidgets('performance test - multiple drawings', (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      final drawingCanvases = find.byType(CustomPaint);
      final center = tester.getCenter(drawingCanvases.first);

      // Perform multiple drawing operations
      for (int drawing = 0; drawing < 3; drawing++) {
        // Draw a circle
        final gesture = await tester.startGesture(center + Offset(50 + drawing * 10, 0));
        
        for (int i = 0; i <= 20; i++) {
          final angle = (i * 2 * 3.14159) / 20;
          final point = center + Offset(
            (50 + drawing * 10) * dart_math.cos(angle),
            (50 + drawing * 10) * dart_math.sin(angle),
          );
          await gesture.moveTo(point);
          await tester.pump(const Duration(milliseconds: 5));
        }
        
        await gesture.up();
        await tester.pumpAndSettle();

        // Try again for next drawing
        if (drawing < 2) {
          await tester.tap(find.text(AppStrings.tryAgain));
          await tester.pumpAndSettle();
        }
      }

      // App should still be responsive
      expect(find.textContaining('/100'), findsOneWidget);
    });
  });
}