import '../models/models.dart';

// ExploreData serves as a data container that holds
// list of cinemas, movie genres, and friend reviews.
class ExploreData {
  final List<Cinema> cinemas;
  final List<MovieGenre> genres;
  final List<Review> friendReviews;

  ExploreData(this.cinemas, this.genres, this.friendReviews);
}

// Mock CinemaScope service that grabs sample data to mock up a movie app request/response
class MockCinemaService {
  // Batch request that gets both nearby cinemas and friend's feed
  Future<ExploreData> getExploreData() async {
    final nearByCinemas = await _getCinemas();
    final movieGenres = await _getGenres();
    final friendReviews = await _getFriendFeed();

    return ExploreData(nearByCinemas, movieGenres, friendReviews);
  }

  // Get sample movie genres to display in ui
  Future<List<MovieGenre>> _getGenres() async {
    // Simulate api request wait time
    await Future.delayed(const Duration(milliseconds: 50));
    // Return mock genres
    return genres;
  }

  // Get the friend reviews to display in ui
  Future<List<Review>> _getFriendFeed() async {
    // Simulate api request wait time
    await Future.delayed(const Duration(milliseconds: 50));
    // Return mock reviews
    return reviews;
  }

  // Get the cinemas to display in ui
  Future<List<Cinema>> _getCinemas() async {
    // Simulate api request wait time
    await Future.delayed(const Duration(milliseconds: 50));
    // Return mock cinemas
    return cinemas;
  }
}
