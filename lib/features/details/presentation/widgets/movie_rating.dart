import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';

class MovieRating extends StatelessWidget {
  final double rating;

  const MovieRating({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.star, size: 18, color: AppColors.ratingStarColor),
        SizedBox(width: 6.w),
        Text(
          rating.toString(),
          style: AppTypography.withColor(
            AppTypography.montserrat14W600,
            AppColors.primaryTextColor,
          ),
        ),
      ],
    );
  }
}
