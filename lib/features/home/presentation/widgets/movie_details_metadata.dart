import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_app/core/constants/app_assets.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';

class MovieDetailsMetadata extends StatelessWidget {
  final String? year;
  final int? runtimeMinutes;
  final String? genre;

  const MovieDetailsMetadata({
    super.key,
    this.year,
    this.runtimeMinutes,
    this.genre,
  });

  @override
  Widget build(BuildContext context) {
    final segments = <Widget>[
      if (year != null && year!.isNotEmpty)
        _segment(AppAssets.calendarIcon, year!),
      if (runtimeMinutes != null && runtimeMinutes! > 0)
        _segment(AppAssets.clockIcon, _formatRuntime(runtimeMinutes!)),
      if (genre != null && genre!.isNotEmpty)
        _segment(AppAssets.filmIcon, genre!),
    ];

    if (segments.isEmpty) return const SizedBox.shrink();

    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 10.w,
        runSpacing: 6.h,
        children: [
          for (final (index, segment) in segments.indexed) ...[
            if (index > 0) _separator,
            segment,
          ],
        ],
      ),
    );
  }

  TextStyle get _itemStyle => AppTypography.withColor(
    AppTypography.montserrat12W500,
    AppColors.grayColor,
  );

  Widget get _separator => Text(
    '|',
    style: AppTypography.withColor(
      AppTypography.montserrat12W500,
      AppColors.grayColor,
    ),
  );

  Widget _segment(String icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(icon, width: 16.w, height: 16.w),
        SizedBox(width: 4.w),
        Text(text, style: _itemStyle),
      ],
    );
  }

  String _formatRuntime(int totalMinutes) {
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;

    if (hours == 0) return '${minutes}m';
    if (minutes == 0) return '${hours}h';
    return '${hours}h ${minutes}m';
  }
}
