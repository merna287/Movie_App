import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';

class CustomBottomNavBa extends StatelessWidget {
  final String iconPath;
  final String screenName;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomBottomNavBa({
    super.key,
    required this.iconPath,
    required this.screenName,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color color =
        isSelected ? AppColors.primaryColor : AppColors.grayColor;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        height: 40.h,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 12.w : 0,
        ),
        decoration: isSelected
            ? BoxDecoration(
                color: AppColors.boxColor,
                borderRadius: BorderRadius.circular(20.r),
              )
            : const BoxDecoration(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildIcon(iconPath, isSelected),
            if (isSelected) ...[
              SizedBox(width: 4.w),
              Text(
                screenName,
                style: AppTypography.withColor(
                  AppTypography.montserrat14W500,
                  color,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

Widget _buildIcon(String assetPath, bool isSelected) {
  return SvgPicture.asset(
    assetPath,
    width: 24.w,
    height: 24.h,
    colorFilter: ColorFilter.mode(
      isSelected ? AppColors.primaryColor : AppColors.grayColor,
      BlendMode.srcIn,
    ),
  );
}
