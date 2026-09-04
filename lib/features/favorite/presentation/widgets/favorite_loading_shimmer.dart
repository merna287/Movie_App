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
      itemBuilder: (_, _) => _CardShimmer(),
    );
  }
}

class _CardShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.boxColor,
      highlightColor: AppColors.headerButtonColor,
      child: Container(
        height: 128.h,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.boxColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Poster area
            SizedBox(width: 92.w, child: ShimmerBox(radius: 0)),
            // Info area
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(14.w, 16.h, 16.w, 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(width: 60.w, height: 12.h),
                    SizedBox(height: 8.h),
                    ShimmerBox(width: 120.w, height: 14.h),
                    const Spacer(),
                    ShimmerBox(width: 48.w, height: 12.h),
                  ],
                ),
              ),
            ),
            // Heart placeholder
            Padding(
              padding: EdgeInsets.only(top: 14.h, right: 14.w),
              child: ShimmerBox(width: 22.w, height: 22.h, radius: 11.r),
            ),
          ],
        ),
      ),
    );
  }
}