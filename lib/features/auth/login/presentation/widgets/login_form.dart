import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Trans;
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';
import 'package:movie_app/core/validators/validator_app.dart';
import 'package:movie_app/core/widgets/app_button.dart';
import 'package:movie_app/core/widgets/app_text_form_field.dart';
import 'package:movie_app/features/auth/reset_password/presentation/views/reset_password_screen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextFormField(
            controller: _emailController,
            labelText: LocaleKeys.emailAddress.tr(),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: ValidatorApp.validateEmail,
          ),
          SizedBox(height: 24.h),
          AppTextFormField(
            controller: _passwordController,
            labelText: LocaleKeys.password.tr(),
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            validator: ValidatorApp.validatePassword,
            suffixIcon: GestureDetector(
              onTap: () => setState(() => _obscurePassword = !_obscurePassword),
              child: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.tertiaryTextColor,
                size: 20.w,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => Get.to(() => const ResetPasswordScreen()),
              child: Text(
                LocaleKeys.forgotPassword.tr(),
                style: AppTypography.withColor(
                  AppTypography.montserrat14W500,
                  AppColors.primaryColor,
                ),
              ),
            ),
          ),
          SizedBox(height: 63.h),
          AppButton(
            text: LocaleKeys.login.tr(),
            onPressed: _onLoginPressed,
          ),
        ],
      ),
    );
  }

  void _onLoginPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Implement login logic
    }
  }
}
