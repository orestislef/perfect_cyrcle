import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'themes/app_theme.dart';
import 'screens/draw_circle_screen.dart';
import 'providers/game_state_provider.dart';
import 'constants/app_strings.dart';
import 'services/analytics_service.dart';
import 'services/crash_reporting_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  CrashReportingService.instance.initialize();
  AnalyticsService.instance.initialize();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameStateProvider(),
      child: MaterialApp(
        title: AppStrings.appTitle,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: DrawCircleScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
