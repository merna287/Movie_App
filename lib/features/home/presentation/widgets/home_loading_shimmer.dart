import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/features/home/presentation/widgets/category_shimmer.dart';
import 'package:movie_app/features/home/presentation/widgets/featured_movie_shimmer.dart';
import 'package:movie_app/features/home/presentation/widgets/movie_section_shimmer.dart';
import 'package:movie_app/features/home/presentation/widgets/shimmer_box.dart';

class HomeLoadingShimmer extends StatelessWidget {
  const HomeLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Shimmer.fromColors(
        baseColor: AppColors.boxColor,
        highlightColor: AppColors.headerButtonColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 22.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: const _HeaderShimmer(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 26.w),
              child: ShimmerBox(height: 44.h, radius: 14),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: FeaturedMovieShimmer(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: CategoryShimmer(),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MovieSectionShimmer(),
                  SizedBox(height: 16.h),
                  MovieSectionShimmer(),
                  SizedBox(height: 16.h),
                  MovieSectionShimmer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderShimmer extends StatelessWidget {
  const _HeaderShimmer();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ShimmerBox(width: 48.w, height: 48.w, radius: 24),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerBox(width: 150.w, height: 22.h),
            SizedBox(height: 4.h),
            ShimmerBox(width: 110.w, height: 12.h),
          ],
        ),
      ],
    );
  }
}