
import 'dart:convert';

import 'package:beautyreformatory/services/helpers/response.dart';
import 'package:beautyreformatory/services/models/bookmark.dart';
import 'package:beautyreformatory/utilities/database.dart';
import 'package:beautyreformatory/utilities/exceptions.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

import 'package:beautyreformatory/utilities/environment.dart' as env;

class BookmarkMiddleware {

  static _BookmarkProvider _provider = new _BookmarkProvider();

  static Future<List<Bookmark>> listFromResponse(Response response) async {
    if(!response.result){
      throw ResponseException(response.message);
    } else {
      return (response.payload as Iterable).map((f) {
        Bookmark m = Bookmark.fromJson(f);

        return m;
      }).toList();
    }
  }
  static Future<Bookmark> fromResponse(Response response) async {
    if(!response.result) {
      throw ResponseException(response.message);
    } else {
      return Bookmark.fromJson(response.payload);
    }
  }

  static Future<Bookmark> fromSave(String id) async {
    return _provider.open(env.database).then((_BookmarkProvider provider) {
      return provider.get(id);
    });
  }
  static Future<void> toSave(Bookmark bookmark) async {
    return _provider.open(env.database).then((_BookmarkProvider provider) {
      return provider.insert(bookmark);
    }).catchError((error) {
      return _provider.update(bookmark);
    });
  }
  static Future<List<Bookmark>> listFromSave() {
    return _provider.open(env.database).then((_BookmarkProvider provider) {
      return provider.list();
    }).catchError((error) =>
        debugPrint(error.toString())
    );
  }

  static Future<void> listToSave(List<Bookmark> bookmarks) {
    return _provider.open(env.database).then((_BookmarkProvider provider) {
      return provider.put(bookmarks);
    });
  }

  static Future<void> toTrash(String id) async {
    return _provider.open(env.database).then((_BookmarkProvider provider) {
      return provider.delete(id);
    });
  }
  static Future<void> clearSave() async {
    return _provider.open(env.database).then((_BookmarkProvider provider) {

      provider.db.rawDelete('DELETE FROM ${provider.name}').then((value) {
        provider.close();
      });
    });
  }
}
class _BookmarkProvider {
  String name = 'bookmarks';
  List<String> columns = [
    'id', 'article', 'user', 'value', 'date'
  ];

  Database db;

  Future<_BookmarkProvider> open(String path) async {
    db = await openDatabase(
        await getDatabasesPath() + path,
        version: 1,
        onCreate: (Database db, int version) async {
          await database().bookmarks(db);
        }
    );

    return this;
  }

  Future<Bookmark> insert(Bookmark bookmark) async {
    Map<String, dynamic> m = bookmark.toJson();
    try {
      await db.insert(name, m);
    } catch(e) {
      await update(bookmark);
    }
    return bookmark;
  }
  Future<List<Bookmark>> put(List<Bookmark> bookmarks) async {
    for(int i = 0; i < bookmarks.length; i++) {
      await insert(bookmarks[i]);
    }
    return bookmarks;
  }

  Future<Bookmark> get(String id) async {
    List<Map> maps = await db.query(name,
        columns: columns,
        where: '${columns[0]} = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Bookmark.fromJson(maps.first);
    }
    return null;
  }
  Future<List<Bookmark>> list() async {
    List<Map> bookmarks = await db.query(name);

    return bookmarks.map((message) {
      Bookmark m = Bookmark(
        id: message[columns[0]],
        article: message[columns[1]],
        user: message[columns[2]],
        value: message[columns[3]],
        date: jsonDecode(message[columns[4]]),
      );

      return m;
    }).toList();

  }

  Future<int> delete(String id) async {
    return await db.delete(name, where: '${columns[0]} = ?', whereArgs: [id]);
  }
  Future<Bookmark> update(Bookmark bookmark) async {
    Map<String, dynamic> f = bookmark.toJson();

    await db.update(name, f,
        where: '${columns[0]} = ?', whereArgs: [bookmark.id]);
    return bookmark;
  }

  Future close() async => db.close();
}