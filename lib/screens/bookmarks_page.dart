import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/models.dart';
import '../constants.dart';

class BookmarksPage extends StatefulWidget {
  final FavoriteManager favoriteManager;

  const BookmarksPage({
    super.key,
    required this.favoriteManager,
  });

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late List<Cinema> _favorites;

  @override
  void initState() {
    super.initState();
    _favorites = List.from(widget.favoriteManager.favorites);
    widget.favoriteManager.addListener(_refresh);
  }

  void _refresh() {
    if (mounted) {
      setState(() {
        _favorites = List.from(widget.favoriteManager.favorites);
      });
    }
  }

  @override
  void dispose() {
    widget.favoriteManager.removeListener(_refresh);
    super.dispose();
  }

  void _onCinemaTap(Cinema cinema) {
    context.go('/${CinemaScopeTab.home.value}/cinema/${cinema.id}');
  }

  void _removeFavorite(Cinema cinema) {
    setState(() => _favorites.remove(cinema));
    widget.favoriteManager.removeFavorite(cinema);

    ScaffoldMessenger.of(_scaffoldKey.currentContext!).clearSnackBars();
    ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text('${cinema.name} removed from favorites'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => widget.favoriteManager.toggleFavorite(cinema),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Favorites',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        actions: [
          if (_favorites.isNotEmpty)
            TextButton.icon(
              onPressed: () => _showClearConfirmation(context),
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text('Clear all'),
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.error,
              ),
            ),
        ],
      ),
      body: _favorites.isEmpty
          ? _buildEmptyState(colorScheme)
          : _buildFavoritesList(colorScheme),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_outline, size: 72, color: colorScheme.outline),
          const SizedBox(height: 16),
          Text(
            'No favorites yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the bookmark icon on any cinema\nto save it here.',
            textAlign: TextAlign.center,
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Text(
            '${_favorites.length} saved cinema${_favorites.length == 1 ? '' : 's'}',
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _favorites.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final cinema = _favorites[index];
              return _buildCinemaCard(cinema, colorScheme);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCinemaCard(Cinema cinema, ColorScheme colorScheme) {
    return Dismissible(
      key: ValueKey(cinema.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _removeFavorite(cinema),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.delete_outline, color: colorScheme.onErrorContainer),
      ),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _onCinemaTap(cinema),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                _buildCinemaImage(cinema),
                const SizedBox(width: 14),
                Expanded(child: _buildCinemaInfo(cinema, colorScheme)),
                _buildTrailingActions(cinema, colorScheme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCinemaImage(Cinema cinema) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.asset(
        cinema.imageUrl,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: 80,
          height: 80,
          color: Colors.grey.shade300,
          child: const Icon(Icons.movie, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildCinemaInfo(Cinema cinema, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          cinema.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          cinema.attributes,
          style: TextStyle(
            color: colorScheme.primary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.star_rounded, size: 14, color: Colors.amber.shade600),
            const SizedBox(width: 3),
            Text(cinema.rating.toStringAsFixed(1),
                style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 8),
            Icon(Icons.near_me, size: 12, color: colorScheme.outline),
            const SizedBox(width: 3),
            Text('${cinema.distance.toStringAsFixed(1)} mi',
                style: TextStyle(fontSize: 12, color: colorScheme.outline)),
          ],
        ),
      ],
    );
  }

  Widget _buildTrailingActions(Cinema cinema, ColorScheme colorScheme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.bookmark, size: 20),
          color: colorScheme.primary,
          tooltip: 'Remove from favorites',
          onPressed: () => _removeFavorite(cinema),
        ),
        Icon(Icons.chevron_right, color: colorScheme.outline, size: 20),
      ],
    );
  }

  void _showClearConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear all favorites?'),
        content: const Text('This will remove all saved cinemas.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              widget.favoriteManager.clearAll();
              Navigator.of(ctx).pop();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Clear all'),
          ),
        ],
      ),
    );
  }
}