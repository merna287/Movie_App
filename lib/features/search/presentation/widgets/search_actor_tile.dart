import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';
import 'package:movie_app/features/search/domain/entities/actor.dart';

class SearchActorTile extends StatelessWidget {
  final Actor actor;
  final String query;

  const SearchActorTile({
    super.key,
    required this.actor,
    this.query = '',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72.w,
      child: Column(
        children: [
          Container(
            width: 64.w,
            height: 64.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.boxColor,
            ),
            clipBehavior: Clip.antiAlias,
            child: actor.imageUrl.isEmpty
                ? Icon(
                    Icons.person,
                    size: 28.w,
                    color: AppColors.tertiaryTextColor,
                  )
                : Image.network(
                    actor.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.person,
                        size: 28.w,
                        color: AppColors.tertiaryTextColor,
                      );
                    },
                  ),
          ),
          SizedBox(height: 8.h),
          _buildName(),
        ],
      ),
    );
  }

  Widget _buildName() {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      return Text(
        actor.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: AppTypography.withColor(
          AppTypography.montserrat12W500,
          AppColors.primaryTextColor,
        ),
      );
    }

    final lowerName = actor.name.toLowerCase();
    final lowerQuery = trimmedQuery.toLowerCase();
    final matchIndex = lowerName.indexOf(lowerQuery);

    if (matchIndex == -1) {
      return Text(
        actor.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: AppTypography.withColor(
          AppTypography.montserrat12W500,
          AppColors.primaryTextColor,
        ),
      );
    }

    final boldStyle = AppTypography.withColor(
      AppTypography.montserrat12W500.copyWith(fontWeight: FontWeight.w600),
      AppColors.primaryTextColor,
    );
    final normalStyle = AppTypography.withColor(
      AppTypography.montserrat12W500.copyWith(fontWeight: FontWeight.w400),
      AppColors.grayColor,
    );

    final spans = <TextSpan>[];
    if (matchIndex > 0) {
      spans.add(
        TextSpan(
          text: actor.name.substring(0, matchIndex),
          style: normalStyle,
        ),
      );
    }

    spans.add(
      TextSpan(
        text: actor.name.substring(matchIndex, matchIndex + trimmedQuery.length),
        style: boldStyle,
      ),
    );

    if (matchIndex + trimmedQuery.length < actor.name.length) {
      spans.add(
        TextSpan(
          text: actor.name.substring(matchIndex + trimmedQuery.length),
          style: normalStyle,
        ),
      );
    }

    return Text.rich(
      TextSpan(children: spans),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    );
  }
}