// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database.dart';

// ignore_for_file: type=lint
class $FavoriteCinemasTable extends FavoriteCinemas
    with TableInfo<$FavoriteCinemasTable, FavoriteCinema> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoriteCinemasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _attributesMeta =
      const VerificationMeta('attributes');
  @override
  late final GeneratedColumn<String> attributes = GeneratedColumn<String>(
      'attributes', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _imageUrlMeta =
      const VerificationMeta('imageUrl');
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
      'image_url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _imageCreditsMeta =
      const VerificationMeta('imageCredits');
  @override
  late final GeneratedColumn<String> imageCredits = GeneratedColumn<String>(
      'image_credits', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _distanceMeta =
      const VerificationMeta('distance');
  @override
  late final GeneratedColumn<double> distance = GeneratedColumn<double>(
      'distance', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<double> rating = GeneratedColumn<double>(
      'rating', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, address, attributes, imageUrl, imageCredits, distance, rating];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorite_cinemas';
  @override
  VerificationContext validateIntegrity(Insertable<FavoriteCinema> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('attributes')) {
      context.handle(
          _attributesMeta,
          attributes.isAcceptableOrUnknown(
              data['attributes']!, _attributesMeta));
    } else if (isInserting) {
      context.missing(_attributesMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(_imageUrlMeta,
          imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta));
    } else if (isInserting) {
      context.missing(_imageUrlMeta);
    }
    if (data.containsKey('image_credits')) {
      context.handle(
          _imageCreditsMeta,
          imageCredits.isAcceptableOrUnknown(
              data['image_credits']!, _imageCreditsMeta));
    } else if (isInserting) {
      context.missing(_imageCreditsMeta);
    }
    if (data.containsKey('distance')) {
      context.handle(_distanceMeta,
          distance.isAcceptableOrUnknown(data['distance']!, _distanceMeta));
    } else if (isInserting) {
      context.missing(_distanceMeta);
    }
    if (data.containsKey('rating')) {
      context.handle(_ratingMeta,
          rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta));
    } else if (isInserting) {
      context.missing(_ratingMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FavoriteCinema map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FavoriteCinema(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address'])!,
      attributes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}attributes'])!,
      imageUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_url'])!,
      imageCredits: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_credits'])!,
      distance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}distance'])!,
      rating: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}rating'])!,
    );
  }

  @override
  $FavoriteCinemasTable createAlias(String alias) {
    return $FavoriteCinemasTable(attachedDatabase, alias);
  }
}

