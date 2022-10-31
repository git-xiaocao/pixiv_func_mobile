import 'dart:convert';

import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:pixiv_dart_api/model/illust.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';

class HistoryDB extends GetxService {
  static const _databaseName = 'history.db';
  static const _tableName = 'history';

  static final _lock = Lock();

  static Future<T> _exec<T>(Future<T> Function(Database db) func) async {
    return _lock.synchronized(() async {
      final db = await openDatabase(
        join(await getDatabasesPath(), _databaseName),
        onCreate: (Database db, int version) {
          return db.execute(
            '''
          CREATE TABLE $_tableName
          (
            id        INTEGER NOT NULL CONSTRAINT ${_tableName}_pk PRIMARY KEY AUTOINCREMENT,
            illust_id INTEGER NOT NULL,
            data_json TEXT NOT NULL
          );
          CREATE UNIQUE INDEX ${_tableName}_id_uindex ON $_tableName (id);
          CREATE UNIQUE INDEX ${_tableName}_illust_id_uindex ON $_tableName (illust_id);
          ''',
          );
        },
        version: 1,
      );
      return await func(db);
    });
  }

  static Future<int> insert(Illust illust) {
    return _exec((db) => db.insert(
          _tableName,
          {
            'illust_id': illust.id,
            'data_json': jsonEncode(illust.toJson()),
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        ));
  }

  static Future<List<Illust>> query(int offset, int limit) async {
    return _exec((db) => db
        .query(
          _tableName,
          offset: offset,
          limit: limit,
          orderBy: 'id DESC',
        )
        .then((result) => result.map((e) => Illust.fromJson(jsonDecode(e['data_json'] as String))).toList()));
  }

  static Future<int> delete(int illustId) {
    return _exec((db) => db.delete(_tableName, where: 'illust_id = ?', whereArgs: [illustId]));
  }

  static Future<bool> exist(int illustId) async {
    return _exec((db) => db.rawQuery('SELECT 1 FROM $_tableName WHERE illust_id = ?', [illustId]).then((result) => result.isNotEmpty));
  }

  static Future<int> count() async {
    return _exec((db) => db.rawQuery('SELECT COUNT(id) FROM $_tableName').then((result) => Sqflite.firstIntValue(result) as int));
  }

  static Future<void> clear() {
    return _exec((db) {
      final batch = db.batch();
      batch.delete(_tableName);
      batch.delete('sqlite_sequence', where: 'name = ?', whereArgs: [_tableName]);
      return batch.commit();
    });
  }
}
