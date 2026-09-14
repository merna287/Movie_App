import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_app/core/common/widgets/profile_avatar.dart';
import 'package:movie_app/core/constants/app_assets.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';

class ProfileCard extends StatelessWidget {
  final String name;
  final String email;
  final String avatarUrl;
  final VoidCallback onEdit;

  const ProfileCard({
    super.key,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.boxColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          ProfileAvatar(
            radius: 32.w,
            name: name,
            imageUrl: avatarUrl,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.withColor(
                    AppTypography.montserrat16W600,
                    AppColors.primaryTextColor,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.withColor(
                    AppTypography.montserrat12W500,
                    AppColors.tertiaryTextColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          InkWell(
            onTap: onEdit,
            borderRadius: BorderRadius.circular(10.r),
            child: Container(
              width: 42.w,
              height: 42.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppColors.primaryColor.withValues(alpha: 0.4),
                ),
              ),
              child: SvgPicture.asset(
                AppAssets.editIcon,
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  AppColors.primaryColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
