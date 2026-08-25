import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData theme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.backgroundColor,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryColor,
      secondary: AppColors.primaryColor,
      surface: AppColors.boxColor,
      onSurface: AppColors.primaryTextColor,
    ),
    textTheme: _textTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundColor,
      foregroundColor: AppColors.primaryTextColor,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: AppColors.boxColor,
      filled: true,
      hintStyle: AppTypography.montserrat14W500.copyWith(
        color: AppColors.tertiaryTextColor,
      ),
      labelStyle: AppTypography.montserrat14W500.copyWith(
        color: AppColors.secondaryTextColor,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.tertiaryTextColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.primaryColor),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.primaryTextColor,
        textStyle: AppTypography.montserrat14W600,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryColor,
        textStyle: AppTypography.montserrat14W500,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryTextColor,
        textStyle: AppTypography.montserrat14W600,
        side: const BorderSide(color: AppColors.primaryColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.boxColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  static final TextTheme _textTheme = TextTheme(
    displayLarge: AppTypography.montserrat28W600.copyWith(
      color: AppColors.primaryTextColor,
    ),
    headlineLarge: AppTypography.montserrat22W600.copyWith(
      color: AppColors.primaryTextColor,
    ),
    titleLarge: AppTypography.montserrat18W600.copyWith(
      color: AppColors.primaryTextColor,
    ),
    titleMedium: AppTypography.montserrat16W600.copyWith(
      color: AppColors.primaryTextColor,
    ),
    bodyLarge: AppTypography.montserrat16W500.copyWith(
      color: AppColors.secondaryTextColor,
    ),
    bodyMedium: AppTypography.montserrat14W500.copyWith(
      color: AppColors.secondaryTextColor,
    ),
    labelLarge: AppTypography.montserrat14W600.copyWith(
      color: AppColors.primaryTextColor,
    ),
    labelMedium: AppTypography.montserrat12W500.copyWith(
      color: AppColors.tertiaryTextColor,
    ),
  );
}
