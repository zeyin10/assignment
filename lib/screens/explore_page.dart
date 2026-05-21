import 'package:flutter/material.dart';
import '../animations/animations.dart';
import '../api/mock_cinema_service.dart';
import '../components/components.dart';
import '../models/models.dart';

class ExplorePage extends StatefulWidget {
  final CartManager cartManager;
  final OrderManager orderManager;
  final FavoriteManager favoriteManager;

  const ExplorePage({
    super.key,
    required this.cartManager,
    required this.orderManager,
    required this.favoriteManager,
  });

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final _mockService = MockCinemaService();
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  final _layerLink = LayerLink();

  String _searchQuery = '';
  final List<String> _searchHistory = [];

  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _removeOverlay();
    _searchFocusNode.removeListener(_onFocusChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (_searchFocusNode.hasFocus) {
      _showOverlay();
    } else {
      _removeOverlay();
    }
  }

  void _showOverlay() {
    if (_searchHistory.isEmpty) return;
    _removeOverlay();
    _overlayEntry = _buildOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _refreshOverlay() {
    if (_overlayEntry != null) {
      _removeOverlay();
      if (_searchFocusNode.hasFocus && _searchHistory.isNotEmpty) {
        _overlayEntry = _buildOverlayEntry();
        Overlay.of(context).insert(_overlayEntry!);
      }
    }
  }

  OverlayEntry _buildOverlayEntry() {
    final colorScheme = Theme.of(context).colorScheme;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width - 32,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 56),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            color: colorScheme.surfaceContainerHigh,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.outline),
              ),
              child: StatefulBuilder(
                builder: (context, setOverlayState) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 10, 8, 4),
                      child: Row(
                        children: [
                          Text(
                            'Recent searches',
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              _searchHistory.clear();
                              setOverlayState(() {});
                              _removeOverlay();
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Clear all',
                              style: TextStyle(
                                  color: colorScheme.primary, fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 1, color: colorScheme.outline),
                    ..._searchHistory.map((query) => ListTile(
                      dense: true,
                      leading: Icon(Icons.history,
                          color: colorScheme.onSurfaceVariant, size: 16),
                      title: Text(
                        query,
                        style: TextStyle(
                            color: colorScheme.onSurface, fontSize: 13),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.close,
                            color: colorScheme.onSurfaceVariant, size: 14),
                        onPressed: () {
                          _searchHistory.remove(query);
                          setOverlayState(() {});
                          if (_searchHistory.isEmpty) _removeOverlay();
                        },
                      ),
                      onTap: () => _applyHistory(query),
                    )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Cinema> _filterCinemas(List<Cinema> cinemas) {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return cinemas;

    return cinemas.where((cinema) {
      final movieText = cinema.items
          .map((m) => '${m.name} ${m.description}')
          .join(' ')
          .toLowerCase();

      return [cinema.name, cinema.attributes, cinema.address, movieText]
          .join(' ')
          .toLowerCase()
          .contains(query);
    }).toList();
  }

  void _onSearchSubmitted(String value) {
    final trimmed = value.trim();
    if (trimmed.isNotEmpty && !_searchHistory.contains(trimmed)) {
      _searchHistory.insert(0, trimmed);
      if (_searchHistory.length > 8) _searchHistory.removeLast();
    }
    _removeOverlay();
    _searchFocusNode.unfocus();
    setState(() => _searchQuery = trimmed);
  }

  void _applyHistory(String query) {
    _searchController.text = query;
    _searchController.selection =
        TextSelection.collapsed(offset: query.length);
    _removeOverlay();
    _searchFocusNode.unfocus();
    setState(() => _searchQuery = query);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _mockService.getExploreData(),
      builder: (context, AsyncSnapshot<ExploreData> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final cinemas = snapshot.data?.cinemas ?? [];
          final genres = snapshot.data?.genres ?? [];
          final reviews = snapshot.data?.friendReviews ?? [];
          final filteredCinemas = _filterCinemas(cinemas);

          return ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              _buildSearchBar(),
              if (_searchQuery.isNotEmpty) _buildResultsLabel(filteredCinemas),
              CinemaSection(
                cinemas: filteredCinemas,
                cartManager: widget.cartManager,
                orderManager: widget.orderManager,
                favoriteManager: widget.favoriteManager,
              ),
              ReviewSection(reviews: reviews),
              GenreSection(genres: genres),
            ],
          );
        } else {
          return const CinemaScopeLoader(
            message: 'Discovering cinemas…',
            useLottie: true,
          );
        }
      },
    );
  }

  Widget _buildSearchBar() {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: CompositedTransformTarget(
        link: _layerLink,
        child: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          onSubmitted: _onSearchSubmitted,
          textInputAction: TextInputAction.search,
          style: TextStyle(color: colorScheme.onSurface, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Search cinemas, movies, formats...',
            hintStyle:
            TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14),
            prefixIcon: Icon(Icons.search,
                color: colorScheme.onSurfaceVariant, size: 20),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
              icon: Icon(Icons.close,
                  color: colorScheme.onSurfaceVariant, size: 18),
              onPressed: () {
                _searchController.clear();
                setState(() => _searchQuery = '');
              },
            )
                : null,
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.outline)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.outline)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                BorderSide(color: colorScheme.primary, width: 1.5)),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildResultsLabel(List<Cinema> filtered) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: Text(
        filtered.isEmpty
            ? 'No results for "$_searchQuery"'
            : '${filtered.length} result${filtered.length == 1 ? '' : 's'} for "$_searchQuery"',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: filtered.isEmpty
              ? colorScheme.error
              : colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}