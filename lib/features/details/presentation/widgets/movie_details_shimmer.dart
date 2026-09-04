import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:movie_app/core/theme/app_colors.dart';

class MovieDetailsShimmer extends StatelessWidget {
  const MovieDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Shimmer.fromColors(
        baseColor: AppColors.boxColor,
        highlightColor: AppColors.headerButtonColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 14.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  _box(width: 40.w, height: 40.w, radius: 20.r),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: _box(width: 160.w, height: 18.h),
                    ),
                  ),
                  SizedBox(width: 40.w),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: _box(width: 200.w, height: 300.w, radius: 20.r),
              ),
            ),
            SizedBox(height: 22.h),
            Center(
              child: _box(width: 160.w, height: 14.h),
            ),
            SizedBox(height: 10.h),
            Center(
              child: _box(width: 80.w, height: 16.h),
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _box(width: 116.w, height: 44.h, radius: 22.r),
                SizedBox(width: 20.w),
                _box(width: 48.w, height: 48.w, radius: 24.r),
                SizedBox(width: 12.w),
                _box(width: 48.w, height: 48.w, radius: 24.r),
              ],
            ),
            SizedBox(height: 28.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _box(width: 96.w, height: 16.h),
                  SizedBox(height: 10.h),
                  _box(width: double.infinity, height: 12.h),
                  SizedBox(height: 8.h),
                  _box(width: double.infinity, height: 12.h),
                  SizedBox(height: 8.h),
                  _box(width: 180.w, height: 12.h),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _box(width: 120.w, height: 16.h),
                  SizedBox(height: 12.h),
                  SizedBox(
                    height: 118.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 4,
                      separatorBuilder: (_, _) => SizedBox(width: 14.w),
                      itemBuilder: (context, index) => Column(
                        children: [
                          _box(width: 72.w, height: 72.w, radius: 36.r),
                          SizedBox(height: 6.h),
                          _box(width: 60.w, height: 10.h),
                          SizedBox(height: 2.h),
                          _box(width: 44.w, height: 9.h),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  _box(width: 140.w, height: 10.h),
                  SizedBox(height: 8.h),
                  _box(width: 120.w, height: 10.h),
                  SizedBox(height: 8.h),
                  _box(width: 100.w, height: 10.h),
                ],
              ),
            ),
            SizedBox(height: 36.h),
          ],
        ),
      ),
    );
  }

  Widget _box({
    required double? width,
    required double? height,
    double radius = 8,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.boxColor,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
