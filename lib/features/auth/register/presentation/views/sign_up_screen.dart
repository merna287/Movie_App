import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/service/service_locator.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/widgets/app_screen_header.dart';
import 'package:movie_app/core/widgets/auth_intro_section.dart';
import 'package:movie_app/features/auth/register/presentation/cubit/register_cubit.dart';
import 'package:movie_app/features/auth/register/presentation/widgets/sign_up_form.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RegisterCubit>(),
      child: const _SignUpView(),
    );
  }
}

class _SignUpView extends StatelessWidget {
  const _SignUpView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16.h),
              AppScreenHeader(title: LocaleKeys.signUp.tr()),
              SizedBox(height: 32.h),
              AuthIntroSection(
                title: LocaleKeys.letsGetStarted.tr(),
                subtitle: LocaleKeys.theLatestMoviesAndSeriesAreHere.tr(),
              ),
              SizedBox(height: 32.h),
              const SignUpForm(),
            ],
          ),
        ),
      ),
    );
  }
}
