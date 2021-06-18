import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbProvider {
  DbProvider._();
  static final DbProvider db = DbProvider._();
  static Database? _usersDb;

  Future<Database> get database async {
    if (_usersDb != null) return _usersDb as Database;
    _usersDb = await initDb();
    return _usersDb as Database;
  }

  initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String usersPath = join(documentsDirectory.path, 'app_db');
    return await openDatabase(
      usersPath,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute("CREATE TABLE users"
            "(idUser INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT, passwd TEXT)");
        await db.execute(
            "INSERT INTO users"
            "('email','passwd')"
            "VALUES (?, ?)",
            ['renatobonfim@flutter.com', 'ksjjshdukksjsi']);
      },
    );
  }
}
