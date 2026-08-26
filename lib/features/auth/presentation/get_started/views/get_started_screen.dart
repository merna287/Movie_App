import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart' hide Trans;
import 'package:movie_app/core/constants/app_assets.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';
import 'package:movie_app/core/widgets/app_button.dart';
import 'package:movie_app/features/auth/presentation/get_started/widgets/login_prompt.dart';
import 'package:movie_app/features/auth/presentation/get_started/widgets/social_login_divider.dart';
import 'package:movie_app/features/auth/presentation/login/views/login_screen.dart';
import 'package:movie_app/features/auth/presentation/register/views/sign_up_screen.dart';


class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AppAssets.liveTvIcon,
                  width: 80.w,
                  height: 80.w,
                ),
                SizedBox(height: 24.h),
                Text(
                  LocaleKeys.appName.tr(),
                  style: AppTypography.montserrat28W600,
                ),
                SizedBox(height: 8.h),
                Text(
                  LocaleKeys.getStartedSubtitle.tr(),
                  style: AppTypography.withColor(
                    AppTypography.montserrat14W600,
                    AppColors.tertiaryTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 64.h),
                AppButton(
                  text: LocaleKeys.signUp.tr(),
                  onPressed: () => Get.to(() => const SignUpScreen()),
                  borderRadius: 30,
                ),
                SizedBox(height: 34.h),
                LoginPrompt(
                  onLoginTap: () => Get.to(() => const LoginScreen()),
                ),
                SizedBox(height: 50.h),
                const SocialLoginDivider(),
                SizedBox(height: 43.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AppAssets.googleIcon,
                      width: 70.w,
                      height: 70.w,
                    ),
                    SizedBox(width: 45.w),
                    SvgPicture.asset(
                      AppAssets.facebookIcon,
                      width: 70.w,
                      height: 70.w,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
