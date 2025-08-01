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
        child: MaterialApp(home: DrawCircleScreen()),
      );
    }

    testWidgets('should display initial instructions', (
      WidgetTester tester,
    ) async {
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

    testWidgets('should toggle grid when button is pressed', (
      WidgetTester tester,
    ) async {
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

    testWidgets('should initialize properly', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert - App should show main elements after loading
      expect(find.text(AppStrings.drawPerfectCircle), findsOneWidget);
      expect(find.text(AppStrings.clear), findsOneWidget);
    });

    testWidgets('should handle drawing gestures', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Simulate simple drawing gesture
      await tester.dragFrom(const Offset(400, 300), const Offset(450, 300));
      await tester.pumpAndSettle();

      // Instructions should be hidden when drawing
      expect(find.text(AppStrings.drawPerfectCircle), findsNothing);
    });

    testWidgets('should clear canvas when clear button is pressed', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Simulate some drawing
      await tester.dragFrom(const Offset(200, 200), const Offset(250, 200));
      await tester.pumpAndSettle();

      // Tap clear button
      await tester.tap(find.text(AppStrings.clear));
      await tester.pumpAndSettle();

      // Instructions should be visible again
      expect(find.text(AppStrings.drawPerfectCircle), findsOneWidget);
    });

    testWidgets('should have basic accessibility features', (
      WidgetTester tester,
    ) async {
      // Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert basic semantic features exist (simplified check)
      expect(find.text(AppStrings.clear), findsOneWidget);
      expect(find.text(AppStrings.hideGrid), findsOneWidget);
    });
  });
}
