import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/circle_result.dart';

class GameStateProvider extends ChangeNotifier {
  static const String _bestScoreKey = 'best_score';
  static const String _attemptsKey = 'attempts';
  static const String _showGridKey = 'show_grid';
  static const String _totalPlayTimeKey = 'total_play_time';
  static const String _totalScoreKey = 'total_score';

  int _bestScore = 0;
  int _attempts = 0;
  bool _showGrid = true;
  int _totalPlayTimeSeconds = 0;
  bool _isLoading = true;
  String? _error;
  int _totalScore = 0;

  int get bestScore => _bestScore;
  int get attempts => _attempts;
  bool get showGrid => _showGrid;
  int get totalPlayTimeSeconds => _totalPlayTimeSeconds;
  bool get isLoading => _isLoading;
  String? get error => _error;

  GameStateProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      
      _bestScore = prefs.getInt(_bestScoreKey) ?? 0;
      _attempts = prefs.getInt(_attemptsKey) ?? 0;
      _showGrid = prefs.getBool(_showGridKey) ?? true;
      _totalPlayTimeSeconds = prefs.getInt(_totalPlayTimeKey) ?? 0;
      _totalScore = prefs.getInt(_totalScoreKey) ?? 0;
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load game data: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateScore(CircleResult result) async {
    try {
      _attempts++;
      _totalScore += result.score;
      
      if (result.score > _bestScore) {
        _bestScore = result.score;
      }

      await _saveData();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to save score: $e';
      notifyListeners();
    }
  }

  Future<void> toggleGrid() async {
    try {
      _showGrid = !_showGrid;
      await _saveGridPreference();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to save grid preference: $e';
      notifyListeners();
    }
  }

  Future<void> addPlayTime(int seconds) async {
    try {
      _totalPlayTimeSeconds += seconds;
      await _savePlayTime();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to save play time: $e';
      notifyListeners();
    }
  }

  Future<void> resetStats() async {
    try {
      _bestScore = 0;
      _attempts = 0;
      _totalPlayTimeSeconds = 0;
      _totalScore = 0;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_bestScoreKey);
      await prefs.remove(_attemptsKey);
      await prefs.remove(_totalPlayTimeKey);
      await prefs.remove(_totalScoreKey);
      
      notifyListeners();
    } catch (e) {
      _error = 'Failed to reset stats: $e';
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setInt(_bestScoreKey, _bestScore),
      prefs.setInt(_attemptsKey, _attempts),
      prefs.setInt(_totalScoreKey, _totalScore),
    ]);
  }

  Future<void> _saveGridPreference() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showGridKey, _showGrid);
  }

  Future<void> _savePlayTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_totalPlayTimeKey, _totalPlayTimeSeconds);
  }

  Map<String, dynamic> getGameStats() {
    return {
      'bestScore': _bestScore,
      'attempts': _attempts,
      'totalPlayTimeSeconds': _totalPlayTimeSeconds,
      'averageScore': _attempts > 0 ? (_totalScore / _attempts).round() / 1.0 : 0.0,
    };
  }
}