import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/validators/validator_app.dart';
import 'package:movie_app/core/widgets/app_text_form_field.dart';

class SignUpFields extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePasswordVisibility;

  const SignUpFields({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePasswordVisibility,
  });

  @override
  State<SignUpFields> createState() => _SignUpFieldsState();
}

class _SignUpFieldsState extends State<SignUpFields> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextFormField(
          controller: widget.nameController,
          labelText: LocaleKeys.fullName.tr(),
          hintText: LocaleKeys.fullNameHint.tr(),
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          validator: ValidatorApp.validateName,
        ),
        SizedBox(height: 16.h),
        AppTextFormField(
          controller: widget.emailController,
          labelText: LocaleKeys.emailAddress.tr(),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: ValidatorApp.validateEmail,
        ),
        SizedBox(height: 16.h),
        AppTextFormField(
          controller: widget.passwordController,
          labelText: LocaleKeys.password.tr(),
          obscureText: widget.obscurePassword,
          textInputAction: TextInputAction.done,
          validator: ValidatorApp.validatePassword,
          suffixIcon: GestureDetector(
            onTap: widget.onTogglePasswordVisibility,
            child: Icon(
              widget.obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.tertiaryTextColor,
              size: 20.w,
            ),
          ),
        ),
      ],
    );
  }
}
