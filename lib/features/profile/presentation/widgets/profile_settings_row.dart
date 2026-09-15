import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_app/core/constants/app_assets.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';

class ProfileSettingsRow extends StatelessWidget {
  final String iconPath;
  final String title;
  final VoidCallback onTap;
  final bool isActive;
  final bool showDivider;

  const ProfileSettingsRow({
    super.key,
    required this.iconPath,
    required this.title,
    required this.onTap,
    this.isActive = false,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final Color iconColor =
        isActive ? AppColors.primaryColor : AppColors.grayColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              children: [
Container(
                  width: 40.w,
                  height: 40.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.primaryColor.withValues(alpha: 0.12)
                        : AppColors.headerButtonColor,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    iconPath,
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      iconColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Text(
                    title,
                    style: AppTypography.withColor(
                      AppTypography.montserrat14W500,
                      AppColors.primaryTextColor,
                    ),
                  ),
                ),
                Transform.flip(
                  flipX: Directionality.of(context) == TextDirection.rtl,
                  child: SvgPicture.asset(
                    AppAssets.nextIcon,
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      AppColors.grayColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (showDivider)
            Padding(
              padding: EdgeInsetsDirectional.only(start: 70.w),
              child: Divider(
                height: 1.h,
                thickness: 1.h,
                color: AppColors.borderColor.withValues(alpha: 0.5),
              ),
            ),
        ],
      ),
    );
  }
}
