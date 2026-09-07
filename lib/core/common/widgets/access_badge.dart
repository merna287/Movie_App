import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';

class AccessBadge extends StatelessWidget {
  final bool isPremium;

  const AccessBadge({super.key, required this.isPremium});

  @override
  Widget build(BuildContext context) {
    final String label = isPremium
        ? LocaleKeys.premium.tr()
        : LocaleKeys.free.tr();

    return Container(
      width: 65.w,
      height: 20.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isPremium ? AppColors.ratingStarColor : AppColors.primaryColor,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        label,
        style: AppTypography.withColor(
          AppTypography.montserrat12W500,
          AppColors.whiteColor,
        ),
      ),
    );
  }
}