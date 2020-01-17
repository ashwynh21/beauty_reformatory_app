
import 'dart:convert';

import 'package:beautyreformatory/services/helpers/response.dart';
import 'package:beautyreformatory/services/models/article.dart';
import 'package:beautyreformatory/services/models/user.dart';
import 'package:beautyreformatory/utilities/database.dart';
import 'package:beautyreformatory/utilities/exceptions.dart';

import 'package:beautyreformatory/utilities/environment.dart' as env;
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class ArticleMiddleware {
  static _ArticleProvider _provider = new _ArticleProvider();

  ArticleMiddleware();

  static Future<List<Article>> listFromResponse(Response response) async {
    if(!response.result){
      throw ResponseException(response.message);
    } else {
      return (response.payload as Iterable).map((f) {
        Article m = Article.fromJson(f);

        return m;
      }).toList();
    }
  }
  static Future<Article> fromResponse(Response response) async {
    if(!response.result) {
      throw ResponseException(response.message);
    } else {
      return Article.fromJson(response.payload);
    }
  }

  static Future<Article> fromSave(String id) async {
    return _provider.open(env.database).then((_ArticleProvider provider) {
      return provider.get(id);
    });
  }
  static Future<void> toSave(Article article) async {
    return _provider.open(env.database).then((_ArticleProvider provider) {
      return provider.insert(article);
    }).catchError((error) {
      return _provider.update(article);
    });
  }
  static Future<List<Article>> listFromSave() {
    return _provider.open(env.database).then((_ArticleProvider provider) {
      return provider.list();
    }).catchError((error) =>
        debugPrint(error.toString())
    );
  }

  static Future<void> listToSave(List<Article> articles) {
    return _provider.open(env.database).then((_ArticleProvider provider) {
      return provider.put(articles);
    });
  }

  static Future<void> toTrash(String id) async {
    return _provider.open(env.database).then((_ArticleProvider provider) {
      return provider.delete(id);
    });
  }
  static Future<void> clearSave() async {
    return _provider.open(env.database).then((_ArticleProvider provider) {

      provider.db.rawDelete('DELETE FROM ${provider.name}').then((value) {
        provider.close();
      });
    });
  }
}
class _ArticleProvider {
  String name = 'articles';
  List<String> columns = [
    'id', 'user', 'title', 'description', 'date'
  ];

  Database db;

  Future<_ArticleProvider> open(String path) async {
    db = await openDatabase(
        await getDatabasesPath() + path,
        version: 1,
        onCreate: (Database db, int version) async {
          await database().articles(db);
        }
    );

    return this;
  }

  Future<Article> insert(Article article) async {
    try {
      await db.insert(name, article.toSQL());
    } catch(e) {
      await update(article);
    }
    return article;
  }
  Future<List<Article>> put(List<Article> articles) async {
    for(int i = 0; i < articles.length; i++) {
      await insert(articles[i]);
    }
    return articles;
  }

  Future<Article> get(String id) async {
    List<Map> maps = await db.query(name,
        columns: columns,
        where: '${columns[0]} = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Article.fromJson(maps.first);
    }
    return null;
  }
  Future<List<Article>> list() async {
    List<Map> articles = await db.query(name);

    return articles.map((article) {
      Article a = Article(
        id: article[columns[0]],
        user: User.fromJson(jsonDecode(article[columns[1]])),
        title: article[columns[2]],
        description: article[columns[3]],
        date: jsonDecode(article[columns[4]]),
      );

      return a;
    }).toList();

  }

  Future<int> delete(String id) async {
    return await db.delete(name, where: '${columns[0]} = ?', whereArgs: [id]);
  }
  Future<Article> update(Article article) async {
    Map<String, dynamic> f = article.toSQL();

    await db.update(name, f,
        where: '${columns[0]} = ?', whereArgs: [article.id]);
    return article;
  }

  Future close() async => db.close();
}