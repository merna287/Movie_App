import 'package:flutter/material.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';

enum ToastType { success, error, info }

class AppToast {
  AppToast._();

  static void showToast(
    BuildContext context,
    String message, {
    ToastType type = ToastType.info,
  }) {
    final Color backgroundColor = switch (type) {
      ToastType.success => AppColors.successColor,
      ToastType.error => AppColors.errorColor,
      ToastType.info => AppColors.boxColor,
    };

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: AppTypography.withColor(
              AppTypography.montserrat14W500,
              AppColors.primaryTextColor,
            ),
          ),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }
}
