import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_app/core/constants/app_assets.dart';
import 'package:movie_app/core/theme/app_colors.dart';
import 'package:movie_app/core/theme/app_typography.dart';

/// Shared profile avatar.
///
/// When the user has a profile image it is displayed as-is. Otherwise a
/// deterministic colored circle with the first letter of the user's name is
/// shown. The color is derived from the name so the same user always gets the
/// same color, and the circle updates whenever the name changes.
class ProfileAvatar extends StatelessWidget {
  final String? name;
  final String? imageUrl;
  final double radius;

  const ProfileAvatar({
    super.key,
    required this.radius,
    this.name,
    this.imageUrl,
  });

  static const List<Color> _palette = [
    Color(0xFF12CDD9),
    Color(0xFF6C5CE7),
    Color(0xFFE84393),
    Color(0xFF00B894),
    Color(0xFF0984E3),
    Color(0xFFE17055),
    Color(0xFFFD79A8),
    Color(0xFFA29BFE),
    Color(0xFF00CEC9),
    Color(0xFFFDCB6E),
  ];

  static Color colorFor(String name) {
    final normalized = name.trim();
    if (normalized.isEmpty) return AppColors.headerButtonColor;
    final index = (normalized.hashCode & 0x7FFFFFFF) % _palette.length;
    return _palette[index];
  }

  String? get _initial {
    final resolved = name?.trim() ?? '';
    if (resolved.isEmpty) return null;
    return resolved.characters.first.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final url = imageUrl?.trim() ?? '';
    if (url.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.boxColor,
        foregroundImage: NetworkImage(url),
        onForegroundImageError: (_, _) {},
      );
    }

    final initial = _initial;
    if (initial != null) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: colorFor(name ?? ''),
        child: Center(
          child: Text(
            initial,
            style: AppTypography.withColor(
              AppTypography.montserrat16W600.copyWith(
                fontSize: (radius * 0.6).clamp(12.0, 64.0).toDouble(),
              ),
              AppColors.whiteColor,
            ),
          ),
        ),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.headerButtonColor,
      child: SvgPicture.asset(
        AppAssets.personIcon,
        width: radius * 0.62,
        height: radius * 0.62,
        colorFilter: ColorFilter.mode(
          AppColors.tertiaryTextColor,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}