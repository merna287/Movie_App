import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';
import 'package:movie_app/features/home/presentation/widgets/movie_card.dart';
import 'package:movie_app/features/home/presentation/widgets/movie_section_empty.dart';

class MovieSectionGrid extends StatelessWidget {
  final List<Movie> movies;
  final String query;

  const MovieSectionGrid({
    super.key,
    required this.movies,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    final trimmedQuery = query.trim().toLowerCase();
    final filtered = trimmedQuery.isEmpty
        ? movies
        : movies
              .where(
                (movie) => movie.title.toLowerCase().contains(trimmedQuery),
              )
              .toList();

    if (filtered.isEmpty) {
      return MovieSectionEmpty(hasQuery: trimmedQuery.isNotEmpty);
    }

    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 0.60,
      ),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        return MovieCard(movie: filtered[index]);
      },
    );
  }
}
