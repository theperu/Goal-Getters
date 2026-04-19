import 'package:sqflite/sqflite.dart';

abstract class Migration {
  final int version;
  final String description;

  Migration({required this.version, required this.description});

  Future<void> up(Database db);
}
