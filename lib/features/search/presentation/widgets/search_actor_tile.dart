import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';
import 'package:movie_app/features/search/domain/entities/actor.dart';

class SearchActorTile extends StatelessWidget {
  final Actor actor;

  const SearchActorTile({super.key, required this.actor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72.w,
      child: Column(
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.boxColor,
              border: Border.all(color: AppColors.borderColor, width: 1),
            ),
            clipBehavior: Clip.antiAlias,
            child: actor.imageUrl.isEmpty
                ? Icon(
                    Icons.person,
                    size: 26.w,
                    color: AppColors.tertiaryTextColor,
                  )
                : Image.network(
                    actor.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.person,
                        size: 26.w,
                        color: AppColors.tertiaryTextColor,
                      );
                    },
                  ),
          ),
          SizedBox(height: 6.h),
          Text(
            actor.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTypography.withColor(
              AppTypography.montserrat12W500,
              AppColors.primaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}