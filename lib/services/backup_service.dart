import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';

import 'database/goal_getters_database.dart';

class BackupService {
  static Future<String> _getDbPath() async {
    final dbPath = await getDatabasesPath();
    return join(dbPath, 'goal_getters.db');
  }

  /// Exports the database file via the system share sheet.
  static Future<bool> exportDatabase() async {
    // Close the current database connection to flush writes
    await GoalGettersDatabase.instance.close();

    final dbPath = await _getDbPath();
    final file = File(dbPath);
    if (!await file.exists()) return false;

    // Copy to a temp location with a user-friendly name
    final tempDir = await getTemporaryDirectory();
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-').split('.').first;
    final exportPath = join(tempDir.path, 'goal_getters_backup_$timestamp.db');
    await file.copy(exportPath);

    await Share.shareXFiles(
      [XFile(exportPath)],
    );

    // Re-open the database
    await GoalGettersDatabase.instance.database;

    return true;
  }

  /// Imports a database file picked by the user, replacing the current one.
  /// Returns true on success.
  static Future<bool> importDatabase() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result == null || result.files.single.path == null) return false;

    final pickedPath = result.files.single.path!;

    // Basic validation: try opening the picked file as a SQLite database
    try {
      final testDb = await openReadOnlyDatabase(pickedPath);
      // Check that it has the expected tables
      final tables = await testDb.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name IN ('weekly_goals', 'habits')",
      );
      await testDb.close();
      if (tables.isEmpty) return false;
    } catch (_) {
      return false;
    }

    // Close current database
    await GoalGettersDatabase.instance.close();

    final dbPath = await _getDbPath();

    // Replace with imported file
    final importedFile = File(pickedPath);
    await importedFile.copy(dbPath);

    // Re-open
    await GoalGettersDatabase.instance.database;

    return true;
  }
}
