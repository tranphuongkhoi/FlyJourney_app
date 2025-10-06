import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fly_journey/src/core/constants/colors.dart';

// Function to create a new TextTheme with scaled font sizes
TextTheme _buildTextTheme(TextTheme base) {
  return base
      .copyWith(
        displayLarge: base.displayLarge?.copyWith(fontSize: 58), // Default is 57
        displayMedium: base.displayMedium?.copyWith(fontSize: 46), // Default is 45
        displaySmall: base.displaySmall?.copyWith(fontSize: 37), // Default is 36
        headlineLarge: base.headlineLarge?.copyWith(fontSize: 33), // Default is 32
        headlineMedium: base.headlineMedium?.copyWith(fontSize: 29), // Default is 28
        headlineSmall: base.headlineSmall?.copyWith(fontSize: 25), // Default is 24
        titleLarge: base.titleLarge?.copyWith(fontSize: 23), // Default is 22
        titleMedium: base.titleMedium?.copyWith(fontSize: 17, fontWeight: FontWeight.w500), // Default is 16
        titleSmall: base.titleSmall?.copyWith(fontSize: 15, fontWeight: FontWeight.w500), // Default is 14
        bodyLarge: base.bodyLarge?.copyWith(fontSize: 17), // Default is 16
        bodyMedium: base.bodyMedium?.copyWith(fontSize: 15), // Default is 14
        bodySmall: base.bodySmall?.copyWith(fontSize: 13), // Default is 12
        labelLarge: base.labelLarge?.copyWith(fontSize: 15, fontWeight: FontWeight.w500), // Default is 14
        labelMedium: base.labelMedium?.copyWith(fontSize: 13), // Default is 12
        labelSmall: base.labelSmall?.copyWith(fontSize: 12), // Default is 11
      )
      .apply(
        fontFamily: 'BalooBhaijaan2',
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      );
}

ThemeData buildAppTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    primaryColor: AppColors.primaryBlue,
    scaffoldBackgroundColor: AppColors.background,
    textTheme: _buildTextTheme(base.textTheme),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.textPrimary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        textStyle: const TextStyle(
          fontFamily: 'BalooBhaijaan2',
          fontSize: 17, // Increased from 16
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
      ),
      labelStyle: const TextStyle(
        fontFamily: 'BalooBhaijaan2',
        color: AppColors.textSecondary,
        fontSize: 15, // Increased from 14
      ),
    ),
  );
}
