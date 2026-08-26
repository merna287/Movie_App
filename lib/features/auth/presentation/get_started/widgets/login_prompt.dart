import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';

class LoginPrompt extends StatelessWidget {
  final VoidCallback onLoginTap;

  const LoginPrompt({
    super.key,
    required this.onLoginTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onLoginTap,
        child: RichText(
          text: TextSpan(
            text: '${LocaleKeys.alreadyHaveAnAccount.tr()} ',
            style: AppTypography.withColor(
              AppTypography.montserrat16W500,
              AppColors.dividerColor,
            ),
            children: [
              TextSpan(
                text: LocaleKeys.login.tr(),
                style: AppTypography.withColor(
                  AppTypography.montserrat16W600,
                  AppColors.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
