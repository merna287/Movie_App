import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';
import 'package:movie_app/features/profile/presentation/widgets/profile_settings_row.dart';

class ProfileSettingsGroup extends StatelessWidget {
  final String title;
  final List<(IconData, String, VoidCallback)> items;

  const ProfileSettingsGroup({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w),
          child: Text(
            title,
            style: AppTypography.withColor(
              AppTypography.montserrat14W600,
              AppColors.primaryTextColor,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            color: AppColors.boxColor,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              for (var i = 0; i < items.length; i++)
                ProfileSettingsRow(
                  icon: items[i].$1,
                  title: items[i].$2,
                  onTap: items[i].$3,
                  showDivider: i != items.length - 1,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
