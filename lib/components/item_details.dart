import 'dart:math';
import 'package:flutter/material.dart';
import '../models/models.dart';
import 'cart_control.dart';

String _uuid() {
  final rng = Random.secure();
  final bytes = List<int>.generate(16, (_) => rng.nextInt(256));
  bytes[6] = (bytes[6] & 0x0f) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;
  String hex(int b) => b.toRadixString(16).padLeft(2, '0');
  final h = bytes.map(hex).join();
  return '${h.substring(0, 8)}-${h.substring(8, 12)}-'
      '${h.substring(12, 16)}-${h.substring(16, 20)}-${h.substring(20)}';
}

class ItemDetails extends StatefulWidget {
  final MovieTicket item;
  final CartManager cartManager;
  final void Function() quantityUpdated;

  const ItemDetails({
    Key? key,
    required this.item,
    required this.cartManager,
    required this.quantityUpdated,
  }) : super(key: key);

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);
    final colorTheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.item.name, style: textTheme.headlineMedium),
              const SizedBox(height: 16.0),
              _featuredBadge(colorTheme),
              const SizedBox(height: 16.0),
              Text(widget.item.description),
              const SizedBox(height: 16.0),
              _itemImage(widget.item.imageUrl),
              const SizedBox(height: 16.0),
              _addToCartControl(widget.item),
            ],
          ),
        ],
      ),
    );
  }

  Widget _featuredBadge(ColorScheme colorTheme) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(4.0),
        color: colorTheme.onPrimary,
        child: const Text('#1 Featured'),
      ),
    );
  }

  Widget _itemImage(String imageUrl) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _addToCartControl(MovieTicket item) {
    return CartControl(
      addToCart: (number) {
        final cartItem = CartItem(
          id: _uuid(),
          name: item.name,
          price: item.price,
          quantity: number,
        );
        setState(() {
          widget.cartManager.addItem(cartItem);
          widget.quantityUpdated();
        });
        Navigator.pop(context);
      },
    );
  }
}