import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import '../models/circle_result.dart';
import '../services/circle_evaluator.dart';
import '../services/analytics_service.dart';
import '../widgets/circle_painter.dart';
import '../providers/game_state_provider.dart';
import '../constants/app_strings.dart';
import '../config/app_config.dart';

class DrawCircleScreen extends StatefulWidget {
  const DrawCircleScreen({super.key});

  @override
  State<DrawCircleScreen> createState() => _DrawCircleScreenState();
}

class _DrawCircleScreenState extends State<DrawCircleScreen> {
  List<Offset> points = [];
  bool isDrawing = false;
  CircleResult? result;
  DateTime? drawStartTime;

  @override
  Widget build(BuildContext context) {
    return Consumer<GameStateProvider>(
      builder: (context, gameState, child) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        if (gameState.isLoading) {
          return _buildLoadingScreen(theme);
        }

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: Stack(
            children: [
              _buildDrawingArea(theme, isDark, gameState),
              _buildControls(theme, gameState),
              _buildInstructions(theme, gameState),
              _buildTryAgainButton(isDark),
              if (gameState.error != null) _buildErrorSnackBar(gameState),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingScreen(ThemeData theme) {
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorSnackBar(GameStateProvider gameState) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(gameState.error!),
          action: SnackBarAction(
            label: AppStrings.retry,
            onPressed: gameState.clearError,
          ),
        ),
      );
      gameState.clearError();
    });
    return const SizedBox.shrink();
  }

  Widget _buildDrawingArea(
    ThemeData theme,
    bool isDark,
    GameStateProvider gameState,
  ) {
    return Semantics(
      label: AppStrings.drawingArea,
      child: RawGestureDetector(
        gestures: {
          SingleFingerPanGestureRecognizer:
              GestureRecognizerFactoryWithHandlers<
                SingleFingerPanGestureRecognizer
              >(() => SingleFingerPanGestureRecognizer(), (
                SingleFingerPanGestureRecognizer instance,
              ) {
                instance
                  ..onStart = _startDrawing
                  ..onUpdate = _updateDrawing
                  ..onEnd = (details) => _endDrawing(details, gameState);
              }),
        },
        child: CustomPaint(
          size: Size.infinite,
          painter: CirclePainter(
            points: points,
            showGrid: gameState.showGrid,
            result: result,
            bestScore: gameState.bestScore,
            attempts: gameState.attempts,
            isDark: isDark,
            theme: theme,
          ),
        ),
      ),
    );
  }

  Widget _buildControls(ThemeData theme, GameStateProvider gameState) {
    return Positioned(
      top: 50,
      left: 16,
      child: Row(
        children: [
          _buildButton(AppStrings.clear, _clearCanvas, theme),
          const SizedBox(width: 8),
          _buildButton(
            gameState.showGrid ? AppStrings.hideGrid : AppStrings.showGrid,
            () => gameState.toggleGrid(),
            theme,
          ),
        ],
      ),
    );
  }

  Widget _buildInstructions(ThemeData theme, GameStateProvider gameState) {
    // Hide instructions as soon as user starts drawing OR when result is shown
    final shouldHide = points.isNotEmpty || result != null || isDrawing;

    return Positioned(
      top: 100,
      left: 20,
      right: 20,
      child: AnimatedOpacity(
        opacity: shouldHide ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: shouldHide
            ? const SizedBox.shrink()
            : Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.cardColor.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.dividerColor, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      AppStrings.drawPerfectCircle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.headlineLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      AppStrings.touchAndDrag,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.textTheme.bodyLarge?.color?.withValues(
                          alpha: .8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${AppStrings.bestScore}: ${gameState.bestScore} | ${AppStrings.attempts}: ${gameState.attempts}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.textTheme.bodyMedium?.color?.withValues(
                          alpha: .6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildTryAgainButton(bool isDark) {
    if (result == null) return const SizedBox.shrink();

    return Positioned(
      bottom: 30,
      right: 20,
      child: Semantics(
        label: AppStrings.tryAgainButton,
        child: FloatingActionButton.extended(
          onPressed: _clearCanvas,
          backgroundColor: (isDark ? Colors.white : Colors.black).withValues(
            alpha: 0.8,
          ),
          foregroundColor: isDark ? Colors.black : Colors.white,
          elevation: 4,
          icon: const Icon(Icons.refresh, size: 20),
          label: const Text(
            AppStrings.tryAgain,
            style: TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return Semantics(
      label: text == AppStrings.clear
          ? AppStrings.clearButton
          : AppStrings.gridToggleButton,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.cardColor,
          foregroundColor: theme.textTheme.bodyLarge?.color,
          elevation: 2,
          shadowColor: isDark
              ? Colors.black54
              : Colors.grey.withValues(alpha: .5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          minimumSize: const Size(
            AppConfig.minTouchTargetSize,
            AppConfig.minTouchTargetSize,
          ),
        ),
        child: Text(text),
      ),
    );
  }

  void _startDrawing(DragStartDetails details) {
    // Allow starting new drawing even if there's a previous result
    HapticFeedback.lightImpact();
    drawStartTime = DateTime.now();

    setState(() {
      isDrawing = true;
      points = [details.localPosition];
      result = null; // Clear previous result to start fresh
    });
  }

  void _updateDrawing(DragUpdateDetails details) {
    if (!isDrawing) {
      return; // Only check if currently drawing, allow drawing over results
    }

    setState(() {
      points.add(details.localPosition);

      // Performance optimization: limit points to prevent lag
      if (points.length > AppConfig.maxPointsInPath) {
        points = points.sublist(points.length - AppConfig.maxPointsInPath);
      }
    });
  }

  void _endDrawing(DragEndDetails details, GameStateProvider gameState) {
    if (!isDrawing) return; // Only check if currently drawing

    final drawEndTime = DateTime.now();
    final drawDuration = drawEndTime.difference(drawStartTime!).inSeconds;

    setState(() {
      isDrawing = false;
      result = CircleEvaluator.evaluateCircle(points);
    });

    // Update game state
    gameState.updateScore(result!);
    gameState.addPlayTime(drawDuration);

    // Log analytics
    AnalyticsService.instance.logCircleDrawn(result!, drawDuration);

    // Haptic feedback based on score
    if (result!.score >= AppConfig.excellentScoreThreshold) {
      HapticFeedback.mediumImpact();
    } else if (result!.score >= AppConfig.decentScoreThreshold) {
      HapticFeedback.lightImpact();
    }
  }

  void _clearCanvas() {
    HapticFeedback.selectionClick();
    setState(() {
      points = [];
      result = null;
    });
  }
}

/// Custom gesture recognizer that only accepts single-finger pan gestures
/// and completely ignores multi-touch input during active drawing sessions
class SingleFingerPanGestureRecognizer extends PanGestureRecognizer {
  int? _primaryPointer;

  @override
  void addAllowedPointer(PointerDownEvent event) {
    // Only accept the first pointer that comes down
    if (_primaryPointer == null) {
      _primaryPointer = event.pointer;
      super.addAllowedPointer(event);
    }
    // Completely ignore any additional pointers
  }

  @override
  void handleEvent(PointerEvent event) {
    // Only handle events from the primary pointer
    if (event.pointer == _primaryPointer) {
      super.handleEvent(event);
    }

    // Clean up when the primary pointer is released
    if (event is PointerUpEvent && event.pointer == _primaryPointer) {
      _primaryPointer = null;
    } else if (event is PointerCancelEvent &&
        event.pointer == _primaryPointer) {
      _primaryPointer = null;
    }
  }

  @override
  void dispose() {
    _primaryPointer = null;
    super.dispose();
  }
}
