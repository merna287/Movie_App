import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/service/service_locator.dart';
import 'package:movie_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:movie_app/features/home/presentation/widgets/featured_movie_carousel.dart';
import 'package:movie_app/features/home/presentation/widgets/home_header.dart';
import 'package:movie_app/features/home/presentation/widgets/home_search_bar.dart';
import 'package:movie_app/features/home/presentation/widgets/movie_categories.dart';
import 'package:movie_app/features/home/presentation/widgets/most_popular_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (_) => getIt<HomeCubit>()..loadHomeData(),
      child: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            _section(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: SizedBox(height: 22.h),
            ),
            _section(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: const HomeHeader(),
            ),
            _section(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 26.w),
              child: const HomeSearchBar(),
            ),
            _section(
              padding: const EdgeInsets.only(bottom: 24),
              child: const FeaturedMovieCarousel(),
            ),
            _section(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: const MovieCategories(),
            ),
            _section(
              padding: const EdgeInsets.only(bottom: 20),
              child: const MostPopularSection(),
            ),
          ],
        ),
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
