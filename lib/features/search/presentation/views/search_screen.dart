import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide Trans;
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';
import 'package:movie_app/features/home/presentation/views/movie_section_screen.dart';
import 'package:movie_app/features/home/presentation/widgets/home_section_header.dart';
import 'package:movie_app/features/home/presentation/widgets/home_search_bar.dart';
import 'package:movie_app/features/home/presentation/widgets/movie_section.dart';
import 'package:movie_app/features/search/domain/entities/actor.dart';
import 'package:movie_app/features/search/presentation/cubit/search_cubit.dart';
import 'package:movie_app/features/search/presentation/cubit/search_state.dart';
import 'package:movie_app/features/search/presentation/widgets/search_actor_tile.dart';
import 'package:movie_app/features/search/presentation/widgets/search_category_chips.dart';
import 'package:movie_app/features/search/presentation/widgets/search_movie_card.dart';
import 'package:movie_app/features/search/presentation/widgets/search_no_results_view.dart';
import 'package:movie_app/features/search/presentation/widgets/search_shimmer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final state = context.read<SearchCubit>().state;
    _controller = TextEditingController(text: _queryFor(state));
    _controller.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<SearchCubit>().loadInitialData();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _queryFor(SearchState state) => switch (state) {
    SearchIdle() => '',
    SearchLoading(:final query) => query,
    SearchMovieResults(:final query) => query,
    SearchActorResults(:final query) => query,
    SearchEmpty(:final query) => query,
    SearchError(:final query) => query,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 14.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: HomeSearchBar(
                controller: _controller,
                onChanged: context.read<SearchCubit>().onQueryChanged,
                onSubmitted: context.read<SearchCubit>().search,
                onClear: _clearSearch,
                hintText: LocaleKeys.searchPlaceholder.tr(),
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  return switch (state) {
                    SearchIdle(
                      :final loading,
                      :final todayMovies,
                      :final recommended,
                    ) => _SearchIdleView(
                      loading: loading,
                      todayMovies: todayMovies,
                      recommended: recommended,
                    ),
                    SearchLoading() => const SearchShimmer(),
                    SearchMovieResults(:final movies) =>
                      _SearchMovieResultsView(movies: movies),
                    SearchActorResults(:final actors, :final movies) =>
                      _SearchActorsView(actors: actors, movies: movies),
                    SearchEmpty() => const SearchNoResultsView(),
                    SearchError(:final message) => _SearchErrorView(
                      message: message,
                      onRetry: () => context.read<SearchCubit>().retry(),
                    ),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _clearSearch() {
    _controller.clear();
    context.read<SearchCubit>().onQueryChanged('');
  }
}

class _SearchIdleView extends StatelessWidget {
  final bool loading;
  final List<Movie> todayMovies;
  final List<Movie> recommended;

  const _SearchIdleView({
    required this.loading,
    required this.todayMovies,
    required this.recommended,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) return const SearchShimmer();
    if (todayMovies.isEmpty && recommended.isEmpty) {
      return _SearchErrorView(
        message: LocaleKeys.unexpectedError.tr(),
        onRetry: () => context.read<SearchCubit>().loadInitialData(),
      );
    }

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(bottom: 24.h),
      children: [
        const SearchCategoryChips(),
        if (todayMovies.isNotEmpty) ...[
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: HomeSectionHeader(titleKey: LocaleKeys.today),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SearchMovieCard(movie: todayMovies.first),
          ),
        ],
        if (recommended.isNotEmpty) ...[
          SizedBox(height: 24.h),
          MovieSection(
            title: LocaleKeys.recommendForYou,
            movies: recommended,
            onSeeAll: () => Get.to(
              () => MovieSectionScreen(
                title: LocaleKeys.recommendForYou,
                movies: recommended,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _SearchMovieResultsView extends StatelessWidget {
  final List<Movie> movies;

  const _SearchMovieResultsView({required this.movies});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
      itemCount: movies.length,
      separatorBuilder: (_, _) => SizedBox(height: 20.h),
      itemBuilder: (context, index) => SearchMovieCard(movie: movies[index]),
    );
  }
}

class _SearchActorsView extends StatelessWidget {
  final List<Actor> actors;
  final List<Movie> movies;

  const _SearchActorsView({required this.actors, required this.movies});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(bottom: 24.h),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: HomeSectionHeader(titleKey: LocaleKeys.actors),
        ),
        SizedBox(height: 14.h),
        SizedBox(
          height: 96.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            itemCount: actors.length,
            separatorBuilder: (_, _) => SizedBox(width: 12.w),
            itemBuilder: (context, index) =>
                SearchActorTile(actor: actors[index]),
          ),
        ),
        if (movies.isNotEmpty) ...[
          SizedBox(height: 24.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: HomeSectionHeader(
              titleKey: LocaleKeys.movieRelated,
              actionKey: LocaleKeys.seeAll,
              actionColor: AppColors.primaryColor,
              onActionTap: () => Get.to(
                () => MovieSectionScreen(
                  title: LocaleKeys.movieRelated,
                  movies: movies,
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                for (final (index, movie) in movies.indexed) ...[
                  if (index > 0) SizedBox(height: 20.h),
                  SearchMovieCard(movie: movie),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _SearchErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _SearchErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.withColor(
                AppTypography.montserrat12W500,
                AppColors.grayColor,
              ),
            ),
            SizedBox(height: 16.h),
            TextButton(
              onPressed: onRetry,
              child: Text(
                LocaleKeys.retry.tr(),
                style: AppTypography.withColor(
                  AppTypography.montserrat12W500.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  AppColors.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}