import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/dialogs/app_dialogs.dart';
import 'package:movie_app/core/dialogs/app_toast.dart';
import 'package:movie_app/core/validators/validator_app.dart';
import 'package:movie_app/core/widgets/app_button.dart';
import 'package:movie_app/core/widgets/app_text_form_field.dart';
import 'package:movie_app/features/auth/reset_password/presentation/cubit/reset_password_cubit.dart';
import 'package:movie_app/features/auth/reset_password/presentation/cubit/reset_password_state.dart';

class ResetPasswordForm extends StatefulWidget {
  const ResetPasswordForm({super.key});

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
      listener: (context, state) {
        if (state is ResetPasswordLoading) {
          AppDialogs.showLoadingDialog(context);
        } else if (state is ResetPasswordSuccess) {
          setState(() => _isSubmitting = false);
          AppDialogs.hideLoading();
          AppToast.showToast(
            context,
            LocaleKeys.resetPasswordEmailSent.tr(),
            type: ToastType.success,
          );
        } else if (state is ResetPasswordError) {
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
                controller: _emailController,
                labelText: LocaleKeys.emailAddress.tr(),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                validator: ValidatorApp.validateEmail,
              ),
              SizedBox(height: 40.h),
              AppButton(
                text: LocaleKeys.next.tr(),
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

      context.read<ResetPasswordCubit>().sendResetPasswordEmail(
            email: _emailController.text,
          );
    }
  }
}
