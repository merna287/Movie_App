import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';

class TermsCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const TermsCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 2.h),
          child: SizedBox(
            width: 20.w,
            height: 20.h,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.primaryColor,
              checkColor: AppColors.primaryTextColor,
              side: const BorderSide(color: AppColors.tertiaryTextColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.r),
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged(!value),
            child: Padding(
              padding: EdgeInsets.only(top: 1.h),
              child: RichText(
                text: TextSpan(
                  text: LocaleKeys.agreeToThe.tr(),
                  style: AppTypography.withColor(
                    AppTypography.montserrat12W500,
                    AppColors.secondaryTextColor,
                  ),
                  children: [
                    TextSpan(
                      text: LocaleKeys.termsAndServices.tr(),
                      style: AppTypography.withColor(
                        AppTypography.montserrat12W500,
                        AppColors.primaryColor,
                      ),
                    ),
                    TextSpan(
                      text: LocaleKeys.andPrivacyPolicy.tr(),
                      style: AppTypography.withColor(
                        AppTypography.montserrat12W500,
                        AppColors.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
