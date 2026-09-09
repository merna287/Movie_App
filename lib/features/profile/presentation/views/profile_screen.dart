import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Trans;
import 'package:movie_app/core/constants/app_assets.dart';
import 'package:movie_app/core/dialogs/app_toast.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';
import 'package:movie_app/features/profile/presentation/views/edit_profile_screen.dart';
import 'package:movie_app/features/profile/presentation/views/notification_screen.dart';
import 'package:movie_app/features/profile/presentation/views/privacy_policy_screen.dart';
import 'package:movie_app/features/profile/presentation/widgets/logout_button.dart';
import 'package:movie_app/features/profile/presentation/widgets/premium_banner.dart';
import 'package:movie_app/features/profile/presentation/widgets/profile_card.dart';
import 'package:movie_app/features/profile/presentation/widgets/profile_settings_group.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;
  StreamSubscription<User?>? _userSubscription;
  bool _signingOut = false;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _userSubscription = FirebaseAuth.instance.userChanges().listen(
      (user) {
        if (mounted) setState(() => _user = user);
      },
    );
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    super.dispose();
  }

  Future<void> _handleLogOut() async {
    if (_signingOut) return;
    setState(() => _signingOut = true);
    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        AppToast.showToast(
          context,
          LocaleKeys.loggedOutSuccessfully.tr(),
          type: ToastType.success,
        );
      }
    } catch (_) {
      if (mounted) {
        setState(() => _signingOut = false);
        AppToast.showToast(
          context,
          LocaleKeys.unexpectedError.tr(),
          type: ToastType.error,
        );
      }
    }
  }

  void _notImplemented(String feature) {
    AppToast.showToast(
      context,
      feature,
      type: ToastType.info,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _user;
    final name = user?.displayName?.trim();
    final displayName = (name == null || name.isEmpty)
        ? LocaleKeys.fullName.tr()
        : name;
    final email = user?.email ?? '';
    final avatarUrl = user?.photoURL ?? '';

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                LocaleKeys.profile.tr(),
                textAlign: TextAlign.center,
                style: AppTypography.withColor(
                  AppTypography.montserrat18W600,
                  AppColors.primaryTextColor,
                ),
              ),
              SizedBox(height: 24.h),
              ProfileCard(
                name: displayName,
                email: email,
                avatarUrl: avatarUrl,
                onEdit: () => Get.to(
                  () => EditProfileScreen(
                    name: displayName,
                    email: email,
                    avatarUrl: avatarUrl,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              PremiumBanner(
                onTap: () => _notImplemented(LocaleKeys.premiumMember.tr()),
              ),
              SizedBox(height: 28.h),
              ProfileSettingsGroup(
                title: LocaleKeys.settingsAccount.tr(),
                items: [
                  (
                    AppAssets.personIcon,
                    LocaleKeys.settingsMember.tr(),
                    () => _notImplemented(LocaleKeys.settingsMember.tr()),
                  ),
                  (
                    AppAssets.padlockIcon,
                    LocaleKeys.settingsChangePassword.tr(),
                    () => _notImplemented(LocaleKeys.settingsChangePassword.tr()),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              ProfileSettingsGroup(
                title: LocaleKeys.settingsGeneral.tr(),
                items: [
                  (
                    AppAssets.notificationIcon,
                    LocaleKeys.settingsNotification.tr(),
                    () => Get.to(() => const NotificationScreen()),
                  ),
                  (
                    AppAssets.globeIcon,
                    LocaleKeys.settingsLanguage.tr(),
                    () => _notImplemented(LocaleKeys.settingsLanguage.tr()),
                  ),
                  (
                    AppAssets.finishIcon,
                    LocaleKeys.settingsCountry.tr(),
                    () => _notImplemented(LocaleKeys.settingsCountry.tr()),
                  ),
                  (
                    AppAssets.trashBinIcon,
                    LocaleKeys.settingsClearCache.tr(),
                    () => _notImplemented(LocaleKeys.settingsClearCache.tr()),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              ProfileSettingsGroup(
                title: LocaleKeys.settingsMore.tr(),
                items: [
                  (
                    AppAssets.shieldIcon,
                    LocaleKeys.settingsLegalPolicies.tr(),
                    () => Get.to(() => const PrivacyPolicyScreen()),
                  ),
                  (
                    AppAssets.questionIcon,
                    LocaleKeys.settingsHelpFeedback.tr(),
                    () => _notImplemented(LocaleKeys.settingsHelpFeedback.tr()),
                  ),
                  (
                    AppAssets.alertIcon,
                    LocaleKeys.settingsAboutUs.tr(),
                    () => _notImplemented(LocaleKeys.settingsAboutUs.tr()),
                  ),
                ],
              ),
              SizedBox(height: 32.h),
              LogoutButton(
                text: LocaleKeys.logOut.tr(),
                onPressed: _handleLogOut,
              ),
              if (_signingOut) ...[
                SizedBox(height: 16.h),
                const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                    strokeWidth: 2.5,
                  ),
                ),
              ],
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }
}
