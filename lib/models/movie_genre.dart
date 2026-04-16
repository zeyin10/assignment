class MovieGenre {
  String name;
  int numberOfMovies;
  String imageUrl;

  MovieGenre(this.name, this.numberOfMovies, this.imageUrl);
}

List<MovieGenre> genres = [
  MovieGenre('Action', 42, 'assets/categories/action.jfif'),
  MovieGenre('Drama', 38, 'assets/categories/drama.png'),
  MovieGenre('Comedy', 31, 'assets/categories/comedy.jfif'),
  MovieGenre('Thriller', 27, 'assets/categories/triller.png'),
  MovieGenre('Sci-Fi', 24, 'assets/categories/sci-fi.jfif'),
  MovieGenre('Horror', 19, 'assets/categories/horror.jfif'),
  MovieGenre('Romance', 22, 'assets/categories/romance.jpg'),
  MovieGenre('Animation', 15, 'assets/categories/animation.jfif'),
  MovieGenre('Documentary', 18, 'assets/categories/documentary.jfif'),
  MovieGenre('Fantasy', 20, 'assets/categories/fantasy.jfif'),
  MovieGenre('Crime', 25, 'assets/categories/crime.jfif'),
  MovieGenre('Adventure', 29, 'assets/categories/adventure.jfif'),
];
