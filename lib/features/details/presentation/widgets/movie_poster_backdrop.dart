import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:movie_app/core/theme/app_colors.dart';

class MoviePosterBackdrop extends StatelessWidget {
  final String imageUrl;

  const MoviePosterBackdrop({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.backgroundColor.withValues(alpha: 0.06),
              AppColors.backgroundColor.withValues(alpha: 0.14),
              AppColors.backgroundColor.withValues(alpha: 0.38),
              AppColors.backgroundColor.withValues(alpha: 0.82),
              AppColors.backgroundColor,
            ],
            stops: const [0.0, 0.30, 0.55, 0.78, 1.0],
          ),
        ),
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) =>
                const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}
