import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final String avatarUrl;

  const HomeHeader({super.key, this.userName = 'Guest', this.avatarUrl = ''});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24.r,
          backgroundColor: AppColors.boxColor,
          backgroundImage: avatarUrl.isEmpty ? null : NetworkImage(avatarUrl),
          child: avatarUrl.isEmpty
              ? Icon(
                  Icons.person,
                  size: 24.w,
                  color: AppColors.tertiaryTextColor,
                )
              : null,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.helloName.tr(namedArgs: {'name': userName}),
                style: AppTypography.withColor(
                  AppTypography.montserrat18W600,
                  AppColors.primaryTextColor,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                LocaleKeys.letsStreamYourFavoriteMovie.tr(),
                style: AppTypography.withColor(
                  AppTypography.montserrat12W500,
                  AppColors.tertiaryTextColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
