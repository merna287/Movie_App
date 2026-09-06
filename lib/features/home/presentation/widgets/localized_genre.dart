import 'package:easy_localization/easy_localization.dart';
import 'package:movie_app/core/localization/locale_keys.g.dart';

String localizedGenreName(String genre) {
  switch (genre) {
    case 'Action':
      return LocaleKeys.genreAction.tr();
    case 'Adventure':
      return LocaleKeys.genreAdventure.tr();
    case 'Animation':
      return LocaleKeys.genreAnimation.tr();
    case 'Comedy':
      return LocaleKeys.genreComedy.tr();
    case 'Crime':
      return LocaleKeys.genreCrime.tr();
    case 'Documentary':
      return LocaleKeys.genreDocumentary.tr();
    case 'Drama':
      return LocaleKeys.genreDrama.tr();
    case 'Family':
      return LocaleKeys.genreFamily.tr();
    case 'Fantasy':
      return LocaleKeys.genreFantasy.tr();
    case 'History':
      return LocaleKeys.genreHistory.tr();
    case 'Horror':
      return LocaleKeys.genreHorror.tr();
    case 'Music':
      return LocaleKeys.genreMusic.tr();
    case 'Mystery':
      return LocaleKeys.genreMystery.tr();
    case 'Romance':
      return LocaleKeys.genreRomance.tr();
    case 'Science Fiction':
      return LocaleKeys.genreScienceFiction.tr();
    case 'Sci-Fi':
      return LocaleKeys.genreSciFi.tr();
    case 'TV Movie':
      return LocaleKeys.genreTvMovie.tr();
    case 'Thriller':
      return LocaleKeys.genreThriller.tr();
    case 'War':
      return LocaleKeys.genreWar.tr();
    case 'Western':
      return LocaleKeys.genreWestern.tr();
    default:
      return genre;
  }
}
