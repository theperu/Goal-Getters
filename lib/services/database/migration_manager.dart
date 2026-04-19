import 'package:sqflite/sqflite.dart';
import 'migrations/migration_registry.dart';

class MigrationManager {
  static Future<void> migrate(
      Database db, int fromVersion, int toVersion) async {
    final migrations = MigrationRegistry.getMigrations();

    for (final migration in migrations) {
      if (migration.version > fromVersion && migration.version <= toVersion) {
        await migration.up(db);
      }
    }
  }
}
