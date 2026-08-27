import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';
import 'package:movie_app/core/widgets/app_button.dart';
import 'package:movie_app/core/widgets/app_screen_header.dart';
import 'package:movie_app/core/widgets/auth_intro_section.dart';
import 'package:movie_app/features/auth/verify_account/presentation/widgets/otp_input_field.dart';

class VerifyAccountScreen extends StatefulWidget {
  final String email;

  const VerifyAccountScreen({super.key, required this.email});

  @override
  State<VerifyAccountScreen> createState() => _VerifyAccountScreenState();
}

class _VerifyAccountScreenState extends State<VerifyAccountScreen> {
  String _otpCode = '';

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
              SizedBox(height: 32.h),
              AuthIntroSection(
                title: LocaleKeys.verifyingYourAccount.tr(),
                subtitle: LocaleKeys.verifyAccountDescription.tr(
                  namedArgs: {'email': widget.email},
                ),
              ),
              SizedBox(height: 48.h),
              OtpInputField(
                onCompleted: (code) => setState(() => _otpCode = code),
              ),
              SizedBox(height: 40.h),
              AppButton(
                text: LocaleKeys.continueAction.tr(),
                onPressed: _otpCode.length == 4 ? _onContinuePressed : () {},
              ),
              SizedBox(height: 24.h),
              GestureDetector(
                onTap: _onResendPressed,
                child: RichText(
                  text: TextSpan(
                    text: '${LocaleKeys.didNotReceiveCode.tr()} ',
                    style: AppTypography.withColor(
                      AppTypography.montserrat14W500,
                      AppColors.tertiaryTextColor,
                    ),
                    children: [
                      TextSpan(
                        text: LocaleKeys.resend.tr(),
                        style: AppTypography.withColor(
                          AppTypography.montserrat14W500,
                          AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onContinuePressed() {
    // TODO: Implement OTP verification
  }

  void _onResendPressed() {
    // TODO: Implement resend code
  }
}
