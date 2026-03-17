import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/router.dart';

class CalWatchApp extends StatelessWidget {
  const CalWatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CalWatch',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}
