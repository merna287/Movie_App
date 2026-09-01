import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Trans;
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:movie_app/features/home/presentation/cubit/home_state.dart';
import 'package:movie_app/features/home/presentation/views/movie_section_screen.dart';
import 'package:movie_app/features/home/presentation/widgets/movie_section.dart';
import 'package:movie_app/features/home/presentation/widgets/movie_section_shimmer.dart';

class HomeMovieSections extends StatelessWidget {
  const HomeMovieSections({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is! HomeSuccess) return const SizedBox.shrink();

        if (state.isGenreLoading && state.selectedGenreId != null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              MovieSectionShimmer(),
              SizedBox(height: 16),
              MovieSectionShimmer(),
              SizedBox(height: 16),
              MovieSectionShimmer(),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MovieSection(
              title: LocaleKeys.mostPopular,
              movies: state.visiblePopularMovies,
              emptyMessage: LocaleKeys.noPopularMoviesAvailable,
              onSeeAll: () => Get.to(
                () => MovieSectionScreen(
                  title: LocaleKeys.mostPopular,
                  movies: state.visiblePopularMovies,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            MovieSection(
              title: LocaleKeys.topRated,
              movies: state.visibleTopRatedMovies,
              emptyMessage: LocaleKeys.noTopRatedMoviesAvailable,
              onSeeAll: () => Get.to(
                () => MovieSectionScreen(
                  title: LocaleKeys.topRated,
                  movies: state.visibleTopRatedMovies,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            MovieSection(
              title: LocaleKeys.trending,
              movies: state.visibleTrendingMovies,
              emptyMessage: LocaleKeys.noTrendingMoviesAvailable,
              onSeeAll: () => Get.to(
                () => MovieSectionScreen(
                  title: LocaleKeys.trending,
                  movies: state.visibleTrendingMovies,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}