import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_app/core/constants/app_assets.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';

class MovieDetailsHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const MovieDetailsHeader({
    super.key,
    required this.title,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onBack,
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            width: 40.w,
            height: 40.w,
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
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(
              title,
              style: AppTypography.withColor(
                AppTypography.montserrat16W600,
                AppColors.primaryTextColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SizedBox(width: 40.w),
      ],
    );
  }
}
