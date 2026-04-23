import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../components/components.dart';
import '../models/models.dart';
import '../constants.dart';

class CinemaSection extends StatelessWidget {
  final List<Cinema> cinemas;
  final CartManager cartManager;
  final OrderManager orderManager;
  final FavoriteManager favoriteManager;

  const CinemaSection({
    super.key,
    required this.cinemas,
    required this.cartManager,
    required this.orderManager,
    required this.favoriteManager,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16.0, bottom: 8.0),
            child: Text(
              'Cinemas near me',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          if (cinemas.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Text(
                'Nothing matched your search yet.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            )
          else
            SizedBox(
              height: 230,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: cinemas.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 300,
                    child: CinemaLandscapeCard(
                      cinema: cinemas[index],
                      favoriteManager: favoriteManager,
                      onTap: () {
                        context.go('/${CinemaScopeTab.home.value}/cinema/${cinemas[index].id}');
                      },
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
