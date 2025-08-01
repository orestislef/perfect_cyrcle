import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:perfect_cyrcle/main.dart' as app;
import 'package:perfect_cyrcle/constants/app_strings.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Perfect Circle App Integration Tests', () {
    testWidgets('app launches and UI elements work', (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Verify initial state
      expect(find.text(AppStrings.drawPerfectCircle), findsOneWidget);
      expect(find.text(AppStrings.touchAndDrag), findsOneWidget);
      expect(find.text(AppStrings.clear), findsOneWidget);
      expect(find.text(AppStrings.hideGrid), findsOneWidget);

      // Test grid toggle
      await tester.tap(find.text(AppStrings.hideGrid));
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.showGrid), findsOneWidget);

      // Toggle back
      await tester.tap(find.text(AppStrings.showGrid));
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.hideGrid), findsOneWidget);

      // Test clear button functionality
      await tester.tap(find.text(AppStrings.clear));
      await tester.pumpAndSettle();
      
      // Instructions should still be visible after clear
      expect(find.text(AppStrings.drawPerfectCircle), findsOneWidget);
    });

    testWidgets('basic drawing interaction', (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Find drawing canvas
      final drawingCanvases = find.byType(CustomPaint);
      expect(drawingCanvases, findsWidgets);
      final center = tester.getCenter(drawingCanvases.first);

      // Perform a simple drawing gesture
      await tester.dragFrom(center, center + const Offset(100, 0));
      await tester.pumpAndSettle();

      // Instructions should be hidden when drawing
      expect(find.text(AppStrings.drawPerfectCircle), findsNothing);
    });

    testWidgets('accessibility features', (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Test semantic labels exist
      expect(find.bySemanticsLabel(AppStrings.drawingArea), findsOneWidget);
      expect(find.bySemanticsLabel(AppStrings.clearButton), findsOneWidget);
      expect(find.bySemanticsLabel(AppStrings.gridToggleButton), findsOneWidget);

      // Test buttons are accessible
      expect(find.text(AppStrings.clear), findsOneWidget);
      expect(find.text(AppStrings.hideGrid), findsOneWidget);
    });

    testWidgets('statistics display', (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Verify statistics are displayed in instructions
      expect(find.textContaining(AppStrings.bestScore), findsOneWidget);
      expect(find.textContaining(AppStrings.attempts), findsOneWidget);
    });
  });
}