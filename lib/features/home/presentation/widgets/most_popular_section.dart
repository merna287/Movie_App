import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' hide Trans;
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:movie_app/features/home/presentation/cubit/home_state.dart';
import 'package:movie_app/features/home/presentation/views/movie_section_screen.dart';
import 'package:movie_app/features/home/presentation/widgets/movie_section.dart';

class MostPopularSection extends StatelessWidget {
  const MostPopularSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is! HomeSuccess) return const SizedBox.shrink();

        return MovieSection(
          title: LocaleKeys.mostPopular,
          movies: state.popularMovies,
          emptyMessage: LocaleKeys.noPopularMoviesAvailable,
          onSeeAll: () => Get.to(
            () => MovieSectionScreen(
              title: LocaleKeys.mostPopular,
              movies: state.popularMovies,
            ),
          ),
        );
      },
    );
  }
}
