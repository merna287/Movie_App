import 'package:movie_app/features/details/domain/entities/cast_member.dart';
import 'package:movie_app/features/details/domain/entities/crew_member.dart';

class MovieCredits {
  final List<CastMember> cast;
  final List<CrewMember> crew;

  const MovieCredits({required this.cast, required this.crew});
}
