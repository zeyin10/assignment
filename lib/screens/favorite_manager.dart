import 'package:flutter/material.dart';
import '../models/cinema.dart';

class FavoriteManager extends ChangeNotifier {
  final List<Cinema> _favorites = [];

  List<Cinema> get favorites => List.unmodifiable(_favorites);

  int get count => _favorites.length;

  bool isFavorite(Cinema cinema) {
    return _favorites.any((item) => item.id == cinema.id);
  }

  bool isFavoriteById(String id) {
    return _favorites.any((item) => item.id == id);
  }

  void toggleFavorite(Cinema cinema) {
    if (isFavorite(cinema)) {
      _favorites.removeWhere((item) => item.id == cinema.id);
    } else {
      _favorites.add(cinema);
    }
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
}