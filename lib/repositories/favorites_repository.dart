import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import '../firebase/local_database.dart';
import '../models/cinema.dart';
import '../models/favorite_manager.dart';

class FavoritesRepository extends FavoriteManager {
  final AppDatabase _db;
  final _firestore = FirebaseFirestore.instance;
  String? _currentUserId;

  FavoritesRepository({required AppDatabase db}) : _db = db;

  void setCurrentUser(String? uid) {
    debugPrint('🔑 FavoritesRepository.setCurrentUser: $uid');
    _currentUserId = uid;
  }

  Future<void> init(String userId) async {
    debugPrint('🚀 FavoritesRepository.init: $userId');
    _currentUserId = userId;
    final rows = await _db.getAllFavorites();
    clearList();
    for (final c in rows.map(_rowToCinema)) {
      addToList(c);
    }
    notifyListeners();
    await _syncFromFirestore(userId);
  }

  Future<void> _syncFromFirestore(String userId) async {
    debugPrint('🔄 Syncing from Firestore for: $userId');
    final snap = await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .get();
    debugPrint('📦 Firestore returned ${snap.docs.length} favorites');
    await _db.clearFavorites();
    clearList();
    for (final doc in snap.docs) {
      final c = _docToCinema(doc.id, doc.data());
      addToList(c);
      await _db.insertFavorite(_toCompanion(c));
    }
    notifyListeners();
  }

  @override
  void toggleFavorite(Cinema cinema) {
    final uid = _currentUserId;
    debugPrint('⭐ toggleFavorite called. uid=$uid, cinema=${cinema.name}');
    if (uid == null) {
      debugPrint('❌ uid is null — falling back to in-memory only!');
      super.toggleFavorite(cinema);
      return;
    }
    isFavorite(cinema) ? _remove(cinema, uid) : _add(cinema, uid);
  }

  @override
  void removeFavorite(Cinema cinema) {
    final uid = _currentUserId;
    debugPrint('🗑️ removeFavorite called. uid=$uid');
    if (uid == null) { super.removeFavorite(cinema); return; }
    _remove(cinema, uid);
  }

  @override
  void clearAll() {
    super.clearAll();
    _db.clearFavorites();
  }

  Future<void> _add(Cinema cinema, String userId) async {
    debugPrint('➕ Adding to Firestore: ${cinema.name} for $userId');
    addToList(cinema);
    notifyListeners();
    await _db.insertFavorite(_toCompanion(cinema));
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(cinema.id)
          .set(_cinemaToMap(cinema));
      debugPrint('✅ Saved to Firestore successfully');
    } catch (e) {
      debugPrint('❌ Firestore write failed: $e');
    }
  }

  Future<void> _remove(Cinema cinema, String userId) async {
    debugPrint('➖ Removing from Firestore: ${cinema.name}');
    removeFromList(cinema);
    notifyListeners();
    await _db.deleteFavorite(cinema.id);
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(cinema.id)
        .delete();
  }

  FavoriteCinemasCompanion _toCompanion(Cinema c) => FavoriteCinemasCompanion(
    id: Value(c.id), name: Value(c.name), address: Value(c.address),
    attributes: Value(c.attributes), imageUrl: Value(c.imageUrl),
    imageCredits: Value(c.imageCredits), distance: Value(c.distance),
    rating: Value(c.rating),
  );

  Cinema _rowToCinema(FavoriteCinema r) =>
      Cinema(r.id, r.name, r.address, r.attributes, r.imageUrl,
          r.imageCredits, r.distance, r.rating, []);

  Cinema _docToCinema(String id, Map<String, dynamic> d) => Cinema(
    id,
    d['name']         as String? ?? '',
    d['address']      as String? ?? '',
    d['attributes']   as String? ?? '',
    d['imageUrl']     as String? ?? '',
    d['imageCredits'] as String? ?? '',
    (d['distance'] as num?)?.toDouble() ?? 0,
    (d['rating']   as num?)?.toDouble() ?? 0,
    [],
  );

  Map<String, dynamic> _cinemaToMap(Cinema c) => {
    'name': c.name, 'address': c.address, 'attributes': c.attributes,
    'imageUrl': c.imageUrl, 'imageCredits': c.imageCredits,
    'distance': c.distance, 'rating': c.rating,
  };
}