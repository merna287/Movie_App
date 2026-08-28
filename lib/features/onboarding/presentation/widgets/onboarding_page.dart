import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';
import 'package:movie_app/features/onboarding/data/models/onboarding_item.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingItem item;

  const OnboardingPage({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 50,
          child: SizedBox(
            width: double.infinity,
            child: Image.asset(
              item.image,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Expanded(
          flex: 25,
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 24.w,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.title,
                    style: AppTypography.withColor(
                      AppTypography.montserrat22W600,
                      AppColors.primaryTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    item.description,
                    style: AppTypography.withColor(
                      AppTypography.montserrat14W500,
                      AppColors.tertiaryTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}