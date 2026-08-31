import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';

class HomeSectionHeader extends StatelessWidget {
  final String titleKey;
  final String? actionKey;
  final Color? actionColor;
  final VoidCallback? onActionTap;

  const HomeSectionHeader({
    super.key,
    required this.titleKey,
    this.actionKey,
    this.actionColor,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(titleKey.tr(), style: AppTypography.montserrat18W600),
        if (actionKey != null)
          GestureDetector(
            onTap: onActionTap,
            child: Text(
              actionKey!.tr(),
              style: AppTypography.withColor(
                AppTypography.montserrat14W500,
                actionColor ?? AppColors.tertiaryTextColor,
              ),
            ),
          ),
      ],
    );
  }
}
