import 'package:drift/drift.dart';
import 'database_connection.dart';

part 'local_database.g.dart';

class FavoriteCinemas extends Table {
  TextColumn get id           => text()();
  TextColumn get name         => text()();
  TextColumn get address      => text()();
  TextColumn get attributes   => text()();
  TextColumn get imageUrl     => text()();
  TextColumn get imageCredits => text()();
  RealColumn get distance     => real()();
  RealColumn get rating       => real()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [FavoriteCinemas])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        // Recreate table with primary key
        await migrator.drop(favoriteCinemas);
        await migrator.createTable(favoriteCinemas);
      }
    },
  );

  Future<List<FavoriteCinema>> getAllFavorites() =>
      select(favoriteCinemas).get();

  Future<void> insertFavorite(FavoriteCinemasCompanion entry) =>
      into(favoriteCinemas).insertOnConflictUpdate(entry);

  Future<void> deleteFavorite(String id) =>
      (delete(favoriteCinemas)..where((t) => t.id.equals(id))).go();

  Future<void> clearFavorites() => delete(favoriteCinemas).go();
}