import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/theme/app_colors.dart';

class MoviePoster extends StatelessWidget {
  final String imageUrl;

  const MoviePoster({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200.w,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: AspectRatio(
          aspectRatio: 2 / 3,
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: AppColors.headerButtonColor,
                child: Icon(
                  Icons.movie,
                  size: 56.w,
                  color: AppColors.tertiaryTextColor,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
