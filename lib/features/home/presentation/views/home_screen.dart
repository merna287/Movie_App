import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/features/home/presentation/mock/home_mock_data.dart';
import 'package:movie_app/features/home/presentation/widgets/featured_movie_carousel.dart';
import 'package:movie_app/features/home/presentation/widgets/home_header.dart';
import 'package:movie_app/features/home/presentation/widgets/home_search_bar.dart';
import 'package:movie_app/features/home/presentation/widgets/movie_categories.dart';
import 'package:movie_app/features/home/presentation/widgets/most_popular_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = HomeMockData.data;

    return SafeArea(
      child: CustomScrollView(
        slivers: <Widget>[
          _section(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: const SizedBox(height: 20),
          ),
          _section(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: HomeHeader(
              userName: data.userName,
              avatarUrl: data.avatarUrl,
            ),
          ),
          _section(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24.w),
            child: const HomeSearchBar(),
          ),
          _section(
            padding: const EdgeInsets.only(bottom: 24),
            child: FeaturedMovieCarousel(featuredMovies: data.featuredMovies),
          ),
          _section(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: MovieCategories(categories: data.categories),
          ),
          _section(
            padding: const EdgeInsets.only(bottom: 20),
            child: MostPopularSection(popularMovies: data.popularMovies),
          ),
        ],
      ),
    );
  }

  SliverPadding _section({
    required Widget child,
    EdgeInsetsGeometry padding = EdgeInsets.zero,
  }) {
    return SliverPadding(
      padding: padding,
      sliver: SliverToBoxAdapter(child: child),
    );
  }
}
