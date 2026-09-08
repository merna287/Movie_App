import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';

class LogoutButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const LogoutButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: AppColors.primaryColor,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.r),
          ),
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.primaryColor,
        ),
        child: Text(
          text,
          style: AppTypography.withColor(
            AppTypography.montserrat16W600,
            AppColors.primaryColor,
          ),
        ),
      ),
    );
  }
}
