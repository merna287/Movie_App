import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Trans;
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:movie_app/features/home/presentation/cubit/home_state.dart';
import 'package:movie_app/features/home/presentation/views/movie_section_screen.dart';
import 'package:movie_app/features/home/presentation/widgets/movie_section.dart';

class HomeMovieSections extends StatelessWidget {
  const HomeMovieSections({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is! HomeSuccess) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MovieSection(
              title: LocaleKeys.mostPopular,
              movies: state.popularMovies,
              emptyMessage: LocaleKeys.noPopularMoviesAvailable,
              onSeeAll: () => Get.to(
                () => MovieSectionScreen(
                  title: LocaleKeys.mostPopular,
                  movies: state.popularMovies,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            MovieSection(
              title: LocaleKeys.topRated,
              movies: state.topRatedMovies,
              emptyMessage: LocaleKeys.noTopRatedMoviesAvailable,
              onSeeAll: () => Get.to(
                () => MovieSectionScreen(
                  title: LocaleKeys.topRated,
                  movies: state.topRatedMovies,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            MovieSection(
              title: LocaleKeys.trending,
              movies: state.trendingMovies,
              emptyMessage: LocaleKeys.noTrendingMoviesAvailable,
              onSeeAll: () => Get.to(
                () => MovieSectionScreen(
                  title: LocaleKeys.trending,
                  movies: state.trendingMovies,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}