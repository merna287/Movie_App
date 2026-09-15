import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart' hide Trans;
import 'package:movie_app/core/common/widgets/app_screen_header.dart';
import 'package:movie_app/core/constants/app_assets.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentLanguageCode = context.locale.languageCode;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              AppScreenHeader(title: LocaleKeys.settingsLanguage.tr()),
              SizedBox(height: 28.h),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: AppColors.borderColor.withValues(alpha: 0.5),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    _LanguageRow(
                      iconPath: AppAssets.globeIcon,
                      title: LocaleKeys.english.tr(),
                      isSelected: currentLanguageCode == 'en',
                      showDivider: true,
                      onTap: () =>
                          _selectLanguage(context, const Locale('en')),
                    ),
                    _LanguageRow(
                      iconPath: AppAssets.globeIcon,
                      title: LocaleKeys.arabic.tr(),
                      isSelected: currentLanguageCode == 'ar',
                      showDivider: false,
                      onTap: () =>
                          _selectLanguage(context, const Locale('ar')),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectLanguage(BuildContext context, Locale targetLocale) async {
    if (context.locale.languageCode == targetLocale.languageCode) return;

    final isCurrentArabic = context.locale.languageCode == 'ar';
    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black54,
      builder: (dialogContext) => Dialog(
        backgroundColor: AppColors.boxColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isCurrentArabic ? 'تغيير اللغة' : 'Change Language',
                style: AppTypography.withColor(
                  AppTypography.montserrat16W600,
                  AppColors.primaryTextColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),
              Text(
                isCurrentArabic
                    ? 'هل أنت متأكد من تغيير اللغة؟'
                    : 'Are you sure you want to change the language?',
                style: AppTypography.withColor(
                  AppTypography.montserrat12W500.copyWith(height: 1.4),
                  AppColors.grayColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: _DialogActionButton(
                      label: LocaleKeys.no.tr(),
                      isPrimary: false,
                      onTap: () => Navigator.of(dialogContext).pop(false),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _DialogActionButton(
                      label: LocaleKeys.yes.tr(),
                      isPrimary: true,
                      onTap: () => Navigator.of(dialogContext).pop(true),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed != true || !context.mounted) return;

    await context.setLocale(targetLocale);
    Get.updateLocale(targetLocale);
  }
}

class _DialogActionButton extends StatelessWidget {
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;

  const _DialogActionButton({
    required this.label,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isPrimary
              ? AppColors.primaryColor
              : AppColors.headerButtonColor,
          borderRadius: BorderRadius.circular(22.r),
        ),
        child: Text(
          label,
          style: AppTypography.withColor(
            AppTypography.montserrat14W600,
            isPrimary ? AppColors.primaryTextColor : AppColors.grayColor,
          ),
        ),
      ),
    );
  }
}

class _LanguageRow extends StatelessWidget {
  final String iconPath;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showDivider;

  const _LanguageRow({
    required this.iconPath,
    required this.title,
    required this.isSelected,
    required this.onTap,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    final Color iconColor =
        isSelected ? AppColors.primaryColor : AppColors.grayColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryColor.withValues(alpha: 0.12)
                        : AppColors.headerButtonColor,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    iconPath,
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      iconColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Text(
                    title,
                    style: AppTypography.withColor(
                      AppTypography.montserrat14W500,
                      AppColors.primaryTextColor,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check,
                    color: AppColors.primaryColor,
                    size: 20.w,
                  ),
              ],
            ),
          ),
          if (showDivider)
            Padding(
              padding: EdgeInsetsDirectional.only(start: 70.w),
              child: Divider(
                height: 1.h,
                thickness: 1.h,
                color: AppColors.borderColor.withValues(alpha: 0.5),
              ),
            ),
        ],
      ),
    );
  }
}