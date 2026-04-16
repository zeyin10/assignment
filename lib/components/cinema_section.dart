import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../components/components.dart';
import '../models/models.dart';
import '../constants.dart';

class CinemaSection extends StatelessWidget {
  final List<Cinema> cinemas;
  final CartManager cartManager;
  final OrderManager orderManager;

  const CinemaSection(
      {super.key,
      required this.cinemas,
      required this.cartManager,
      required this.orderManager});

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
                      onTap: () {
                        context.go('/${CinemaScopeTab.home.value}/cinema/${cinemas[index].id}');
                      },
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
