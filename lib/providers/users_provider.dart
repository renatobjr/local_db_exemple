import 'package:sqflite/sql.dart';
import 'package:local_db_exemple/models/user.dart';
import 'package:local_db_exemple/database/users_db.dart';

Future<List<User>> fetchAllUsers() async {
  try {
    final db = await DbProvider.db.database;
    final List<Map<String, dynamic>> maps = await db.query('users');

    return List.generate(
      maps.length,
      (i) {
        return User.fromMap(maps[i]);
      },
    );
  } catch (e) {
    return Future.error(e);
  }
}

Future<void> insertUser(User user) async {
  try {
    final db = await DbProvider.db.database;

    await db.insert('users', user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  } catch (e) {
    return Future.error(e);
  }
}

Future<void> removeUser(int id) async {
  try {
    final db = await DbProvider.db.database;

    await db.delete(
      'users',
      where: 'idUser = ?',
      whereArgs: [id],
    );
  } catch (e) {
    return Future.error(e);
  }
}

Future<User> getUserById(int id) async {
  try {
    final db = await DbProvider.db.database;
    var res = await db.query(
      'users',
      where: 'idUser = ?',
      whereArgs: [id],
    );
    return User.fromMap(res.first);
  } catch (e) {
    return Future.error(e);
  }
}

Future<void> updateUser(User u) async {
  try {
    final db = await DbProvider.db.database;

    await db.update(
      'users',
      u.toMap(),
      where: 'idUser = ?',
      whereArgs: [u.idUser],
    );
  } catch (e) {
    return Future.error(e);
  }
}
