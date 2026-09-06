import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_app/core/constants/app_assets.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';

class MovieActionButtons extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback? onPlay;
  final VoidCallback? onShare;

  const MovieActionButtons({
    super.key,
    required this.isFavorite,
    required this.onFavoriteToggle,
    this.onPlay,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onPlay,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 11.h),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(28.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.play_arrow_rounded,
                  size: 22,
                  color: AppColors.primaryTextColor,
                ),
                SizedBox(width: 8.w),
                Text(
                  LocaleKeys.play.tr(),
                  style: AppTypography.withColor(
                    AppTypography.montserrat14W600,
                    AppColors.primaryTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 20.w),
        _CircleActionButton(
          onTap: onFavoriteToggle,
          child: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            size: 20,
            color: AppColors.errorColor,
          ),
        ),
        SizedBox(width: 12.w),
        _CircleActionButton(
          onTap: onShare,
          child: SvgPicture.asset(
            AppAssets.shareIcon,
            width: 20.w,
            height: 20.w,
          ),
        ),
      ],
    );
  }
}

class _CircleActionButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;

  const _CircleActionButton({this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48.w,
      height: 48.w,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.headerButtonColor,
            shape: BoxShape.circle,
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}
