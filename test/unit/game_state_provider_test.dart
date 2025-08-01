import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:perfect_cyrcle/providers/game_state_provider.dart';
import 'package:perfect_cyrcle/models/circle_result.dart';

void main() {
  group('GameStateProvider', () {
    late GameStateProvider provider;

    setUp(() async {
      // Mock SharedPreferences
      SharedPreferences.setMockInitialValues({});
      provider = GameStateProvider();
      
      // Wait for initialization
      await Future.delayed(const Duration(milliseconds: 100));
    });

    test('should initialize with default values', () {
      expect(provider.bestScore, equals(0));
      expect(provider.attempts, equals(0));
      expect(provider.showGrid, isTrue);
      expect(provider.totalPlayTimeSeconds, equals(0));
      expect(provider.isLoading, isFalse);
      expect(provider.error, isNull);
    });

    test('should update score correctly', () async {
      // Arrange
      final result = CircleResult(score: 85, message: 'Great!', isClosed: true);

      // Act
      await provider.updateScore(result);

      // Assert
      expect(provider.bestScore, equals(85));
      expect(provider.attempts, equals(1));
    });

    test('should only update best score if higher', () async {
      // Arrange
      final firstResult = CircleResult(score: 85, message: 'Great!', isClosed: true);
      final secondResult = CircleResult(score: 70, message: 'Good!', isClosed: true);
      final thirdResult = CircleResult(score: 95, message: 'Perfect!', isClosed: true);

      // Act
      await provider.updateScore(firstResult);
      await provider.updateScore(secondResult);
      await provider.updateScore(thirdResult);

      // Assert
      expect(provider.bestScore, equals(95));
      expect(provider.attempts, equals(3));
    });

    test('should toggle grid correctly', () async {
      // Arrange
      final initialGridState = provider.showGrid;

      // Act
      await provider.toggleGrid();

      // Assert
      expect(provider.showGrid, equals(!initialGridState));
    });

    test('should track play time correctly', () async {
      // Act
      await provider.addPlayTime(30);
      await provider.addPlayTime(45);

      // Assert
      expect(provider.totalPlayTimeSeconds, equals(75));
    });

    test('should reset stats correctly', () async {
      // Arrange - Set some data
      final result = CircleResult(score: 85, message: 'Great!', isClosed: true);
      await provider.updateScore(result);
      await provider.addPlayTime(60);

      // Act
      await provider.resetStats();

      // Assert
      expect(provider.bestScore, equals(0));
      expect(provider.attempts, equals(0));
      expect(provider.totalPlayTimeSeconds, equals(0));
    });

    test('should calculate game stats correctly', () async {
      // Arrange
      await provider.updateScore(CircleResult(score: 80, message: 'Good!', isClosed: true));
      await provider.updateScore(CircleResult(score: 90, message: 'Great!', isClosed: true));
      await provider.addPlayTime(120);

      // Act
      final stats = provider.getGameStats();

      // Assert
      expect(stats['bestScore'], equals(90));
      expect(stats['attempts'], equals(2));
      expect(stats['totalPlayTimeSeconds'], equals(120));
      // Average score is total score / attempts, which is (80+90)/2 = 85.0
      expect(stats['averageScore'], equals(85.0));
    });

    test('should handle persistence correctly', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({
        'best_score': 75,
        'attempts': 5,
        'show_grid': false,
        'total_play_time': 300,
        'total_score': 300,
      });

      // Act
      final newProvider = GameStateProvider();
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      expect(newProvider.bestScore, equals(75));
      expect(newProvider.attempts, equals(5));
      expect(newProvider.showGrid, isFalse);
      expect(newProvider.totalPlayTimeSeconds, equals(300));
    });
  });
}