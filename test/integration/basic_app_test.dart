import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:perfect_cyrcle/main.dart' as app;
import 'package:perfect_cyrcle/constants/app_strings.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Perfect Circle Basic Integration Tests', () {
    testWidgets('app launches and basic UI elements work', (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Verify initial state - instructions should be visible
      expect(find.text(AppStrings.drawPerfectCircle), findsOneWidget);
      expect(find.text(AppStrings.touchAndDrag), findsOneWidget);

      // Verify control buttons are present
      expect(find.text(AppStrings.clear), findsOneWidget);
      expect(find.text(AppStrings.hideGrid), findsOneWidget);

      // Test grid toggle functionality
      await tester.tap(find.text(AppStrings.hideGrid));
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.showGrid), findsOneWidget);

      // Toggle back
      await tester.tap(find.text(AppStrings.showGrid));
      await tester.pumpAndSettle();
      expect(find.text(AppStrings.hideGrid), findsOneWidget);
    });

    testWidgets('basic drawing interaction works', (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Find a safe area to draw (center of screen)
      final screenSize = tester.getSize(find.byType(MaterialApp));
      final center = Offset(screenSize.width / 2, screenSize.height / 2);

      // Perform a simple drawing gesture
      await tester.dragFrom(center, center + const Offset(50, 0));
      await tester.pumpAndSettle();

      // Instructions should be hidden when drawing
      expect(find.text(AppStrings.drawPerfectCircle), findsNothing);

      // Clear button should still work
      await tester.tap(find.text(AppStrings.clear));
      await tester.pumpAndSettle();

      // Instructions should reappear after clearing
      expect(find.text(AppStrings.drawPerfectCircle), findsOneWidget);
    });
  });
}