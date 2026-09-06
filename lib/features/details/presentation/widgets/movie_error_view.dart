import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';

class MovieErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const MovieErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                message,
                style: AppTypography.withColor(
                  AppTypography.montserrat12W500,
                  AppColors.grayColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(width: 8.w),
            TextButton(
              onPressed: onRetry,
              child: Text(
                LocaleKeys.retry.tr(),
                style: AppTypography.withColor(
                  AppTypography.montserrat12W500.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  AppColors.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
