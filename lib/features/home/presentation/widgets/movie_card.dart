import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.boxColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
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
                  right: 8.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(97, 37, 40, 54),
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
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.fromLTRB(8.w, 4.h, 8.w, 4.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    movie.title,
                    style: AppTypography.withColor(
                      AppTypography.montserrat12W500.copyWith(height: 1.05),
                      AppColors.primaryTextColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    _localizedGenre(movie.genre),
                    style: AppTypography.withColor(
                      AppTypography.montserrat12W500.copyWith(height: 1.05),
                      AppColors.grayColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _localizedGenre(String genre) {
    switch (genre) {
      case 'Action':
        return LocaleKeys.genreAction.tr();
      case 'Adventure':
        return LocaleKeys.genreAdventure.tr();
      case 'Animation':
        return LocaleKeys.genreAnimation.tr();
      case 'Comedy':
        return LocaleKeys.genreComedy.tr();
      case 'Crime':
        return LocaleKeys.genreCrime.tr();
      case 'Drama':
        return LocaleKeys.genreDrama.tr();
      case 'Horror':
        return LocaleKeys.genreHorror.tr();
      case 'Romance':
        return LocaleKeys.genreRomance.tr();
      case 'Sci-Fi':
        return LocaleKeys.genreSciFi.tr();
      case 'Thriller':
        return LocaleKeys.genreThriller.tr();
      default:
        return genre;
    }
  }
}
