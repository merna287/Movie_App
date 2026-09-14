import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_app/core/common/widgets/profile_avatar.dart';
import 'package:movie_app/core/constants/app_assets.dart';
import 'package:movie_app/core/theme/app_colors.dart';

class ProfileAvatarEditor extends StatelessWidget {
  final String? avatarUrl;
  final String? name;
  final VoidCallback onEdit;

  const ProfileAvatarEditor({
    super.key,
    this.avatarUrl,
    this.name,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomRight,
      children: [
        ProfileAvatar(
          radius: 55.w,
          name: name,
          imageUrl: avatarUrl,
        ),
        Positioned(
          right: 2.w,
          bottom: 2.w,
          child: GestureDetector(
            onTap: onEdit,
            child: Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.backgroundColor,
                  width: 2.w,
                ),
              ),
              child: Center(
                child: SvgPicture.asset(
                  AppAssets.editIcon,
                  width: 14.w,
                  height: 14.w,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}