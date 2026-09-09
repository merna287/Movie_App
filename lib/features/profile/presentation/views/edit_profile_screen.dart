import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Trans;
import 'package:movie_app/core/common/widgets/app_button.dart';
import 'package:movie_app/core/common/widgets/app_screen_header.dart';
import 'package:movie_app/core/common/widgets/app_text_form_field.dart';
import 'package:movie_app/core/dialogs/app_dialogs.dart';
import 'package:movie_app/core/dialogs/app_toast.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/service/service_locator.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';
import 'package:movie_app/core/validators/validator_app.dart';
import 'package:movie_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:movie_app/features/profile/presentation/widgets/profile_avatar_editor.dart';

class EditProfileScreen extends StatefulWidget {
  final String? name;
  final String? email;
  final String? avatarUrl;

  const EditProfileScreen({
    super.key,
    this.name,
    this.email,
    this.avatarUrl,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _obscurePassword = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name ?? '');
    _emailController = TextEditingController(text: widget.email ?? '');
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEditAvatar() {
    AppToast.showToast(context, LocaleKeys.editProfile.tr());
  }

  String? _validateNewPassword(String? value) {
    if (value == null || value.isEmpty) return null;
    return ValidatorApp.validatePassword(value);
  }

  Future<void> _onSaveChanges() async {
    if (_isSaving) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    AppDialogs.showLoadingDialog(context);
    setState(() => _isSaving = true);

    final result = await getIt<ProfileRepository>().updateProfile(
      displayName: _nameController.text,
      email: _emailController.text,
      newPassword: _passwordController.text,
    );

    AppDialogs.hideLoading();
    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() => _isSaving = false);
        AppToast.showToast(context, failure.message, type: ToastType.error);
      },
      (_) {
        AppToast.showToast(
          context,
          LocaleKeys.profileSavedSuccessfully.tr(),
          type: ToastType.success,
        );
        Get.back();
      },
    );
  }

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
              AppScreenHeader(title: LocaleKeys.editProfile.tr()),
              SizedBox(height: 28.h),
              ProfileAvatarEditor(
                avatarUrl: widget.avatarUrl ?? '',
                onEdit: _onEditAvatar,
              ),
              SizedBox(height: 18.h),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _nameController,
                builder: (context, value, _) => Text(
                  value.text.isEmpty ? widget.name ?? '' : value.text,
                  style: AppTypography.withColor(
                    AppTypography.montserrat18W600,
                    AppColors.primaryTextColor,
                  ),
                ),
              ),
              SizedBox(height: 4.h),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _emailController,
                builder: (context, value, _) => Text(
                  value.text.isEmpty ? widget.email ?? '' : value.text,
                  style: AppTypography.withColor(
                    AppTypography.montserrat12W500,
                    AppColors.tertiaryTextColor,
                  ),
                ),
              ),
              SizedBox(height: 32.h),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppTextFormField(
                      controller: _nameController,
                      labelText: LocaleKeys.fullName.tr(),
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      validator: ValidatorApp.validateName,
                    ),
                    SizedBox(height: 16.h),
                    AppTextFormField(
                      controller: _emailController,
                      labelText: LocaleKeys.email.tr(),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: ValidatorApp.validateEmail,
                    ),
                    SizedBox(height: 16.h),
                    AppTextFormField(
                      controller: _passwordController,
                      labelText: LocaleKeys.password.tr(),
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      validator: _validateNewPassword,
                      suffixIcon: GestureDetector(
                        onTap: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                        child: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.tertiaryTextColor,
                          size: 20.w,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 36.h),
              AppButton(
                text: LocaleKeys.saveChanges.tr(),
                onPressed: _onSaveChanges,
                borderRadius: 30,
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}