import 'dart:io';

import 'package:ifgpdemo/db/savemodel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();
  static Database _database;

  // creating the getter the database
  Future<Database> get database async {
    // check that we already have db
    if (_database != null) {
      return _database;
    }
    // _database = await _initDB("ifgp_app.db");
    _database = await initDB();
    return _database;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE bookmark (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        iduser INTEGER,
        idauthor INTEGER,
        author TEXT,
        idcontent INTEGER,
        datecontent TEXT,
        title TEXT,
        category TEXT,
        story TEXT,
        link TEXT,
        latitude REAL,
        longitude REAL,
        counterread INTEGER,
        image01 TEXT,
        image02 TEXT,
        image03 TEXT,
        image04 TEXT,
        favorite INTEGER,
        save INTEGER,
        comments INTEGER,
        share INTEGER
      )
      ''');
  }

  Future<List<Save>> getSaveList() async {
    final db = await database;
    var bookmark = await db.query('bookmark', orderBy: 'id');
    List<Save> saveList = bookmark.isNotEmpty
        ? bookmark.map((c) => Save.fromMap(c)).toList()
        : [];
    return saveList;
  }

  initDB() async {
    return await openDatabase(join(await getDatabasesPath(), "ifgp_app.db"),
        onCreate: (db, version) async {
      // create table save
      await db.execute('''
      CREATE TABLE bookmark (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        iduser INTEGER,
        idauthor INTEGER,
        author TEXT,
        idcontent INTEGER,
        datecontent TEXT,
        title TEXT,
        category TEXT,
        story TEXT,
        link TEXT,
        latitude REAL,
        longitude REAL,
        counterread INTEGER,
        image01 TEXT,
        image02 TEXT,
        image03 TEXT,
        image04 TEXT,
        favorite INTEGER,
        save INTEGER,
        comments INTEGER,
        share INTEGER
      )
      ''');
      // make sure that the name are similar to our model parameter names
    }, version: 1); // version - amount of tables
  }

  // create a function that will add a new bookmark
  addBookmark(Save save) async {
    final db = await database;
    db.insert(
      "bookmark",
      save.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // function that will fetch our database and return all the element
  Future<dynamic> savedList() async {
    final db = await database;
    var response = await db.query("bookmark");
    if (response.length == 0) {
      return Null;
    } else {
      var resultmap = response.toList();
      return resultmap.isNotEmpty ? resultmap : Null;
    }
  }

  // function that will delete item
  Future<int> deleteBookmark(int id) async {
    final db = await database;
    int count = await db.delete(
      'bookmark',
      where: 'id = ?',
      whereArgs: [id],
    );
    return count;
  }

  // close db
  Future close() async {
    final db = await database;
    db.close();
  }
}
