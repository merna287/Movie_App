import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart' hide Trans;
import 'package:movie_app/core/constants/app_assets.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';

class AppScreenHeader extends StatelessWidget {
  final String title;

  const AppScreenHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            width:30.w,
            height: 30.h,
            decoration: BoxDecoration(
              color: AppColors.headerButtonColor,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: SvgPicture.asset(
                AppAssets.backIcon,
                width: 20.w,
                height: 20.w,
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              title,
              style: AppTypography.montserrat18W600,
            ),
          ),
        ),
        SizedBox(width: 24.w),
      ],
    );
  }
}
