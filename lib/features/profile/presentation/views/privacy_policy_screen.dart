import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/common/widgets/app_screen_header.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              AppScreenHeader(title: LocaleKeys.privacyPolicy.tr()),
              SizedBox(height: 32.h),
              _SectionTitle(text: LocaleKeys.terms.tr()),
              SizedBox(height: 12.h),
              _Body(text: LocaleKeys.termsBody.tr()),
              SizedBox(height: 16.h),
              _Body(text: LocaleKeys.termsBody.tr()),
              SizedBox(height: 28.h),
              _SectionTitle(
                text: LocaleKeys.changesToTheServiceAndOrTerms.tr(),
              ),
              SizedBox(height: 12.h),
              _Body(text: LocaleKeys.serviceChangesBody1.tr()),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.withColor(
        AppTypography.montserrat16W600,
        AppColors.primaryTextColor,
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final String text;

  const _Body({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.withColor(
        AppTypography.montserrat14W500.copyWith(
          height: 1.6,
          letterSpacing: 0.2,
        ),
        AppColors.tertiaryTextColor,
      ),
    );
  }
}