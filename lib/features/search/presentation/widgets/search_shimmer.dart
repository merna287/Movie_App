import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/features/home/presentation/widgets/shimmer_box.dart';
import 'package:shimmer/shimmer.dart';

/// Loading placeholder for search results: vertical list cards matching the
/// `SearchMovieCard` layout.
class SearchShimmer extends StatelessWidget {
  const SearchShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.boxColor,
      highlightColor: AppColors.headerButtonColor,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
        itemCount: 5,
        separatorBuilder: (_, _) => SizedBox(height: 20.h),
        itemBuilder: (context, index) => const _SearchCardShimmer(),
      ),
    );
  }
}

class _SearchCardShimmer extends StatelessWidget {
  const _SearchCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerBox(width: 112.w, height: 147.h, radius: 12),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerBox(width: 65.w, height: 20.h, radius: 4),
              SizedBox(height: 8.h),
              ShimmerBox(width: 150.w, height: 18.h, radius: 4),
              SizedBox(height: 8.h),
              Row(
                children: [
                  ShimmerBox(width: 16.w, height: 16.w),
                  SizedBox(width: 6.w),
                  ShimmerBox(width: 60.w, height: 12.h),
                ],
              ),
              SizedBox(height: 6.h),
              Row(
                children: [
                  ShimmerBox(width: 16.w, height: 16.w),
                  SizedBox(width: 6.w),
                  ShimmerBox(width: 80.w, height: 12.h),
                  SizedBox(width: 8.w),
                  ShimmerBox(width: 40.w, height: 16.h, radius: 4),
                ],
              ),
              SizedBox(height: 6.h),
              Row(
                children: [
                  ShimmerBox(width: 16.w, height: 16.w),
                  SizedBox(width: 6.w),
                  ShimmerBox(width: 70.w, height: 12.h),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}