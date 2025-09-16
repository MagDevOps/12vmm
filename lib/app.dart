import 'package:flutter/material.dart';

import 'screens/category_overview_screen.dart';

class TwelveWeekApp extends StatelessWidget {
  const TwelveWeekApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '12+M',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: const CategoryOverviewScreen(),
    );
  }

  ThemeData _buildTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF5E60CE),
      brightness: Brightness.light,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFFF6F7FB),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 900),
        backgroundColor: colorScheme.surface,
        contentTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
        actionTextColor: colorScheme.primary,
      ),
      chipTheme: ChipThemeData.fromDefaults(
        secondaryColor: colorScheme.primary,
        primaryColor: colorScheme.primary,
        brightness: Brightness.light,
      ).copyWith(
        labelStyle: TextStyle(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
