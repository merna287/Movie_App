import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_app/core/constants/app_assets.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';
import 'package:movie_app/features/home/presentation/widgets/localized_genre.dart';

class MovieDetailsMetadata extends StatelessWidget {
  final Movie movie;
  final int? runtimeMinutes;

  const MovieDetailsMetadata({
    super.key,
    required this.movie,
    this.runtimeMinutes,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (movie.releaseYear.isNotEmpty)
          _MetaItem(iconPath: AppAssets.calendarIcon, label: movie.releaseYear),
        if (runtimeMinutes != null)
          _MetaItem(
            iconPath: AppAssets.clockIcon,
            label: LocaleKeys.minutes.tr(
              namedArgs: {'count': '$runtimeMinutes'},
            ),
          ),
        if (movie.genre.isNotEmpty)
          _MetaItem(
            iconPath: AppAssets.filmIcon,
            label: localizedGenreName(movie.genre),
          ),
      ],
    );
  }
}

class _MetaItem extends StatelessWidget {
  final String iconPath;
  final String label;

  const _MetaItem({required this.iconPath, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 9.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(iconPath, width: 16.w, height: 16.w),
          SizedBox(width: 5.w),
          Text(
            label,
            style: AppTypography.withColor(
              AppTypography.montserrat12W500,
              AppColors.grayColor,
            ),
          ),
        ],
      ),
    );
  }
}
