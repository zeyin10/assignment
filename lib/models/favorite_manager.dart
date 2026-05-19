import 'package:flutter/material.dart';
import 'cinema.dart';

class FavoriteManager extends ChangeNotifier {
  final List<Cinema> _favorites = [];

  List<Cinema> get favorites => List.unmodifiable(_favorites);
  int get count => _favorites.length;

  bool isFavorite(Cinema cinema) =>
      _favorites.any((item) => item.id == cinema.id);

  bool isFavoriteById(String id) =>
      _favorites.any((item) => item.id == id);

  void toggleFavorite(Cinema cinema) {
    isFavorite(cinema)
        ? _favorites.removeWhere((item) => item.id == cinema.id)
        : _favorites.add(cinema);
    notifyListeners();
  }

  void removeFavorite(Cinema cinema) {
    _favorites.removeWhere((item) => item.id == cinema.id);
    notifyListeners();
  }

  void clearAll() {
    _favorites.clear();
    notifyListeners();
  }

  // Protected helpers for subclasses — mutate list without notifying.
  void addToList(Cinema cinema) {
    if (!_favorites.any((c) => c.id == cinema.id)) _favorites.add(cinema);
  }

  void removeFromList(Cinema cinema) {
    _favorites.removeWhere((c) => c.id == cinema.id);
  }

  void clearList() => _favorites.clear();
}