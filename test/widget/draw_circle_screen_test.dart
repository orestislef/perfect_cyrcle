import 'dart:math' as dart_math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:perfect_cyrcle/screens/draw_circle_screen.dart';
import 'package:perfect_cyrcle/providers/game_state_provider.dart';
import 'package:perfect_cyrcle/constants/app_strings.dart';

void main() {
  group('DrawCircleScreen Widget Tests', () {
    late GameStateProvider gameStateProvider;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      gameStateProvider = GameStateProvider();
      await Future.delayed(const Duration(milliseconds: 100));
    });

    Widget createTestWidget() {
      return ChangeNotifierProvider<GameStateProvider>.value(
        value: gameStateProvider,
        child: MaterialApp(
          home: DrawCircleScreen(),
        ),
      );
    }

    testWidgets('should display initial instructions', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text(AppStrings.drawPerfectCircle), findsOneWidget);
      expect(find.text(AppStrings.touchAndDrag), findsOneWidget);
      expect(find.textContaining(AppStrings.bestScore), findsOneWidget);
    });

    testWidgets('should display control buttons', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.text(AppStrings.clear), findsOneWidget);
      expect(find.text(AppStrings.hideGrid), findsOneWidget);
    });

    testWidgets('should toggle grid when button is pressed', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Initial state should show "Hide Grid"
      expect(find.text(AppStrings.hideGrid), findsOneWidget);

      // Tap the grid toggle button
      await tester.tap(find.text(AppStrings.hideGrid));
      await tester.pumpAndSettle();

      // Should now show "Show Grid"
      expect(find.text(AppStrings.showGrid), findsOneWidget);
    });

    testWidgets('should show loading screen initially', (WidgetTester tester) async {
      // Arrange - Create provider that's still loading
      final loadingProvider = GameStateProvider();

      // Act
      await tester.pumpWidget(
        ChangeNotifierProvider<GameStateProvider>.value(
          value: loadingProvider,
          child: MaterialApp(
            home: DrawCircleScreen(),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should handle drawing gestures', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find the drawing area - there may be multiple CustomPaint widgets due to Material theme
      final drawingAreas = find.byType(CustomPaint);
      expect(drawingAreas, findsWidgets);

      // Simulate drawing a circle
      await tester.dragFrom(
        const Offset(200, 200),
        const Offset(250, 200),
      );
      await tester.pumpAndSettle();

      // Instructions should be hidden when drawing
      expect(find.text(AppStrings.drawPerfectCircle), findsNothing);
    });

    testWidgets('should show try again button after drawing', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Simulate drawing a complete circle by creating multiple drag gestures
      const center = Offset(200, 200);
      const radius = 50.0;
      
      // Start drawing
      await tester.startGesture(center + const Offset(radius, 0));
      
      // Draw points around a circle
      for (int i = 0; i <= 20; i++) {
        final angle = (i * 2 * 3.14159) / 20;
        final point = center + Offset(
          radius * 0.9 * dart_math.cos(angle),
          radius * 0.9 * dart_math.sin(angle),
        );
        await tester.dragFrom(
          center + Offset(radius * 0.9, 0),
          point,
        );
      }
      
      await tester.pumpAndSettle();

      // Try again button should appear
      expect(find.text(AppStrings.tryAgain), findsOneWidget);
    });

    testWidgets('should clear canvas when clear button is pressed', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Simulate some drawing
      await tester.dragFrom(
        const Offset(200, 200),
        const Offset(250, 200),
      );
      await tester.pumpAndSettle();

      // Tap clear button
      await tester.tap(find.text(AppStrings.clear));
      await tester.pumpAndSettle();

      // Instructions should be visible again
      expect(find.text(AppStrings.drawPerfectCircle), findsOneWidget);
    });

    testWidgets('should have proper accessibility labels', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert semantic labels exist
      expect(find.bySemanticsLabel(AppStrings.drawingArea), findsOneWidget);
      expect(find.bySemanticsLabel(AppStrings.clearButton), findsOneWidget);
      expect(find.bySemanticsLabel(AppStrings.gridToggleButton), findsOneWidget);
    });
  });
}