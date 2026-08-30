import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';

class AppTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool enabled;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final int maxLines;

  const AppTextFormField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.suffixIcon,
    this.prefixIcon,
    this.enabled = true,
    this.textInputAction,
    this.focusNode,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      enabled: enabled,
      textInputAction: textInputAction,
      focusNode: focusNode,
      maxLines: maxLines,
      style: AppTypography.withColor(
        AppTypography.montserrat14W500,
        AppColors.primaryTextColor,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        errorMaxLines: 5,
        labelStyle: AppTypography.withColor(
          AppTypography.montserrat14W500,
          AppColors.secondaryTextColor,
        ),
        hintStyle: AppTypography.withColor(
          AppTypography.montserrat14W500,
          AppColors.tertiaryTextColor,
        ),
        filled: true,
        fillColor: AppColors.boxColor,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 14.h,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: const BorderSide(color: AppColors.primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: const BorderSide(color: AppColors.primaryColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: const BorderSide(color: AppColors.primaryColor),
        ),
        errorStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          fontFamily: 'Montserrat',
          color: AppColors.primaryColor,
          height: null,
        ),
      ),
    );
  }
}
