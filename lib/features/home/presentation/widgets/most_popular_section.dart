import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:movie_app/features/home/presentation/cubit/home_state.dart';
import 'package:movie_app/features/home/presentation/widgets/home_section_header.dart';
import 'package:movie_app/features/home/presentation/widgets/movie_card.dart';

class MostPopularSection extends StatelessWidget {
  const MostPopularSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: HomeSectionHeader(
            titleKey: LocaleKeys.mostPopular,
            actionKey: LocaleKeys.seeAll,
            actionColor: AppColors.primaryColor,
            onActionTap: () {},
          ),
        ),
        SizedBox(height: 16.h),
        BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is! HomeSuccess) return const SizedBox.shrink();

            if (state.popularMovies.isEmpty) {
              return SizedBox(
                height: 231.h,
                child: Center(
                  child: Text(
                    'No popular movies available',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              );
            }

            return SizedBox(
              height: 231.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                itemCount: state.popularMovies.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(left: index == 0 ? 0 : 12.w),
                    child: MovieCard(movie: state.popularMovies[index]),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
