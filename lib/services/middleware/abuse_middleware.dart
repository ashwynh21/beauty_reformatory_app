
import 'dart:convert';

import 'package:beautyreformatory/services/helpers/response.dart';
import 'package:beautyreformatory/services/models/abuse.dart';
import 'package:beautyreformatory/services/models/user.dart';
import 'package:beautyreformatory/utilities/database.dart';
import 'package:beautyreformatory/utilities/exceptions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

import 'package:beautyreformatory/utilities/environment.dart' as env;

class AbuseMiddleware {
  static _AbuseProvider _provider = new _AbuseProvider();

  AbuseMiddleware();

  static Future<List<Abuse>> listFromResponse(Response response) async {
    if(!response.result){
      throw ResponseException(response.message);
    } else {
      return (response.payload as Iterable).map((a) => Abuse.fromJson(a)).toList();
    }
  }
  static Future<Abuse> fromResponse(Response response) async {
    if(!response.result) {
      throw ResponseException(response.message);
    } else {
      return Abuse.fromJson(response.payload);
    }
  }

  static Future<Abuse> fromSave(String id) async {
    return _provider.open(env.database).then((_AbuseProvider provider) {
      return provider.get(id);
    });
  }
  static Future<void> toSave(Abuse abuse) async {
    return _provider.open(env.database).then((_AbuseProvider provider) {
      return provider.insert(abuse);
    }).catchError((error) {
      return _provider.update(abuse);
    });
  }
  static Future<List<Abuse>> listFromSave() {
    return _provider.open(env.database).then((_AbuseProvider provider) {
      return provider.list();
    });
  }
  static Future<void> listToSave(List<Abuse> abuse) {
    return _provider.open(env.database).then((_AbuseProvider provider) {
      return provider.put(abuse);
    });
  }

  static Future<void> toTrash(String id) async {
    return _provider.open(env.database).then((_AbuseProvider provider) {
      return provider.delete(id);
    });
  }
  static Future<void> clearSave() async {
    return _provider.open(env.database).then((_AbuseProvider provider) {

      provider.db.rawDelete('DELETE FROM ${provider.name}').then((value) {
        provider.close();
      });
    });
  }
}
class _AbuseProvider {
  String name = 'abuse';
  List<String> columns = [
    'id', 'user', 'description', 'date'
  ];

  Database db;

  Future<_AbuseProvider> open(String path) async {
    db = await openDatabase(
        await getDatabasesPath() + path,
        version: 1,
        onCreate: (Database db, int version) async {
          await database().abuse(db);
        }
    );

    return this;
  }

  Future<Abuse> insert(Abuse abuse) async {
    Map<String, dynamic> f = abuse.toSQL();

    try {
      abuse.id = (await db.insert(name, f)).toString();
    } catch(e) {
      abuse.id = (await update(abuse)).toString();
    }
    return abuse;
  }
  Future<List<Abuse>> put(List<Abuse> abuse) async {
    for(int i = 0; i < abuse.length; i++) {
      await insert(abuse[i]);
    }
    return abuse;
  }

  Future<Abuse> get(String id) async {
    List<Map> maps = await db.query(name,
        columns: columns,
        where: '${columns[0]} = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Abuse.fromJson(maps.first);
    }
    return null;
  }
  Future<List<Abuse>> list() async {
    List<Map> friendships = await db.query(name);

    return friendships.map((abuse) {

      Abuse f = Abuse(
        id: abuse[columns[0]],
        user: User.fromJson(jsonDecode(abuse[columns[1]])),
        description: abuse[columns[2]],
        date: jsonDecode(abuse[columns[4]]),
      );

      return f;
    }).toList();

  }

  Future<int> delete(String id) async {
    return await db.delete(name, where: '${columns[0]} = ?', whereArgs: [id]);
  }
  Future<Abuse> update(Abuse abuse) async {
    Map<String, dynamic> f = abuse.toSQL();

    await db.update(name, f,
        where: '${columns[0]} = ?', whereArgs: [abuse.id]);
    return abuse;
  }

  Future close() async => db.close();
}