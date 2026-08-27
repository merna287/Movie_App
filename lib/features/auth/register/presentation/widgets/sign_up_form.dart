import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/widgets/app_button.dart';
import 'package:movie_app/features/auth/presentation/register/widgets/sign_up_fields.dart';
import 'package:movie_app/features/auth/presentation/register/widgets/terms_checkbox.dart';

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

  @override
  void dispose() {
    _nameController.dispose();
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
            onChanged: (value) => setState(() => _agreeToTerms = value ?? false),
          ),
          SizedBox(height: 28.h),
          AppButton(
            text: LocaleKeys.signUp.tr(),
            onPressed: _onSignUpPressed,
          ),
        ],
      ),
    );
  }

  void _onSignUpPressed() {
    if (!_agreeToTerms) return;
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Implement sign up logic
    }
  }
}
