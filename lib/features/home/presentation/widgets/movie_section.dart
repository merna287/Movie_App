import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/features/home/domain/entities/movie.dart';
import 'package:movie_app/features/home/presentation/widgets/home_section_header.dart';
import 'package:movie_app/features/home/presentation/widgets/movie_card.dart';

class MovieSection extends StatelessWidget {
  final String title;
  final List<Movie> movies;
  final VoidCallback onSeeAll;
  final String? emptyMessage;

  const MovieSection({
    super.key,
    required this.title,
    required this.movies,
    required this.onSeeAll,
    this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: HomeSectionHeader(
            titleKey: title,
            actionKey: LocaleKeys.seeAll,
            actionColor: AppColors.primaryColor,
            onActionTap: onSeeAll,
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 231.h,
          child: movies.isEmpty
              ? Center(
                  child: Text(
                    (emptyMessage ?? LocaleKeys.noMoviesAvailable).tr(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(left: index == 0 ? 0 : 12.w),
                      child: SizedBox(
                        width: 135.w,
                        height: 231.h,
                        child: MovieCard(movie: movies[index]),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
