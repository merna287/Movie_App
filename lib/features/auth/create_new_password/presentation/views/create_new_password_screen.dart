import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/widgets/app_screen_header.dart';
import 'package:movie_app/core/widgets/auth_intro_section.dart';
import 'package:movie_app/features/auth/create_new_password/presentation/widgets/create_new_password_form.dart';

class CreateNewPasswordScreen extends StatelessWidget {
  const CreateNewPasswordScreen({super.key});

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
              AppScreenHeader(title: ''),
              SizedBox(height: 40.h),
              AuthIntroSection(
                title: LocaleKeys.createNewPassword.tr(),
                subtitle: LocaleKeys.enterYourNewPassword.tr(),
              ),
              SizedBox(height: 48.h),
              const CreateNewPasswordForm(),
            ],
          ),
        ),
      ),
    );
  }
}
