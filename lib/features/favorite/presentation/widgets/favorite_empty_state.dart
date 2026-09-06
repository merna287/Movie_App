import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_app/core/constants/app_assets.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';

class FavoriteEmptyState extends StatelessWidget {
  const FavoriteEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: SvgPicture.asset(
              AppAssets.favorite,
              width: 65.w,
              height: 76.w,
            ),
          ),
          SizedBox(height: 28.h),
          Text(
            LocaleKeys.favoriteEmptyTitle.tr(),
            style: AppTypography.withColor(
              AppTypography.montserrat18W600,
              AppColors.primaryTextColor,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.h),
          Text(
            LocaleKeys.favoriteEmptySubtitle.tr(),
            style: AppTypography.withColor(
              AppTypography.montserrat12W500.copyWith(height: 1.5),
              AppColors.grayColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
