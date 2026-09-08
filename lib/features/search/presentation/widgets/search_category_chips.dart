import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/features/home/presentation/widgets/movie_category_chip.dart';

/// Static horizontally scrollable category/filter row shown above the
/// "Today" section on the initial Search screen ("All" is selected first).
class SearchCategoryChips extends StatefulWidget {
  const SearchCategoryChips({super.key});

  @override
  State<SearchCategoryChips> createState() => _SearchCategoryChipsState();
}

class _SearchCategoryChipsState extends State<SearchCategoryChips> {
  int _selectedIndex = 0;

  static const List<String> _categoryKeys = [
    LocaleKeys.categoryAll,
    LocaleKeys.categoryComedy,
    LocaleKeys.categoryAnimation,
    LocaleKeys.categoryDocumentary,
    LocaleKeys.categoryDrama,
    LocaleKeys.categoryAction,
    LocaleKeys.categoryHorror,
    LocaleKeys.categoryThriller,
    LocaleKeys.categoryRomance,
    LocaleKeys.categorySciFi,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 31.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        itemCount: _categoryKeys.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(left: index == 0 ? 0 : 3.w),
            child: MovieCategoryChip(
              label: _categoryKeys[index].tr(),
              isSelected: index == _selectedIndex,
              onTap: () => setState(() => _selectedIndex = index),
            ),
          );
        },
      ),
    );
  }
}