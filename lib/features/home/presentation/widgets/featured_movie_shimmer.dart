import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/features/home/presentation/widgets/shimmer_box.dart';

class FeaturedMovieShimmer extends StatelessWidget {
  const FeaturedMovieShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 154.h,
          child: Center(
            child: SizedBox(
              width: 295.w,
              height: 154.h,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    const ShimmerBox(radius: 0),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 14.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ShimmerBox(width: 180.w, height: 16.h),
                            SizedBox(height: 6.h),
                            ShimmerBox(width: 64.w, height: 12.h),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: ShimmerBox(width: 8.w, height: 8.h, radius: 4),
            );
          }),
        ),
      ],
    );
  }
}