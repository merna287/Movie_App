import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart' hide Trans;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movie_app/core/constants/app_assets.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/service/service_locator.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';
import 'package:movie_app/core/widgets/app_button.dart';
import 'package:movie_app/features/auth/get_started/presentation/cubit/get_started_cubit.dart';
import 'package:movie_app/features/auth/get_started/presentation/widgets/login_prompt.dart';
import 'package:movie_app/features/auth/get_started/presentation/widgets/social_login_buttons.dart';
import 'package:movie_app/features/auth/get_started/presentation/widgets/social_login_divider.dart';
import 'package:movie_app/features/auth/login/presentation/views/login_screen.dart';
import 'package:movie_app/features/auth/register/presentation/views/sign_up_screen.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<GetStartedCubit>(),
      child: const _GetStartedView(),
    );
  }
}

class _GetStartedView extends StatefulWidget {
  const _GetStartedView();

  @override
  State<_GetStartedView> createState() => _GetStartedViewState();
}

class _GetStartedViewState extends State<_GetStartedView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await GoogleSignIn.instance.initialize(
        serverClientId:
          '378841280424-m15fdkccmc26b9hagefbupkhkuh1m8ab.apps.googleusercontent.com',
      );
    });
  }

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
                const SocialLoginButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
