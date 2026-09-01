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
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: SizedBox(height: 22.h),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: const HomeHeader(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 26.w),
              child: const HomeSearchBar(),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: const FeaturedMovieCarousel(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: const MovieCategories(),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: const MostPopularSection(),
            ),
          ],
        ),
      ),
    );
  }
}
