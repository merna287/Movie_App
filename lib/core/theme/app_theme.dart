import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

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
      hintStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.tertiaryTextColor,
      ),
      labelStyle: AppTextStyles.bodyMedium.copyWith(
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
        textStyle: AppTextStyles.labelLarge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryColor,
        textStyle: AppTextStyles.bodyMedium,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryTextColor,
        textStyle: AppTextStyles.labelLarge,
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

  static final TextTheme _textTheme = GoogleFonts.montserratTextTheme(
    TextTheme(
      displayLarge: AppTextStyles.displayLarge.copyWith(
        color: AppColors.primaryTextColor,
      ),
      headlineLarge: AppTextStyles.headlineLarge.copyWith(
        color: AppColors.primaryTextColor,
      ),
      titleLarge: AppTextStyles.titleLarge.copyWith(
        color: AppColors.primaryTextColor,
      ),
      titleMedium: AppTextStyles.titleMedium.copyWith(
        color: AppColors.primaryTextColor,
      ),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(
        color: AppColors.secondaryTextColor,
      ),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.secondaryTextColor,
      ),
      labelLarge: AppTextStyles.labelLarge.copyWith(
        color: AppColors.primaryTextColor,
      ),
      labelMedium: AppTextStyles.labelMedium.copyWith(
        color: AppColors.tertiaryTextColor,
      ),
    ),
  );
}
