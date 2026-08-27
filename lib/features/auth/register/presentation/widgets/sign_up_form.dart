import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/utils/app_toast.dart';
import 'package:movie_app/core/widgets/app_button.dart';
import 'package:movie_app/core/widgets/app_dialogs.dart';
import 'package:movie_app/features/auth/register/presentation/cubit/register_cubit.dart';
import 'package:movie_app/features/auth/register/presentation/cubit/register_state.dart';
import 'package:movie_app/features/auth/register/presentation/widgets/sign_up_fields.dart';
import 'package:movie_app/features/auth/register/presentation/widgets/terms_checkbox.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _agreeToTerms = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterLoading) {
          AppDialogs.showLoadingDialog(context);
        } else if (state is RegisterSuccess) {
          setState(() => _isSubmitting = false);
          AppDialogs.hideLoading();
          AppToast.showToast(
            context,
            LocaleKeys.accountCreatedSuccessfully.tr(),
            type: ToastType.success,
          );
        } else if (state is RegisterError) {
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
              SignUpFields(
                nameController: _nameController,
                emailController: _emailController,
                passwordController: _passwordController,
                obscurePassword: _obscurePassword,
                onTogglePasswordVisibility: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
              SizedBox(height: 20.h),
              TermsCheckbox(
                value: _agreeToTerms,
                onChanged: (value) =>
                    setState(() => _agreeToTerms = value ?? false),
              ),
              SizedBox(height: 28.h),
              AppButton(
                text: LocaleKeys.signUp.tr(),
                onPressed: _onSignUpPressed,
              ),
            ],
          ),
        );
      },
    );
  }

  void _onSignUpPressed() {
    if (_isSubmitting) return;

    if (!_agreeToTerms) {
      AppToast.showToast(
        context,
        LocaleKeys.pleaseAcceptTermsAndConditions.tr(),
        type: ToastType.info,
      );
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSubmitting = true);

      context.read<RegisterCubit>().signUp(
            email: _emailController.text,
            password: _passwordController.text,
          );
    }
  }
}
