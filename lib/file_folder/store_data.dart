import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';


class StoreData{
  static Future<void> createTables(sql.Database database) async {
    await database.execute( """CREATE TABLE notes(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        description TEXT )
      """ );
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'note.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }


  Future<int> addNote( String title, String description) async {
    final db = await StoreData.db();
    final data = {'title': title, 'description': description};

    final id = await db.insert('notes', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String,dynamic>>> fetchAll() async {
    final db = await StoreData.db();
    return db.query('notes', orderBy: "id");

  }

  static Future<void> deleteItem(int id) async {
    final db = await StoreData.db();
    try {
      await db.delete("notes", where: "id = ?", whereArgs: [id]);
    } catch (err) {

    }
  }
}
