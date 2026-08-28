import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Trans;
import 'package:movie_app/core/dialogs/app_dialogs.dart';
import 'package:movie_app/core/dialogs/app_toast.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/validators/validator_app.dart';
import 'package:movie_app/core/widgets/app_button.dart';
import 'package:movie_app/core/widgets/app_text_form_field.dart';
import 'package:movie_app/features/auth/create_new_password/presentation/cubit/create_new_password_cubit.dart';
import 'package:movie_app/features/auth/create_new_password/presentation/cubit/create_new_password_state.dart';
import 'package:movie_app/features/auth/login/presentation/views/login_screen.dart';

class CreateNewPasswordForm extends StatefulWidget {
  final String code;

  const CreateNewPasswordForm({
    super.key,
    required this.code,
  });

  @override
  State<CreateNewPasswordForm> createState() => _CreateNewPasswordFormState();
}

class _CreateNewPasswordFormState extends State<CreateNewPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateNewPasswordCubit, CreateNewPasswordState>(
      listener: (context, state) {
        if (state is CreateNewPasswordLoading) {
          AppDialogs.showLoadingDialog(context);
        } else if (state is CreateNewPasswordSuccess) {
          setState(() => _isSubmitting = false);
          AppDialogs.hideLoading();
          AppToast.showToast(
            context,
            LocaleKeys.passwordResetSuccessfully.tr(),
            type: ToastType.success,
          );
          Get.offAll(() => const LoginScreen());
        } else if (state is CreateNewPasswordError) {
          setState(() => _isSubmitting = false);
          AppDialogs.hideLoading();
          AppToast.showToast(
            context,
            state.message,
            type: ToastType.error,
          );
        }
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextFormField(
                controller: _passwordController,
                labelText: LocaleKeys.password.tr(),
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.next,
                validator: ValidatorApp.validatePassword,
                suffixIcon: GestureDetector(
                  onTap: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  child: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.tertiaryTextColor,
                    size: 20.w,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              AppTextFormField(
                controller: _confirmPasswordController,
                labelText: LocaleKeys.confirmPasswordLabel.tr(),
                obscureText: _obscureConfirmPassword,
                textInputAction: TextInputAction.done,
                validator: (value) => ValidatorApp.validateConfirmPassword(
                  value,
                  _passwordController.text,
                ),
                suffixIcon: GestureDetector(
                  onTap: () => setState(
                    () => _obscureConfirmPassword = !_obscureConfirmPassword,
                  ),
                  child: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.tertiaryTextColor,
                    size: 20.w,
                  ),
                ),
              ),
              SizedBox(height: 40.h),
              AppButton(
                text: LocaleKeys.reset.tr(),
                onPressed: _onResetPressed,
              ),
            ],
          ),
        );
      },
    );
  }

  void _onResetPressed() {
    if (_isSubmitting) return;

    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSubmitting = true);

      context.read<CreateNewPasswordCubit>().confirmNewPassword(
            code: widget.code,
            newPassword: _passwordController.text,
          );
    }
  }
}
