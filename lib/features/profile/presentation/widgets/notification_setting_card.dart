import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';

class NotificationSettingCard extends StatelessWidget {
  final bool showNotifications;
  final ValueChanged<bool> onShowNotificationsChanged;

  const NotificationSettingCard({
    super.key,
    required this.showNotifications,
    required this.onShowNotificationsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
            child: Text(
              LocaleKeys.messagesNotifications.tr(),
              style: AppTypography.withColor(
                AppTypography.montserrat14W600,
                AppColors.primaryTextColor,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    LocaleKeys.showNotifications.tr(),
                    style: AppTypography.withColor(
                      AppTypography.montserrat14W500,
                      AppColors.whiteGreyColor,
                    ),
                  ),
                ),
                Switch(
                  value: showNotifications,
                  onChanged: onShowNotificationsChanged,
                  activeTrackColor: AppColors.primaryColor,
                  activeThumbColor: Colors.white,
                  inactiveTrackColor: AppColors.borderColor,
                  inactiveThumbColor: Colors.white,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
            child: Text(
              LocaleKeys.exceptions.tr(),
              style: AppTypography.withColor(
                AppTypography.montserrat14W500,
                AppColors.whiteGreyColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}