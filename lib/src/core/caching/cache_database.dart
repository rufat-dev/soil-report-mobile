import 'dart:convert';

import "package:drift/drift.dart";
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part "cache_database.g.dart";

class CacheTable extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {key};
}

@DriftDatabase(tables: [CacheTable])
class CacheDatabase extends _$CacheDatabase {
  CacheDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'cache_database',
      native: const DriftNativeOptions(
        // By default, `driftDatabase` from `package:drift_flutter` stores the
        // database files in `getApplicationDocumentsDirectory()`.
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }

  Future<void> write<T>(
      String key,
      dynamic data,
      ) async {
    final json = switch (data) {
      Map<String, dynamic>() => jsonEncode(data),
      List() => jsonEncode(data),
      String() => data,
      _ => jsonEncode(data),
    };

    await into(cacheTable).insertOnConflictUpdate(
      CacheTableCompanion(  
        key: Value(key),
        value: Value(json),
        timestamp: Value(DateTime.now()),
      ),
    );
  }

  Future<void> remove(String key) => (delete(cacheTable)..where((tbl) => tbl.key.equals(key))).go();

  Future<T?> read<T>(
      String key,
      T Function(Map<String, dynamic> json) fromJson, {
      Duration maxAge = const Duration(days: 30),
      }) async {
    try{
      final row = await (select(cacheTable)
        ..where((tbl) => tbl.key.equals(key))
      ).getSingleOrNull();

      if(row == null) return null;
      final now = DateTime.now();
      final age = now.difference(row.timestamp);

      if (age > maxAge) {
        await (delete(cacheTable)..where((tbl) => tbl.key.equals(key))).go();
        return null;
      }

      final Map<String, dynamic> jsonMap = jsonDecode(row.value);
      final T cacheData = fromJson(jsonMap);

      if(cacheData != null) return cacheData;
      return null;
    } catch (_) {
      return null;
    }
  }
  Future<String?> rawRead(
      String key, {
        Duration maxAge = const Duration(days: 30),
      }) async {
    final row = await (select(cacheTable)
      ..where((tbl) => tbl.key.equals(key))
    ).getSingleOrNull();

    if(row == null) return null;
    final now = DateTime.now();
    final age = now.difference(row.timestamp);

    if (age > maxAge) {
      await (delete(cacheTable)..where((tbl) => tbl.key.equals(key))).go();
      return null;
    }
    return row.value;
  }


  Future<void> clear() async {
    await delete(cacheTable).go();
  }
}

@Riverpod(keepAlive: true)
CacheDatabase cacheDatabase(Ref ref) {
  return CacheDatabase();
}
