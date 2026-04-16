import 'package:flutter/material.dart';
import '../components/components.dart';
import '../models/models.dart';

class GenreSection extends StatelessWidget {
  final List<MovieGenre> genres;
  const GenreSection({super.key, required this.genres});

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
              'Browse by Genre',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 275,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: genres.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 200,
                  child: GenreCard(genre: genres[index], index: index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
