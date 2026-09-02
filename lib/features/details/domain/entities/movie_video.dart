class MovieVideo {
  final String key;
  final String site;
  final String type;
  final String name;

  const MovieVideo({
    required this.key,
    this.site = '',
    this.type = '',
    this.name = '',
  });

  bool get isUsableTrailer => key.isNotEmpty && site.toLowerCase() == 'youtube';

  String get watchUrl => 'https://www.youtube.com/watch?v=$key';
}
