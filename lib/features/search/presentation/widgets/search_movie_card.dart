import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart' hide Trans;
import 'package:movie_app/core/constants/app_assets.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';
import 'package:movie_app/features/details/presentation/views/movie_details_screen.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';
import 'package:movie_app/features/home/presentation/widgets/localized_genre.dart';

/// Vertical/list style movie card used on the Search screen:
/// "Today" spotlight, movie search results and "Movie Related".
///
/// Premium/Free and runtime are not available in the current Movie entity, so
/// they are rendered as UI placeholders matching the reference (same approach
/// as `MovieSectionScreen`).
class SearchMovieCard extends StatelessWidget {
  final Movie movie;

  const SearchMovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => MovieDetailsScreen(movie: movie)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Poster(movie: movie),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AccessBadge(isPremium: movie.rating >= 7),
                SizedBox(height: 8.h),
                Text(
                  movie.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.withColor(
                    AppTypography.montserrat16W600,
                    AppColors.primaryTextColor,
                  ),
                ),
                SizedBox(height: 8.h),
                _MetaRow(
                  icon: AppAssets.calendarIcon,
                  text: movie.releaseYear,
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    _MetaRow(
                      icon: AppAssets.clockIcon,
                      text: LocaleKeys.minutes.tr(
                        namedArgs: {'count': '148'},
                      ),
                    ),
                    SizedBox(width: 8.w),
                    const _Pg13Badge(),
                  ],
                ),
                SizedBox(height: 6.h),
                _MetaRow(
                  icon: AppAssets.filmIcon,
                  text:
                      '${localizedGenreName(movie.genre)}  |  '
                      '${_typeLabel(movie.mediaType)}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _typeLabel(String mediaType) {
    return mediaType == 'tv'
        ? LocaleKeys.series.tr()
        : LocaleKeys.movie.tr();
  }
}

class _Poster extends StatelessWidget {
  final Movie movie;

  const _Poster({required this.movie});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: SizedBox(
        width: 112.w,
        height: 147.h,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              movie.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.headerButtonColor,
                  child: Icon(
                    Icons.movie,
                    size: 36.w,
                    color: AppColors.tertiaryTextColor,
                  ),
                );
              },
            ),
            Positioned(
              top: 8.h,
              left: 8.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: AppColors.ratingBadgeBackgroundColor,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star,
                      size: 12.w,
                      color: AppColors.ratingStarColor,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      movie.rating.toString(),
                      style: AppTypography.withColor(
                        AppTypography.montserrat12W500,
                        AppColors.ratingStarColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccessBadge extends StatelessWidget {
  final bool isPremium;

  const _AccessBadge({required this.isPremium});

  @override
  Widget build(BuildContext context) {
    final String label = isPremium
        ? LocaleKeys.premium.tr()
        : LocaleKeys.free.tr();

    return Container(
      width: 65.w,
      height: 20.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isPremium ? AppColors.ratingStarColor : AppColors.primaryColor,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        label,
        style: AppTypography.withColor(
          AppTypography.montserrat12W500,
          AppColors.whiteColor,
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final String icon;
  final String text;

  const _MetaRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(icon, width: 16.w, height: 16.w),
        SizedBox(width: 6.w),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.withColor(
              AppTypography.montserrat12W500,
              AppColors.grayColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _Pg13Badge extends StatelessWidget {
  const _Pg13Badge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: AppColors.primaryColor),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        'PG-13',
        style: AppTypography.withColor(
          AppTypography.montserrat12W500,
          AppColors.primaryColor,
        ),
      ),
    );
  }
}