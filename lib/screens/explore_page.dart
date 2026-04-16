import 'package:flutter/material.dart';
import '../api/mock_cinema_service.dart';
import '../components/components.dart';
import '../models/models.dart';

class ExplorePage extends StatelessWidget {
  final mockService = MockCinemaService();
  final CartManager cartManager;
  final OrderManager orderManager;

  ExplorePage({
    super.key,
    required this.cartManager,
    required this.orderManager});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: mockService.getExploreData(),
      builder: (context, AsyncSnapshot<ExploreData> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final cinemas = snapshot.data?.cinemas ?? [];
          final genres = snapshot.data?.genres ?? [];
          final reviews = snapshot.data?.friendReviews ?? [];
          return ListView(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: [
                CinemaSection(
                  cinemas: cinemas,
                  cartManager: cartManager,
                  orderManager: orderManager,),
                ReviewSection(reviews: reviews),
                GenreSection(genres: genres),
              ]);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
