import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_app/core/constants/app_assets.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';

class HomeSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const HomeSearchBar({
    super.key,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.boxColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            AppAssets.searchIcon,
            width: 20.w,
            height: 20.h,
            colorFilter: const ColorFilter.mode(
              AppColors.tertiaryTextColor,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: controller == null
                ? Text(
                    LocaleKeys.searchHint.tr(),
                    style: AppTypography.withColor(
                      AppTypography.montserrat14W500,
                      AppColors.tertiaryTextColor,
                    ),
                  )
                : TextField(
                    controller: controller,
                    onChanged: onChanged,
                    style: AppTypography.withColor(
                      AppTypography.montserrat14W500,
                      AppColors.primaryTextColor,
                    ),
                    cursorColor: AppColors.primaryColor,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      isCollapsed: true,
                      border: InputBorder.none,
                      hintText: LocaleKeys.searchHint.tr(),
                      hintStyle: AppTypography.withColor(
                        AppTypography.montserrat14W500,
                        AppColors.tertiaryTextColor,
                      ),
                    ),
                  ),
          ),
          Container(
            width: 1.w,
            height: 20.h,
            margin: EdgeInsets.symmetric(horizontal: 14.w),
            color: AppColors.borderColor,
          ),
          SvgPicture.asset(
            AppAssets.filterIcon,
            width: 20.w,
            height: 20.h,
            colorFilter: const ColorFilter.mode(
              AppColors.primaryTextColor,
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }
}
