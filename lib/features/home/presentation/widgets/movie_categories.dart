import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/theme/app_typography.dart';
import 'package:movie_app/features/home/presentation/widgets/movie_category_chip.dart';

class MovieCategories extends StatefulWidget {
  final List<String> categories;

  const MovieCategories({super.key, required this.categories});

  @override
  State<MovieCategories> createState() => _MovieCategoriesState();
}

class _MovieCategoriesState extends State<MovieCategories> {
  final ScrollController _scrollController = ScrollController();
  late List<GlobalKey> _itemKeys;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _itemKeys = [for (var _ in widget.categories) GlobalKey()];
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            itemCount: widget.categories.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(left: index == 0 ? 0 : 12.w),
                child: _buildCategory(index),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategory(int index) {
    final categoryKey = _getCategoryKey(widget.categories[index]);
    return MovieCategoryChip(
      key: _itemKeys[index],
      label: categoryKey.tr(),
      isSelected: index == _selectedIndex,
      onTap: () => _onCategoryTapped(index),
    );
  }

  void _onCategoryTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    final itemContext = _itemKeys[index].currentContext;
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
