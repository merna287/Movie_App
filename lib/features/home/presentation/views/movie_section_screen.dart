import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/common/widgets/app_screen_header.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';
import 'package:movie_app/features/home/presentation/widgets/home_search_bar.dart';
import 'package:movie_app/features/home/presentation/widgets/movie_section_grid.dart';

class MovieSectionScreen extends StatefulWidget {
  final String title;
  final List<Movie> movies;

  const MovieSectionScreen({
    super.key,
    required this.title,
    required this.movies,
  });

  @override
  State<MovieSectionScreen> createState() => _MovieSectionScreenState();
}

class _MovieSectionScreenState extends State<MovieSectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String _query = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _query = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: AppScreenHeader(title: widget.title.tr()),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: HomeSearchBar(
                controller: _searchController,
                onChanged: _onQueryChanged,
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: MovieSectionGrid(
                movies: widget.movies,
                query: _query,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
