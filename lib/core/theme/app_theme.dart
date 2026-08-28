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
      hintStyle: AppTypography.withColor(
        AppTypography.montserrat14W500,
        AppColors.tertiaryTextColor,
      ),
      labelStyle: AppTypography.withColor(
        AppTypography.montserrat14W500,
        AppColors.secondaryTextColor,
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
    displayLarge: AppTypography.withColor(
      AppTypography.montserrat28W600,
      AppColors.primaryTextColor,
    ),
    headlineLarge: AppTypography.withColor(
      AppTypography.montserrat22W600,
      AppColors.primaryTextColor,
    ),
    titleLarge: AppTypography.withColor(
      AppTypography.montserrat18W600,
      AppColors.primaryTextColor,
    ),
    titleMedium: AppTypography.withColor(
      AppTypography.montserrat16W600,
      AppColors.primaryTextColor,
    ),
    bodyLarge: AppTypography.withColor(
      AppTypography.montserrat16W500,
      AppColors.secondaryTextColor,
    ),
    bodyMedium: AppTypography.withColor(
      AppTypography.montserrat14W500,
      AppColors.secondaryTextColor,
    ),
    labelLarge: AppTypography.withColor(
      AppTypography.montserrat14W600,
      AppColors.primaryTextColor,
    ),
    labelMedium: AppTypography.withColor(
      AppTypography.montserrat12W500,
      AppColors.tertiaryTextColor,
    ),
  );
}
