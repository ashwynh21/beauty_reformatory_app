import 'dart:convert';

import 'package:beautyreformatory/services/helpers/response.dart';
import 'package:beautyreformatory/services/models/friendship.dart';
import 'package:beautyreformatory/services/models/user.dart';
import 'package:beautyreformatory/utilities/database.dart';
import 'package:beautyreformatory/utilities/exceptions.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

import 'package:beautyreformatory/utilities/environment.dart' as env;

class FriendshipMiddleware {
    static _FriendshipProvider _provider = new _FriendshipProvider();

    FriendshipMiddleware();

    static Future<List<Friendship>> listFromResponse(Response response) async {
        if(!response.result){
            throw ResponseException(response.message);
        } else {
            return (response.payload as Iterable).map((f) => Friendship.fromJson(f)).toList();
        }
    }
    static Future<Friendship> fromResponse(Response response) async {
        if(!response.result) {
            throw ResponseException(response.message);
        } else {
            return Friendship.fromJson(response.payload);
        }
    }

    static Future<Friendship> fromSave(String id) async {
        return _provider.open(env.database).then((_FriendshipProvider provider) {
            return provider.get(id);
        });
    }
    
    static Future<void> toSave(Friendship friendship) async {
        return _provider.open(env.database).then((_FriendshipProvider provider) {
            return provider.insert(friendship);
        }).catchError((error) {
            return _provider.update(friendship);
        });
    }
    static Future<List<Friendship>> listFromSave() {
        return _provider.open(env.database).then((_FriendshipProvider provider) {
            return provider.list();
        }).catchError((error) =>
            debugPrint(error.toString()));
    }
    static Future<void> listToSave(List<Friendship> friendships) {
        return _provider.open(env.database).then((_FriendshipProvider provider) {
            return provider.put(friendships);
        });
    }

    static Future<void> toTrash(String id) async {
        return _provider.open(env.database).then((_FriendshipProvider provider) {
            return provider.delete(id);
        });
    }
    static Future<void> clearSave() async {
        return _provider.open(env.database).then((_FriendshipProvider provider) {

            provider.db.rawDelete('DELETE FROM ${provider.name}').then((value) {
                provider.close();
            });
        });
    }
}

class _FriendshipProvider {
    String name = 'friendships';
    List<String> columns = [
        'id', 'subject', 'initiator', 'state', 'date'
    ];

    Database db;

    Future<_FriendshipProvider> open(String path) async {
        db = await openDatabase(
            await getDatabasesPath() + path,
            version: 1,
            onCreate: (Database db, int version) async {
                await database().friendships(db);
            }
        );

        return this;
    }

    Future<Friendship> insert(Friendship friendship) async {
        Map<String, dynamic> f = friendship.toSQL();
        f.remove('memberships');
        f.remove('messages');

        try {
            friendship.id = (await db.insert(name, f)).toString();
        } catch(e) {
            friendship.id = (await update(friendship)).toString();
        }
        return friendship;
    }
    Future<List<Friendship>> put(List<Friendship> friendship) async {
        for(int i = 0; i < friendship.length; i++) {
            await insert(friendship[i]);
        }
        return friendship;
    }

    Future<Friendship> get(String id) async {
        List<Map> maps = await db.query(name,
            columns: columns,
            where: '${columns[0]} = ?',
            whereArgs: [id]);
        if (maps.length > 0) {
            return Friendship.fromJson(maps.first);
        }
        return null;
    }
    Future<List<Friendship>> list() async {
        List<Map> friendships = await db.query(name);

        return friendships.map((friendship) {
            Friendship f = Friendship(
                id: friendship[columns[0]],
                subject: User.fromJson(jsonDecode(friendship[columns[1]])),
                initiator: User.fromJson(jsonDecode(friendship[columns[2]])),
                state: friendship[columns[3]] == 'null' ? 0 : friendship[columns[3]],
                date: jsonDecode(friendship[columns[4]]),
            );

            return f;
        }).toList();

    }

    Future<int> delete(String id) async {
        return await db.delete(name, where: '${columns[0]} = ?', whereArgs: [id]);
    }
    Future<Friendship> update(Friendship friendship) async {
        Map<String, dynamic> f = friendship.toSQL();
        f.remove('memberships');
        f.remove('messages');

        await db.update(name, f,
            where: '${columns[0]} = ?', whereArgs: [friendship.id]);
        return friendship;
    }

    Future close() async => db.close();
}