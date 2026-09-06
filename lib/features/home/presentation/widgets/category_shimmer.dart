import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/features/home/presentation/widgets/shimmer_box.dart';

class CategoryShimmer extends StatelessWidget {
  const CategoryShimmer({super.key});

  static const List<double> _chipWidths = [70, 110, 62, 130, 78, 96];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: ShimmerBox(width: 90.w, height: 22.h),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 31.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            itemCount: _chipWidths.length,
            separatorBuilder: (_, _) => SizedBox(width: 3.w),
            itemBuilder: (context, index) => ShimmerBox(
              width: _chipWidths[index].w,
              height: 31.h,
              radius: 16,
            ),
          ),
        ),
      ],
    );
  }
}
