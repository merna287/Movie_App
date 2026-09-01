import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/theme/app_typography.dart';
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
  int _selectedIndex = 0;

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

        final categories = ['All', ...state.genres.map((g) => g.name)];
        final itemKeys = [for (var _ in categories) GlobalKey()];
        final selectedIndex = _selectedIndex < categories.length
            ? _selectedIndex
            : 0;

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
              child: categories.isEmpty
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
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(left: index == 0 ? 0 : 3.w),
                          child: _buildCategory(
                            index,
                            categories,
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
    List<String> categories,
    List<GlobalKey> itemKeys,
    int selectedIndex,
  ) {
    return MovieCategoryChip(
      key: itemKeys[index],
      label: _getCategoryKey(categories[index]).tr(),
      isSelected: index == selectedIndex,
      onTap: () => _onCategoryTapped(index, itemKeys),
    );
  }

  void _onCategoryTapped(int index, List<GlobalKey> itemKeys) {
    setState(() {
      _selectedIndex = index;
    });
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

  String _getCategoryKey(String category) {
    switch (category) {
      case 'All':
        return LocaleKeys.categoryAll;
      case 'Comedy':
        return LocaleKeys.categoryComedy;
      case 'Animation':
        return LocaleKeys.categoryAnimation;
      case 'Documentary':
        return LocaleKeys.categoryDocumentary;
      case 'Action':
        return LocaleKeys.categoryAction;
      case 'Drama':
        return LocaleKeys.categoryDrama;
      case 'Horror':
        return LocaleKeys.categoryHorror;
      case 'Thriller':
        return LocaleKeys.categoryThriller;
      case 'Romance':
        return LocaleKeys.categoryRomance;
      case 'Sci-Fi':
        return LocaleKeys.categorySciFi;
      default:
        return category;
    }
  }
}
