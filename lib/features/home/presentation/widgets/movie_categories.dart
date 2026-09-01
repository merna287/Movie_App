import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/theme/app_typography.dart';
import 'package:movie_app/features/home/domain/entities/genre.dart';
import 'package:movie_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:movie_app/features/home/presentation/cubit/home_state.dart';
import 'package:movie_app/features/home/presentation/widgets/movie_category_chip.dart';

class MovieCategories extends StatefulWidget {
  const MovieCategories({super.key});

  @override
  State<MovieCategories> createState() => _MovieCategoriesState();
}

class _MovieCategoriesState extends State<MovieCategories> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is! HomeSuccess) return const SizedBox.shrink();

        final genres = [null, ...state.genres];
        final itemKeys = [for (var _ in genres) GlobalKey()];
        final foundIndex = state.selectedGenreId == null
            ? 0
            : genres.indexWhere((g) => g?.id == state.selectedGenreId);
        final selectedIndex = foundIndex < 0 ? 0 : foundIndex;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                LocaleKeys.categories.tr(),
                style: AppTypography.montserrat18W600,
              ),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              height: 31.h,
              child: genres.isEmpty
                  ? Center(
                      child: Text(
                        'No categories available',
                        style: AppTypography.montserrat12W500,
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      itemCount: genres.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(left: index == 0 ? 0 : 3.w),
                          child: _buildCategory(
                            index,
                            genres,
                            itemKeys,
                            selectedIndex,
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategory(
    int index,
    List<Genre?> genres,
    List<GlobalKey> itemKeys,
    int selectedIndex,
  ) {
    final genre = genres[index];
    return MovieCategoryChip(
      key: itemKeys[index],
      label: genre == null
          ? LocaleKeys.categoryAll.tr()
          : _localizedCategory(genre.name),
      isSelected: index == selectedIndex,
      onTap: () => _onCategoryTapped(index, genre?.id, itemKeys),
    );
  }

  String _localizedCategory(String category) {
    final key = _getCategoryKey(category);
    return key == null ? category : key.tr();
  }

  String? _getCategoryKey(String category) {
    switch (category) {
      case 'Action':
        return LocaleKeys.categoryAction;
      case 'Adventure':
        return LocaleKeys.categoryAdventure;
      case 'Animation':
        return LocaleKeys.categoryAnimation;
      case 'Comedy':
        return LocaleKeys.categoryComedy;
      case 'Crime':
        return LocaleKeys.categoryCrime;
      case 'Documentary':
        return LocaleKeys.categoryDocumentary;
      case 'Drama':
        return LocaleKeys.categoryDrama;
      case 'Family':
        return LocaleKeys.categoryFamily;
      case 'Fantasy':
        return LocaleKeys.categoryFantasy;
      case 'History':
        return LocaleKeys.categoryHistory;
      case 'Horror':
        return LocaleKeys.categoryHorror;
      case 'Music':
        return LocaleKeys.categoryMusic;
      case 'Mystery':
        return LocaleKeys.categoryMystery;
      case 'Romance':
        return LocaleKeys.categoryRomance;
      case 'Science Fiction':
        return LocaleKeys.categoryScienceFiction;
      case 'Sci-Fi':
        return LocaleKeys.categorySciFi;
      case 'TV Movie':
        return LocaleKeys.categoryTvMovie;
      case 'Thriller':
        return LocaleKeys.categoryThriller;
      case 'War':
        return LocaleKeys.categoryWar;
      case 'Western':
        return LocaleKeys.categoryWestern;
      default:
        return null;
    }
  }

  void _onCategoryTapped(int index, int? genreId, List<GlobalKey> itemKeys) {
    context.read<HomeCubit>().selectGenre(genreId);
    final itemContext = itemKeys[index].currentContext;
    if (itemContext != null) {
      Scrollable.ensureVisible(
        itemContext,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.5,
        alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
      );
    }
  }
}
