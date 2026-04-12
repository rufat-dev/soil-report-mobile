// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_database.dart';

// ignore_for_file: type=lint
class $CacheTableTable extends CacheTable
    with TableInfo<$CacheTableTable, CacheTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CacheTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value, timestamp];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cache_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CacheTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  CacheTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CacheTableData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
    );
  }

  @override
  $CacheTableTable createAlias(String alias) {
    return $CacheTableTable(attachedDatabase, alias);
  }
}

class CacheTableData extends DataClass implements Insertable<CacheTableData> {
  final String key;
  final String value;
  final DateTime timestamp;
  const CacheTableData({
    required this.key,
    required this.value,
    required this.timestamp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  CacheTableCompanion toCompanion(bool nullToAbsent) {
    return CacheTableCompanion(
      key: Value(key),
      value: Value(value),
      timestamp: Value(timestamp),
    );
  }

  factory CacheTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CacheTableData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  CacheTableData copyWith({String? key, String? value, DateTime? timestamp}) =>
      CacheTableData(
        key: key ?? this.key,
        value: value ?? this.value,
        timestamp: timestamp ?? this.timestamp,
      );
  CacheTableData copyWithCompanion(CacheTableCompanion data) {
    return CacheTableData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CacheTableData(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CacheTableData &&
          other.key == this.key &&
          other.value == this.value &&
          other.timestamp == this.timestamp);
}

class CacheTableCompanion extends UpdateCompanion<CacheTableData> {
  final Value<String> key;
  final Value<String> value;
  final Value<DateTime> timestamp;
  final Value<int> rowid;
  const CacheTableCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CacheTableCompanion.insert({
    required String key,
    required String value,
    this.timestamp = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<CacheTableData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? timestamp,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (timestamp != null) 'timestamp': timestamp,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CacheTableCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<DateTime>? timestamp,
    Value<int>? rowid,
  }) {
    return CacheTableCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      timestamp: timestamp ?? this.timestamp,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CacheTableCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('timestamp: $timestamp, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$CacheDatabase extends GeneratedDatabase {
  _$CacheDatabase(QueryExecutor e) : super(e);
  $CacheDatabaseManager get managers => $CacheDatabaseManager(this);
  late final $CacheTableTable cacheTable = $CacheTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [cacheTable];
}

typedef $$CacheTableTableCreateCompanionBuilder =
    CacheTableCompanion Function({
      required String key,
      required String value,
      Value<DateTime> timestamp,
      Value<int> rowid,
    });
typedef $$CacheTableTableUpdateCompanionBuilder =
    CacheTableCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<DateTime> timestamp,
      Value<int> rowid,
    });

class $$CacheTableTableFilterComposer
    extends Composer<_$CacheDatabase, $CacheTableTable> {
  $$CacheTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CacheTableTableOrderingComposer
    extends Composer<_$CacheDatabase, $CacheTableTable> {
  $$CacheTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CacheTableTableAnnotationComposer
    extends Composer<_$CacheDatabase, $CacheTableTable> {
  $$CacheTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);
}

class $$CacheTableTableTableManager
    extends
        RootTableManager<
          _$CacheDatabase,
          $CacheTableTable,
          CacheTableData,
          $$CacheTableTableFilterComposer,
          $$CacheTableTableOrderingComposer,
          $$CacheTableTableAnnotationComposer,
          $$CacheTableTableCreateCompanionBuilder,
          $$CacheTableTableUpdateCompanionBuilder,
          (
            CacheTableData,
            BaseReferences<_$CacheDatabase, $CacheTableTable, CacheTableData>,
          ),
          CacheTableData,
          PrefetchHooks Function()
        > {
  $$CacheTableTableTableManager(_$CacheDatabase db, $CacheTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CacheTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CacheTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CacheTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CacheTableCompanion(
                key: key,
                value: value,
                timestamp: timestamp,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<DateTime> timestamp = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CacheTableCompanion.insert(
                key: key,
                value: value,
                timestamp: timestamp,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CacheTableTableProcessedTableManager =
    ProcessedTableManager<
      _$CacheDatabase,
      $CacheTableTable,
      CacheTableData,
      $$CacheTableTableFilterComposer,
      $$CacheTableTableOrderingComposer,
      $$CacheTableTableAnnotationComposer,
      $$CacheTableTableCreateCompanionBuilder,
      $$CacheTableTableUpdateCompanionBuilder,
      (
        CacheTableData,
        BaseReferences<_$CacheDatabase, $CacheTableTable, CacheTableData>,
      ),
      CacheTableData,
      PrefetchHooks Function()
    >;

class $CacheDatabaseManager {
  final _$CacheDatabase _db;
  $CacheDatabaseManager(this._db);
  $$CacheTableTableTableManager get cacheTable =>
      $$CacheTableTableTableManager(_db, _db.cacheTable);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$cacheDatabaseHash() => r'323a3b65b7a797f5dc3310a6223be96e1818fc78';

/// See also [cacheDatabase].
@ProviderFor(cacheDatabase)
final cacheDatabaseProvider = Provider<CacheDatabase>.internal(
  cacheDatabase,
  name: r'cacheDatabaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cacheDatabaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CacheDatabaseRef = ProviderRef<CacheDatabase>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
