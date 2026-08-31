import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/features/home/presentation/mock/home_mock_data.dart';
import 'package:movie_app/features/home/presentation/widgets/home_section_header.dart';
import 'package:movie_app/features/home/presentation/widgets/movie_card.dart';

class MostPopularSection extends StatelessWidget {
  final List<HomeMovie> popularMovies;

  const MostPopularSection({super.key, required this.popularMovies});

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
        SizedBox(
          height: 231.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            itemCount: popularMovies.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(left: index == 0 ? 0 : 12.w),
                child: MovieCard(movie: popularMovies[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}
