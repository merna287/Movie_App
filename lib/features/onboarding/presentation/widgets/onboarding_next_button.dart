import 'package:border_progress_indicator/border_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_app/core/constants/app_assets.dart';

import '../../../../core/theme/app_colors.dart';

class OnboardingNextButton extends StatelessWidget {
  final double progress;
  final VoidCallback onTap;

  const OnboardingNextButton({
    super.key,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 68.w,
        height: 68.w,
        child: AnimatedBorderProgressIndicator(
          borderRadius: 16.r,
          value: progress,
          color: AppColors.primaryColor,
          curve: Curves.easeOutCubic,
          strokeWidth: 2.w,
          child: Container(
            margin: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: SvgPicture.asset(
                AppAssets.backIcon,
                width: 24.w,
                height: 24.w,
              ),
            ),
          ),
        ),
      ),
    );
  }
}