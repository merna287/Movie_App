import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_app/core/constants/app_assets.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';

/// Empty state shown after a query produced no movie or actor matches.
class SearchNoResultsView extends StatelessWidget {
  const SearchNoResultsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              AppAssets.noResultIcon,
              width: 76.w,
              height: 76.w,
            ),
            SizedBox(height: 28.h),
            Text(
              LocaleKeys.weAreSorryCannotFindMovie.tr(),
              style: AppTypography.withColor(
                AppTypography.montserrat18W600,
                AppColors.primaryTextColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Text(
              LocaleKeys.findYourMovie.tr(),
              style: AppTypography.withColor(
                AppTypography.montserrat12W500.copyWith(height: 1.5),
                AppColors.grayColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}