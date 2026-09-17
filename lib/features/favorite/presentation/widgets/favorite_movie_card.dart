import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/service/service_locator.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';
import 'package:movie_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:movie_app/features/home/presentation/cubit/home_state.dart';
import 'package:movie_app/features/home/presentation/widgets/localized_genre.dart';

class FavoriteMovieCard extends StatelessWidget {
  final Movie movie;
  final bool removing;
  final VoidCallback onRemove;

  const FavoriteMovieCard({
    super.key,
    required this.movie,
    this.removing = false,
    required this.onRemove,
  });

  String _resolveGenre() {
    if (movie.genre.trim().isNotEmpty) {
      return localizedGenreName(movie.genre);
    }
    if (getIt.isRegistered<HomeCubit>()) {
      final homeState = getIt<HomeCubit>().state;
      if (homeState is HomeSuccess) {
        for (final id in movie.genreIds) {
          for (final g in homeState.genres) {
            if (g.id == id) {
              return localizedGenreName(g.name);
            }
          }
        }
      }
    }
    for (final id in movie.genreIds) {
      final name = _genreNameFromId(id);
      if (name != null) {
        return localizedGenreName(name);
      }
    }
    return '';
  }

  static String? _genreNameFromId(int id) {
    switch (id) {
      case 28:
        return 'Action';
      case 12:
        return 'Adventure';
      case 16:
        return 'Animation';
      case 35:
        return 'Comedy';
      case 80:
        return 'Crime';
      case 99:
        return 'Documentary';
      case 18:
        return 'Drama';
      case 10751:
        return 'Family';
      case 14:
        return 'Fantasy';
      case 36:
        return 'History';
      case 27:
        return 'Horror';
      case 10402:
        return 'Music';
      case 9648:
        return 'Mystery';
      case 10749:
        return 'Romance';
      case 878:
        return 'Science Fiction';
      case 10770:
        return 'TV Movie';
      case 53:
        return 'Thriller';
      case 10752:
        return 'War';
      case 37:
        return 'Western';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final genre = _resolveGenre();

    return Container(
      width: 327.w,
      height: 107.h,
      padding: EdgeInsets.all(12.r),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.boxColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          _MovieImage(movie: movie),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (genre.isNotEmpty) ...[
                  Text(
                    genre,
                    style: AppTypography.withColor(
                      AppTypography.montserrat13W500,
                      AppColors.whiteGreyColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                ],
                Text(
                  movie.title,
                  style: AppTypography.withColor(
                    AppTypography.montserrat14W600.copyWith(height: 1.2),
                    AppColors.primaryTextColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Row(
                  children: [
                    Text(
                      LocaleKeys.movie.tr(),
                      style: AppTypography.withColor(
                        AppTypography.montserrat12W500,
                        AppColors.grayColor,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    const Icon(
                      Icons.star,
                      size: 16,
                      color: AppColors.ratingStarColor,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      movie.rating.toStringAsFixed(1),
                      style: AppTypography.withColor(
                        AppTypography.montserrat12W500,
                        AppColors.ratingStarColor,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: removing ? null : onRemove,
                      behavior: HitTestBehavior.opaque,
                      child: Icon(
                        Icons.favorite,
                        size: 22,
                        color: removing
                            ? AppColors.tertiaryTextColor
                            : AppColors.errorColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MovieImage extends StatelessWidget {
  final Movie movie;

  const _MovieImage({required this.movie});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: Image.network(
        movie.imageUrl,
        width: 121.w,
        height: 83.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 121.w,
            height: 83.h,
            color: AppColors.headerButtonColor,
            child: const Icon(
              Icons.movie,
              size: 32,
              color: AppColors.tertiaryTextColor,
            ),
          );
        },
      ),
    );
  }
}
