import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';

class AuthIntroSection extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthIntroSection({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: AppTypography.montserrat22W600,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        Text(
          subtitle,
          style: AppTypography.withColor(
            AppTypography.montserrat14W500,
            AppColors.tertiaryTextColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
