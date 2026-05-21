import 'package:flutter/material.dart';
import '../animations/animations.dart';
import '../models/models.dart';

class CinemaItem extends StatelessWidget {
  final MovieTicket item;
  final String? cinemaId;

  const CinemaItem({Key? key, required this.item, this.cinemaId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: _buildListItem()),
        _buildImageStack(colorScheme),
      ],
    );
  }

  Widget _buildListItem() {
    return ListTile(
      contentPadding: const EdgeInsets.all(8.0),
      title: Text(item.name),
      subtitle: _buildSubtitle(),
    );
  }

  Widget _buildSubtitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDescription(),
        const SizedBox(height: 4),
        _buildPriceAndRating(),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      item.description,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPriceAndRating() {
    return Row(
      children: [
        Text('\$${item.price.toStringAsFixed(2)}'),
        const SizedBox(width: 4),
        const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
      ],
    );
  }

  Widget _buildImageStack(ColorScheme colorScheme) {
    return Stack(
      children: [
        _buildImage(),
        _buildAddButton(colorScheme),
      ],
    );
  }

  Widget _buildImage() {
    final image = Image.network(item.imageUrl, fit: BoxFit.cover);
    final clipped = ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: AspectRatio(aspectRatio: 1.0, child: image),
    );
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: cinemaId != null
          ? Hero(
              tag: HeroTags.ticketImage(cinemaId!, item.name),
              child: Material(type: MaterialType.transparency, child: clipped),
            )
          : clipped,
    );
  }

  Widget _buildAddButton(ColorScheme colorScheme) {
    return Positioned(
      bottom: 8.0,
      right: 8.0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Text(
          'Book',
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
            color: colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
