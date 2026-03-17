import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../ui/dashboard/dashboard_screen.dart';
import '../ui/capture/food_capture_screen.dart';
import '../ui/analysis/analysis_results_screen.dart';
import '../ui/history/meal_history_screen.dart';
import '../ui/settings/settings_screen.dart';
import '../ui/widgets/app_bottom_nav.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/dashboard',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return AppBottomNavShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/dashboard',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: DashboardScreen(),
          ),
        ),
        GoRoute(
          path: '/history',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: MealHistoryScreen(),
          ),
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SettingsScreen(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/capture',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const FoodCaptureScreen(),
    ),
    GoRoute(
      path: '/analysis',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return AnalysisResultsScreen(
          imagePath: extra?['imagePath'] as String? ?? '',
          analysisResult: extra?['analysisResult'] as Map<String, dynamic>?,
        );
      },
    ),
  ],
);
