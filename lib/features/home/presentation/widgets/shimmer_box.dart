import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/theme/app_colors.dart';

class ShimmerBox extends StatelessWidget {
  final double? width;
  final double? height;
  final double radius;

  const ShimmerBox({super.key, this.width, this.height, this.radius = 8});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.boxColor,
        borderRadius: BorderRadius.circular(radius.r),
      ),
    );
  }
}
