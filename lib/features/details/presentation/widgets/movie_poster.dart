import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';

class MoviePoster extends StatelessWidget {
  final String imageUrl;

  const MoviePoster({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200.w,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: AspectRatio(
          aspectRatio: 2 / 3,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.headerButtonColor,
                    child: Icon(
                      Icons.movie,
                      size: 56.w,
                      color: AppColors.tertiaryTextColor,
                    ),
                  );
                },
              ),
              const Positioned(top: 8, left: 8, child: _PremiumBadge()),
            ],
          ),
        ),
      ),
    );
  }
}

class _PremiumBadge extends StatelessWidget {
  const _PremiumBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 65.w,
      height: 20.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.ratingStarColor,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        'Premium',
        style: AppTypography.withColor(
          AppTypography.montserrat12W500,
          AppColors.whiteColor,
        ),
      ),
    );
  }
}
