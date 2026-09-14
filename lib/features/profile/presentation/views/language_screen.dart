import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
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

  Future<void> _selectLanguage(BuildContext context, Locale locale) async {
    if (context.locale.languageCode == locale.languageCode) return;
    await context.setLocale(locale);
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
              padding: EdgeInsets.only(left: 70.w),
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