class FavoriteCinema extends DataClass implements Insertable<FavoriteCinema> {
  final String id;
  final String name;
  final String address;
  final String attributes;
  final String imageUrl;
  final String imageCredits;
  final double distance;
  final double rating;
  const FavoriteCinema(
      {required this.id,
      required this.name,
      required this.address,
      required this.attributes,
      required this.imageUrl,
      required this.imageCredits,
      required this.distance,
      required this.rating});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['address'] = Variable<String>(address);
    map['attributes'] = Variable<String>(attributes);
    map['image_url'] = Variable<String>(imageUrl);
    map['image_credits'] = Variable<String>(imageCredits);
    map['distance'] = Variable<double>(distance);
    map['rating'] = Variable<double>(rating);
    return map;
  }

  FavoriteCinemasCompanion toCompanion(bool nullToAbsent) {
    return FavoriteCinemasCompanion(
      id: Value(id),
      name: Value(name),
      address: Value(address),
      attributes: Value(attributes),
      imageUrl: Value(imageUrl),
      imageCredits: Value(imageCredits),
      distance: Value(distance),
      rating: Value(rating),
    );
  }

  factory FavoriteCinema.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FavoriteCinema(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      address: serializer.fromJson<String>(json['address']),
      attributes: serializer.fromJson<String>(json['attributes']),
      imageUrl: serializer.fromJson<String>(json['imageUrl']),
      imageCredits: serializer.fromJson<String>(json['imageCredits']),
      distance: serializer.fromJson<double>(json['distance']),
      rating: serializer.fromJson<double>(json['rating']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'address': serializer.toJson<String>(address),
      'attributes': serializer.toJson<String>(attributes),
      'imageUrl': serializer.toJson<String>(imageUrl),
      'imageCredits': serializer.toJson<String>(imageCredits),
      'distance': serializer.toJson<double>(distance),
      'rating': serializer.toJson<double>(rating),
    };
  }

  FavoriteCinema copyWith(
          {String? id,
          String? name,
          String? address,
          String? attributes,
          String? imageUrl,
          String? imageCredits,
          double? distance,
          double? rating}) =>
      FavoriteCinema(
        id: id ?? this.id,
        name: name ?? this.name,
        address: address ?? this.address,
        attributes: attributes ?? this.attributes,
        imageUrl: imageUrl ?? this.imageUrl,
        imageCredits: imageCredits ?? this.imageCredits,
        distance: distance ?? this.distance,
        rating: rating ?? this.rating,
      );
  FavoriteCinema copyWithCompanion(FavoriteCinemasCompanion data) {
    return FavoriteCinema(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      address: data.address.present ? data.address.value : this.address,
      attributes:
          data.attributes.present ? data.attributes.value : this.attributes,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      imageCredits: data.imageCredits.present
          ? data.imageCredits.value
          : this.imageCredits,
      distance: data.distance.present ? data.distance.value : this.distance,
      rating: data.rating.present ? data.rating.value : this.rating,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FavoriteCinema(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('attributes: $attributes, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('imageCredits: $imageCredits, ')
          ..write('distance: $distance, ')
          ..write('rating: $rating')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, address, attributes, imageUrl, imageCredits, distance, rating);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FavoriteCinema &&
          other.id == this.id &&
          other.name == this.name &&
          other.address == this.address &&
          other.attributes == this.attributes &&
          other.imageUrl == this.imageUrl &&
          other.imageCredits == this.imageCredits &&
          other.distance == this.distance &&
          other.rating == this.rating);
}

class FavoriteCinemasCompanion extends UpdateCompanion<FavoriteCinema> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> address;
  final Value<String> attributes;
  final Value<String> imageUrl;
  final Value<String> imageCredits;
  final Value<double> distance;
  final Value<double> rating;
  final Value<int> rowid;
  const FavoriteCinemasCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.address = const Value.absent(),
    this.attributes = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.imageCredits = const Value.absent(),
    this.distance = const Value.absent(),
    this.rating = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FavoriteCinemasCompanion.insert({
    required String id,
    required String name,
    required String address,
    required String attributes,
    required String imageUrl,
    required String imageCredits,
    required double distance,
    required double rating,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        address = Value(address),
        attributes = Value(attributes),
        imageUrl = Value(imageUrl),
        imageCredits = Value(imageCredits),
        distance = Value(distance),
        rating = Value(rating);
  static Insertable<FavoriteCinema> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? address,
    Expression<String>? attributes,
    Expression<String>? imageUrl,
    Expression<String>? imageCredits,
    Expression<double>? distance,
    Expression<double>? rating,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (address != null) 'address': address,
      if (attributes != null) 'attributes': attributes,
      if (imageUrl != null) 'image_url': imageUrl,
      if (imageCredits != null) 'image_credits': imageCredits,
      if (distance != null) 'distance': distance,
      if (rating != null) 'rating': rating,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FavoriteCinemasCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? address,
      Value<String>? attributes,
      Value<String>? imageUrl,
      Value<String>? imageCredits,
      Value<double>? distance,
      Value<double>? rating,
      Value<int>? rowid}) {
    return FavoriteCinemasCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      attributes: attributes ?? this.attributes,
      imageUrl: imageUrl ?? this.imageUrl,
      imageCredits: imageCredits ?? this.imageCredits,
      distance: distance ?? this.distance,
      rating: rating ?? this.rating,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (attributes.present) {
      map['attributes'] = Variable<String>(attributes.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (imageCredits.present) {
      map['image_credits'] = Variable<String>(imageCredits.value);
    }
    if (distance.present) {
      map['distance'] = Variable<double>(distance.value);
    }
    if (rating.present) {
      map['rating'] = Variable<double>(rating.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoriteCinemasCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('attributes: $attributes, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('imageCredits: $imageCredits, ')
          ..write('distance: $distance, ')
          ..write('rating: $rating, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FavoriteCinemasTable favoriteCinemas =
      $FavoriteCinemasTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [favoriteCinemas];
}

typedef $$FavoriteCinemasTableCreateCompanionBuilder = FavoriteCinemasCompanion
    Function({
  required String id,
  required String name,
  required String address,
  required String attributes,
  required String imageUrl,
  required String imageCredits,
  required double distance,
  required double rating,
  Value<int> rowid,
});
typedef $$FavoriteCinemasTableUpdateCompanionBuilder = FavoriteCinemasCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String> address,
  Value<String> attributes,
  Value<String> imageUrl,
  Value<String> imageCredits,
  Value<double> distance,
  Value<double> rating,
  Value<int> rowid,
});

class $$FavoriteCinemasTableFilterComposer
    extends Composer<_$AppDatabase, $FavoriteCinemasTable> {
  $$FavoriteCinemasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get attributes => $composableBuilder(
      column: $table.attributes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imageUrl => $composableBuilder(
      column: $table.imageUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imageCredits => $composableBuilder(
      column: $table.imageCredits, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get distance => $composableBuilder(
      column: $table.distance, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get rating => $composableBuilder(
      column: $table.rating, builder: (column) => ColumnFilters(column));
}

class $$FavoriteCinemasTableOrderingComposer
    extends Composer<_$AppDatabase, $FavoriteCinemasTable> {
  $$FavoriteCinemasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get attributes => $composableBuilder(
      column: $table.attributes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imageUrl => $composableBuilder(
      column: $table.imageUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imageCredits => $composableBuilder(
      column: $table.imageCredits,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get distance => $composableBuilder(
      column: $table.distance, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get rating => $composableBuilder(
      column: $table.rating, builder: (column) => ColumnOrderings(column));
}

class $$FavoriteCinemasTableAnnotationComposer
    extends Composer<_$AppDatabase, $FavoriteCinemasTable> {
  $$FavoriteCinemasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get attributes => $composableBuilder(
      column: $table.attributes, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get imageCredits => $composableBuilder(
      column: $table.imageCredits, builder: (column) => column);

  GeneratedColumn<double> get distance =>
      $composableBuilder(column: $table.distance, builder: (column) => column);

  GeneratedColumn<double> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);
}

class $$FavoriteCinemasTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FavoriteCinemasTable,
    FavoriteCinema,
    $$FavoriteCinemasTableFilterComposer,
    $$FavoriteCinemasTableOrderingComposer,
    $$FavoriteCinemasTableAnnotationComposer,
    $$FavoriteCinemasTableCreateCompanionBuilder,
    $$FavoriteCinemasTableUpdateCompanionBuilder,
    (
      FavoriteCinema,
      BaseReferences<_$AppDatabase, $FavoriteCinemasTable, FavoriteCinema>
    ),
    FavoriteCinema,
    PrefetchHooks Function()> {
  $$FavoriteCinemasTableTableManager(
      _$AppDatabase db, $FavoriteCinemasTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FavoriteCinemasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FavoriteCinemasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FavoriteCinemasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> address = const Value.absent(),
            Value<String> attributes = const Value.absent(),
            Value<String> imageUrl = const Value.absent(),
            Value<String> imageCredits = const Value.absent(),
            Value<double> distance = const Value.absent(),
            Value<double> rating = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FavoriteCinemasCompanion(
            id: id,
            name: name,
            address: address,
            attributes: attributes,
            imageUrl: imageUrl,
            imageCredits: imageCredits,
            distance: distance,
            rating: rating,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String address,
            required String attributes,
            required String imageUrl,
            required String imageCredits,
            required double distance,
            required double rating,
            Value<int> rowid = const Value.absent(),
          }) =>
              FavoriteCinemasCompanion.insert(
            id: id,
            name: name,
            address: address,
            attributes: attributes,
            imageUrl: imageUrl,
            imageCredits: imageCredits,
            distance: distance,
            rating: rating,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FavoriteCinemasTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FavoriteCinemasTable,
    FavoriteCinema,
    $$FavoriteCinemasTableFilterComposer,
    $$FavoriteCinemasTableOrderingComposer,
    $$FavoriteCinemasTableAnnotationComposer,
    $$FavoriteCinemasTableCreateCompanionBuilder,
    $$FavoriteCinemasTableUpdateCompanionBuilder,
    (
      FavoriteCinema,
      BaseReferences<_$AppDatabase, $FavoriteCinemasTable, FavoriteCinema>
    ),
    FavoriteCinema,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FavoriteCinemasTableTableManager get favoriteCinemas =>
      $$FavoriteCinemasTableTableManager(_db, _db.favoriteCinemas);
}
