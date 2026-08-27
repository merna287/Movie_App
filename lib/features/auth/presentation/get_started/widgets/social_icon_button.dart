import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_app/core/theme/app_colors.dart';

class SocialIconButton extends StatelessWidget {
  final String asset;
  final bool isLoading;
  final VoidCallback? onTap;

  const SocialIconButton({
    super.key,
    required this.asset,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: isLoading
          ? SizedBox(
              width: 70.w,
              height: 70.w,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                    asset,
                    width: 60.w,
                    height: 60.w,
                  ),
                  SizedBox(
                    width: 70.w,
                    height: 70.w,
                    child: const CircularProgressIndicator(
                      color: AppColors.primaryColor,
                      strokeWidth: 2,
                    ),
                  ),
                ],
              ),
            )
          : SvgPicture.asset(
              asset,
              width: 70.w,
              height: 70.w,
            ),
    );
  }
}