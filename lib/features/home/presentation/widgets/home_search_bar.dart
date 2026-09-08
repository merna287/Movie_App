import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_app/core/constants/app_assets.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';

class HomeSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final String? hintText;

  /// Whether to show the leading search icon inside the container.
  /// The Search screen hides it so the field starts directly with the hint.
  final bool showSearchIcon;

  /// Whether to show the trailing divider + close/filter icon inside the
  /// container. The Search screen keeps the container clean and moves the
  /// cancel action outside.
  final bool showTrailing;

  const HomeSearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.hintText,
    this.showSearchIcon = true,
    this.showTrailing = true,
  });

  @override
  Widget build(BuildContext context) {
    final String hint = hintText ?? LocaleKeys.searchHint.tr();

    return Container(
      height: 44.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.boxColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          if (showSearchIcon) ...[
            SvgPicture.asset(
              AppAssets.searchIcon,
              width: 20.w,
              height: 20.h,
              colorFilter: const ColorFilter.mode(
                AppColors.tertiaryTextColor,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 12.w),
          ],
          Expanded(
            child: controller == null
                ? Text(
                    hint,
                    style: AppTypography.withColor(
                      AppTypography.montserrat14W500,
                      AppColors.tertiaryTextColor,
                    ),
                  )
                : TextField(
                    controller: controller,
                    onChanged: onChanged,
                    onSubmitted: onSubmitted,
                    style: AppTypography.withColor(
                      AppTypography.montserrat14W500,
                      AppColors.primaryTextColor,
                    ),
                    cursorColor: AppColors.primaryColor,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      isCollapsed: true,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: hint,
                      hintStyle: AppTypography.withColor(
                        AppTypography.montserrat14W500,
                        AppColors.tertiaryTextColor,
                      ),
                    ),
                  ),
          ),
          if (showTrailing) ...[
            Container(
              width: 1.w,
              height: 20.h,
              margin: EdgeInsets.symmetric(horizontal: 14.w),
              color: AppColors.borderColor,
            ),
            if (controller != null &&
                onClear != null &&
                controller!.text.trim().isNotEmpty)
              GestureDetector(
                onTap: onClear,
                child: Icon(
                  Icons.close,
                  size: 20.w,
                  color: AppColors.primaryTextColor,
                ),
              )
            else
              SvgPicture.asset(
                AppAssets.filterIcon,
                width: 20.w,
                height: 20.h,
                colorFilter: const ColorFilter.mode(
                  AppColors.primaryTextColor,
                  BlendMode.srcIn,
                ),
              ),
          ],
        ],
      ),
    );
  }
}
