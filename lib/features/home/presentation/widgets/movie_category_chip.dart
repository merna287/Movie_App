import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';

class MovieCategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const MovieCategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(minWidth: 80.w),
        height: 31.h,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        alignment: Alignment.center,
        decoration: isSelected
            ? BoxDecoration(
                color: AppColors.boxColor,
                borderRadius: BorderRadius.circular(16.r),
              )
            : null,
        child: Text(
          label,
          style: AppTypography.montserrat14W500.copyWith(
            color: isSelected
                ? AppColors.primaryColor
                : AppColors.primaryTextColor,
          ),
        ),
      ),
    );
  }
}
