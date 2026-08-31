class HomeMovie {
  final String title;
  final String imageUrl;
  final double rating;
  final String genre;
  final String releaseYear;

  const HomeMovie({
    required this.title,
    required this.imageUrl,
    required this.rating,
    required this.genre,
    required this.releaseYear,
  });
}

class HomeData {
  final String userName;
  final String avatarUrl;
  final List<HomeMovie> featuredMovies;
  final List<String> categories;
  final List<HomeMovie> popularMovies;

  const HomeData({
    required this.userName,
    required this.avatarUrl,
    required this.featuredMovies,
    required this.categories,
    required this.popularMovies,
  });
}

class HomeMockData {
  HomeMockData._();

  static const HomeData data = HomeData(
    userName: 'Smith',
    avatarUrl: 'https://i.pravatar.cc/150?img=3',
    featuredMovies: [
      HomeMovie(
        title: 'Black Panther: Wakanda Forever',
        imageUrl:
            'https://image.tmdb.org/t/p/w780/szOKQ1TyNi0fPfBA2lSOICt4OdT.jpg',
        rating: 4.5,
        genre: 'Action',
        releaseYear: '2022',
      ),
      HomeMovie(
        title: 'Doctor Strange',
        imageUrl:
            'https://image.tmdb.org/t/p/w780/uGBvst3iM5U7v9S9RcIS9eCg4yN.jpg',
        rating: 4.3,
        genre: 'Action',
        releaseYear: '2022',
      ),
      HomeMovie(
        title: 'Avengers: Endgame',
        imageUrl:
            'https://image.tmdb.org/t/p/w780/or06FN3Dka5tukK1e9sl16pB3iy.jpg',
        rating: 4.8,
        genre: 'Action',
        releaseYear: '2019',
      ),
    ],
    categories: [
      'All',
      'Comedy',
      'Animation',
      'Documentary',
      'Action',
      'Drama',
      'Horror',
      'Thriller',
      'Romance',
      'Sci-Fi',
    ],
    popularMovies: [
      HomeMovie(
        title: 'Spider-Man: No Way Home',
        imageUrl:
            'https://image.tmdb.org/t/p/w342/1g0dhYtq4irTY1GPXvft6k4YLjm.jpg',
        rating: 4.5,
        genre: 'Action',
        releaseYear: '2021',
      ),
      HomeMovie(
        title: 'Life of Pi',
        imageUrl:
            'https://image.tmdb.org/t/p/w342/ypm4VsFd22F383yF8BBvCOwi8D9.jpg',
        rating: 4.5,
        genre: 'Adventure',
        releaseYear: '2012',
      ),
      HomeMovie(
        title: 'Riverdale',
        imageUrl:
            'https://image.tmdb.org/t/p/w342/4XkM5Tv29NQq7aP4VBzmDJtPsEP.jpg',
        rating: 4.4,
        genre: 'Drama',
        releaseYear: '2017',
      ),
      HomeMovie(
        title: 'Interstellar',
        imageUrl:
            'https://image.tmdb.org/t/p/w342/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg',
        rating: 4.8,
        genre: 'Sci-Fi',
        releaseYear: '2014',
      ),
      HomeMovie(
        title: 'Inception',
        imageUrl:
            'https://image.tmdb.org/t/p/w342/oYuLEt3zVCKq57qu2F8dT7NIa6f.jpg',
        rating: 4.7,
        genre: 'Sci-Fi',
        releaseYear: '2010',
      ),
      HomeMovie(
        title: 'The Dark Knight',
        imageUrl:
            'https://image.tmdb.org/t/p/w342/qJ2tW6WMUDux911r6m7haRef0WH.jpg',
        rating: 4.9,
        genre: 'Crime',
        releaseYear: '2008',
      ),
      HomeMovie(
        title: 'Parasite',
        imageUrl:
            'https://image.tmdb.org/t/p/w342/7IiTTgloJzvGI1TAYymCfbfl3vT.jpg',
        rating: 4.8,
        genre: 'Thriller',
        releaseYear: '2019',
      ),
      HomeMovie(
        title: 'The Shawshank Redemption',
        imageUrl:
            'https://image.tmdb.org/t/p/w342/q6y0Go1tsGEsmtFryDOJo3dEmqu.jpg',
        rating: 4.9,
        genre: 'Drama',
        releaseYear: '1994',
      ),
      HomeMovie(
        title: 'La La Land',
        imageUrl:
            'https://image.tmdb.org/t/p/w342/ylXCdC106IKiarftHsM2u8kzhb0.jpg',
        rating: 4.4,
        genre: 'Romance',
        releaseYear: '2016',
      ),
      HomeMovie(
        title: 'Spirited Away',
        imageUrl:
            'https://image.tmdb.org/t/p/w342/39wmItIWsg5sZMyRUHLkWBcuVCM.jpg',
        rating: 4.8,
        genre: 'Animation',
        releaseYear: '2001',
      ),
      HomeMovie(
        title: 'The Conjuring',
        imageUrl:
            'https://image.tmdb.org/t/p/w342/wVYREutTvI2tmpprOkj4H5Z4IRt.jpg',
        rating: 4.3,
        genre: 'Horror',
        releaseYear: '2013',
      ),
      HomeMovie(
        title: 'Toy Story',
        imageUrl:
            'https://image.tmdb.org/t/p/w342/rhIRbceoE9lR4veEXuwCC2GRARz.jpg',
        rating: 4.5,
        genre: 'Animation',
        releaseYear: '1995',
      ),
    ],
  );
}
