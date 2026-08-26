import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Trans;
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/validators/validator_app.dart';
import 'package:movie_app/core/widgets/app_button.dart';
import 'package:movie_app/core/widgets/app_text_form_field.dart';
import 'package:movie_app/features/auth/presentation/create_new_password/views/create_new_password_screen.dart';

class ResetPasswordForm extends StatefulWidget {
  const ResetPasswordForm({super.key});

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
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
            textInputAction: TextInputAction.done,
            validator: ValidatorApp.validateEmail,
          ),
          SizedBox(height: 40.h),
          AppButton(
            text: LocaleKeys.next.tr(),
            onPressed: _onNextPressed,
          ),
        ],
      ),
    );
  }

  void _onNextPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      Get.to(() => const CreateNewPasswordScreen());
    }
  }
}
