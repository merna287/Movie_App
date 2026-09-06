import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:movie_app/core/constants/app_assets.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';

import 'share_service.dart';

class ShareModal extends StatelessWidget {
  final String shareUrl;

  const ShareModal({
    super.key,
    required this.shareUrl,
  });

  static void show(
    BuildContext context, {
    required String shareUrl,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.black38,
      builder: (_) => _BlurredBackground(
        child: ShareModal(
          shareUrl: shareUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.boxColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SizedBox(
        width: 327.w,
        height: 234.h,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 24.w,
                    height: 24.h,
                    decoration: const BoxDecoration(
                      color: AppColors.headerButtonColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 12,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                LocaleKeys.shareTo.tr(),
                style: AppTypography.withColor(
                  AppTypography.montserrat16W600,
                  AppColors.primaryTextColor,
                ),
              ),
              SizedBox(height: 32.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 15.w,
                children: [
                  _SocialCircleButton(
                    asset: AppAssets.facebookIcon,
                    onTap: () => _share(context),
                  ),
                  _SocialCircleButton(
                    asset: AppAssets.instagramIcon,
                    onTap: () => _share(context),
                  ),
                  _SocialCircleButton(
                    asset: AppAssets.messengerIcon,
                    onTap: () => _share(context),
                  ),
                  _SocialCircleButton(
                    asset: AppAssets.telegramIcon,
                    onTap: () => _share(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _share(BuildContext context) async {
    await ShareService.share(shareUrl);
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}

class _SocialCircleButton extends StatelessWidget {
  final String asset;
  final VoidCallback onTap;

  const _SocialCircleButton({
    required this.asset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: SvgPicture.asset(
          asset,
          width: 50.w,
          height: 50.h,
        ),
      ),
    );
  }
}

class _BlurredBackground extends StatelessWidget {
  final Widget child;

  const _BlurredBackground({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5,
              sigmaY: 5,
            ),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        child,
      ],
    );
  }
}
