import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:movie_app/core/service/service_locator.dart';
import 'package:movie_app/features/favorite/presentation/cubit/favorite_cubit.dart';
import 'package:movie_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:movie_app/features/home/presentation/cubit/home_state.dart';
import 'package:movie_app/features/home/presentation/widgets/featured_movie_carousel.dart';
import 'package:movie_app/features/home/presentation/widgets/home_header.dart';
import 'package:movie_app/features/home/presentation/widgets/home_loading_shimmer.dart';
import 'package:movie_app/features/home/presentation/widgets/home_movie_sections.dart';
import 'package:movie_app/features/home/presentation/widgets/home_search_bar.dart';
import 'package:movie_app/features/home/presentation/widgets/movie_categories.dart';
import 'package:movie_app/features/search/presentation/cubit/search_cubit.dart';
import 'package:movie_app/features/search/presentation/views/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getIt<HomeCubit>().loadHomeData();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: getIt<HomeCubit>(),
        ),
        BlocProvider.value(
          value: getIt<FavoriteCubit>(),
        ),
      ],
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeInitial || state is HomeLoading) {
            return const SafeArea(child: HomeLoadingShimmer());
          }

          return SafeArea(
            child: ListView(
              padding: EdgeInsets.only(bottom: 24.h),
              children: <Widget>[
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: const HomeHeader(),
                ),
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Get.to(
                      () => BlocProvider.value(
                        value: getIt<SearchCubit>(),
                        child: const SearchScreen(),
                      ),
                    ),
                    child: const HomeSearchBar(),
                  ),
                ),
                SizedBox(height: 20.h),
                const FeaturedMovieCarousel(),
                SizedBox(height: 24.h),
                const MovieCategories(),
                SizedBox(height: 24.h),
                const HomeMovieSections(),
              ],
            ),
          );
        },
      ),
    );
  }
}
