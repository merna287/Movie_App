import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/features/home/presentation/widgets/shimmer_box.dart';

class MovieSectionShimmer extends StatelessWidget {
  const MovieSectionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Row(
            children: [
              ShimmerBox(width: 110.w, height: 22.h),
              const Spacer(),
              ShimmerBox(width: 44.w, height: 16.h),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 231.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            itemCount: 3,
            separatorBuilder: (_, _) => SizedBox(width: 12.w),
            itemBuilder: (context, index) => const _MovieCardShimmer(),
          ),
        ),
      ],
    );
  }
}

class _MovieCardShimmer extends StatelessWidget {
  const _MovieCardShimmer();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 135.w,
      height: 231.h,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.boxColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const ShimmerBox(radius: 0),
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: ShimmerBox(width: 44.w, height: 18.h, radius: 6),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.fromLTRB(8.w, 4.h, 8.w, 4.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ShimmerBox(width: 100.w, height: 12.h),
                    SizedBox(height: 8.h),
                    ShimmerBox(width: 64.w, height: 10.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
