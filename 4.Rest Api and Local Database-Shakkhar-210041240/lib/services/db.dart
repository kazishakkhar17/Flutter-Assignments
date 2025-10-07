// services/db.dart
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart'; // Mobile/Desktop
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

import 'package:sembast_web/sembast_web.dart';

class AppDatabase {
  // Singleton
  static final AppDatabase instance = AppDatabase._internal();
  AppDatabase._internal();

  late Database _db;
  final _store = intMapStoreFactory.store('stories'); // Sembast store

  // Initialize database
  Future<void> init() async {
    if (kIsWeb) {
      // Web database
      _db = await databaseFactoryWeb.openDatabase('stories.db');
    } else {
      // Mobile/Desktop database
      final dir = await getApplicationDocumentsDirectory();
      final dbPath = join(dir.path, 'stories.db');
      _db = await databaseFactoryIo.openDatabase(dbPath);
    }
  }

  // Save multiple stories
  Future<void> saveStories(List<Map<String, dynamic>> stories) async {
    for (var story in stories) {
      // Use story['id'] as key to replace existing records
      await _store.record(story['id']).put(_db, story);
    }
  }

  // Get all stories
  Future<List<Map<String, dynamic>>> getStories() async {
    final records = await _store.find(
      _db,
      finder: Finder(sortOrders: [SortOrder(Field.key, false)]),
    );
    return records.map((r) => r.value).toList();
  }
}
