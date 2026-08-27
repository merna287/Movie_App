import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';


class SocialLoginDivider extends StatelessWidget {
  const SocialLoginDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: AppColors.dividerColor,
            thickness: 0.8,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            LocaleKeys.orSignUpWith.tr(),
            style: AppTypography.withColor(
              AppTypography.montserrat14W500,
              AppColors.tertiaryTextColor,
            ),
          ),
        ),
        const Expanded(
          child: Divider(
            color: AppColors.dividerColor,
            thickness: 0.8,
          ),
        ),
      ],
    );
  }
}
