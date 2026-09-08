import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';
import 'package:movie_app/features/profile/presentation/widgets/profile_settings_row.dart';

class ProfileSettingsGroup extends StatefulWidget {
  final String title;
  final List<(String, String, VoidCallback)> items;

  const ProfileSettingsGroup({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  State<ProfileSettingsGroup> createState() => _ProfileSettingsGroupState();
}

class _ProfileSettingsGroupState extends State<ProfileSettingsGroup> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.borderColor.withValues(alpha: 0.5),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
            child: Text(
              widget.title,
              style: AppTypography.withColor(
                AppTypography.montserrat14W600,
                AppColors.primaryTextColor,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Divider(
              height: 1.h,
              thickness: 1.h,
              color: AppColors.borderColor.withValues(alpha: 0.5),
            ),
          ),
          for (var i = 0; i < widget.items.length; i++)
            ProfileSettingsRow(
              iconPath: widget.items[i].$1,
              title: widget.items[i].$2,
              onTap: () {
                setState(() => _selectedIndex = i);
                widget.items[i].$3();
              },
              isActive: i == _selectedIndex,
              showDivider: i != widget.items.length - 1,
            ),
        ],
      ),
    );
  }
}
