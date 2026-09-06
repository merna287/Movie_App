import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/features/home/presentation/widgets/shimmer_box.dart';
import 'package:shimmer/shimmer.dart';

class FavoriteLoadingShimmer extends StatelessWidget {
  const FavoriteLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: 5,
      separatorBuilder: (_, _) => SizedBox(height: 16.h),
      itemBuilder: (_, _) => const _CardShimmer(),
    );
  }
}

class _CardShimmer extends StatelessWidget {
  const _CardShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.boxColor,
      highlightColor: AppColors.headerButtonColor,
      child: Container(
        width: 327.w,
        height: 107.h,
        padding: EdgeInsets.all(12.r),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.boxColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            ShimmerBox(width: 121.w, height: 83.h, radius: 8),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(width: 56.w, height: 13.h),
                  SizedBox(height: 6.h),
                  ShimmerBox(width: double.infinity, height: 16.h),
                  SizedBox(height: 4.h),
                  ShimmerBox(width: 180.w, height: 16.h),
                  const Spacer(),
                  Row(
                    children: [
                      ShimmerBox(width: 40.w, height: 12.h),
                      SizedBox(width: 8.w),
                      ShimmerBox(width: 16.w, height: 16.h, radius: 4),
                      SizedBox(width: 4.w),
                      ShimmerBox(width: 32.w, height: 12.h),
                      const Spacer(),
                      ShimmerBox(width: 22.w, height: 22.h, radius: 11),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
