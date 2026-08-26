import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/features/onboarding/presentation/widgets/onboarding_next_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class OnboardingControls extends StatelessWidget {
  final PageController pageController;
  final int itemCount;
  final double progress;
  final VoidCallback onNextPressed;

  const OnboardingControls({
    super.key,
    required this.pageController,
    required this.itemCount,
    required this.progress,
    required this.onNextPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: SizedBox(
        height: 60.h,
        child: Row(
          children: [
            SmoothPageIndicator(
              controller: pageController,
              count: itemCount,
              effect: ExpandingDotsEffect(
                activeDotColor: AppColors.primaryColor,
                dotColor: AppColors.primaryColor.withValues(
                  alpha: 0.25,
                ),
                dotHeight: 10.h,
                dotWidth: 8.w,
                expansionFactor: 4,
                spacing: 6.w,
              ),
            ),
            const Spacer(),
            OnboardingNextButton(
              progress: progress,
              onTap: onNextPressed,
            ),
          ],
        ),
      ),
    );
  }
}