import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SvgIconButton extends StatelessWidget {
  const SvgIconButton({
    super.key,
    required this.imagePath,
    required this.onTap,
    this.color,
  });
  final String imagePath;
  final void Function()? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SvgPicture.asset(
        imagePath,
        height: 24.h,
        width: 24.w,
        fit: BoxFit.contain,
        color: color,
      ),
    );
  }
}
