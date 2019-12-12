import 'dart:convert';

import 'package:beautyreformatory/services/helpers/response.dart';
import 'package:beautyreformatory/services/middleware/user_middleware.dart';
import 'package:beautyreformatory/services/models/emotion.dart';
import 'package:beautyreformatory/services/models/user.dart';
import 'package:beautyreformatory/utilities/database.dart';
import 'package:beautyreformatory/utilities/exceptions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

import 'package:beautyreformatory/utilities/environment.dart' as env;

class EmotionMiddleware {
    static _EmotionsProvider _provider = new _EmotionsProvider();

    EmotionMiddleware();

    static Future<Emotion> fromResponse(Response response) async {
        if(!response.result){
            throw ResponseException(response.message);
        } else {
            Emotion emotion = Emotion.fromJson(response.payload);

            return emotion;
        }
    }
    static Future<List<Emotion>> listFromResponse(Response response) async {
        if(!response.result){
            throw ResponseException(response.message);
        } else {
            User user = await UserMiddleware.fromSave();
            return (response.payload as Iterable).map((f) {
                f['user'] = user.toJson();

                return Emotion.fromJson(f);
            }).toList();
        }
    }

    static Future<Emotion> fromSave(String id) async {
        return _provider.open(env.database).then((_EmotionsProvider provider) {
            return provider.get(id);
        });
    }
    static Future<void> toSave(Emotion emotion) {
        return _provider.open(env.database).then((_EmotionsProvider provider) {
            return provider.insert(emotion);
        }).catchError((error) {
            return _provider.update(emotion);
        });
    }
    static Future<List<Emotion>> listFromSave() {
        return _provider.open(env.database).then((_EmotionsProvider provider) {
            return provider.list();
        }).then((List<Emotion> emotions) => emotions..sort((a, b) => b.date['date'].compareTo(a.date['date'])));
    }
    static Future<void> listToSave(List<Emotion> emotions) {
        return _provider.open(env.database).then((_EmotionsProvider provider) {
            return provider.put(emotions);
        });
    }
    static Future<void> toTrash(String id) async {
        return _provider.open(env.database).then((_EmotionsProvider provider) {
            return provider.delete(id);
        });
    }
    static Future<void> clearSave() async {
        return _provider.open(env.database).then((_EmotionsProvider provider) {

            provider.db.rawDelete('DELETE FROM ${provider.name}').then((value) {
                provider.close();
            });
        });
    }

}
class _EmotionsProvider {
    String name = 'emotions';
    List<String> columns = [
        'id', 'user', 'mood', 'date'
    ];

    Database db;

    Future<_EmotionsProvider> open(String path) async {
        db = await openDatabase(
            await getDatabasesPath() + path,
            version: 1,
            onCreate: (Database db, int version) async {
                await database().emotions(db);
            }
        );

        return this;
    }

    Future<Emotion> insert(Emotion emotion) async {
        Map<String, dynamic> f = emotion.toSQL();

        try {
            emotion.id = (await db.insert(name, f)).toString();
        } catch(e) {
            emotion.id = (await update(emotion)).toString();
        }
        return emotion;
    }
    Future<List<Emotion>> put(List<Emotion> emotions) async {
        for(int i = 0; i < emotions.length; i++) {
            await insert(emotions[i]);
        }
        return emotions;
    }

    Future<Emotion> get(String id) async {
        List<Map> maps = await db.query(name,
            columns: columns,
            where: '${columns[0]} = ?',
            whereArgs: [id]);
        if (maps.length > 0) {
            return Emotion.fromJson(maps.first);
        }
        return null;
    }
    Future<List<Emotion>> list() async {
        List<Map> friendships = await db.query(name);

        return friendships.map((emotion) {

            Emotion f = Emotion(
                id: emotion[columns[0]],
                mood: emotion[columns[2]],
                user: (emotion.containsKey(columns[1]) && emotion[columns[1]] != null) ? User.fromJson(jsonDecode(emotion[columns[1]])) : null,
                date: jsonDecode(emotion[columns[3]]),
            );

            return f;
        }).toList();

    }

    Future<int> delete(String id) async {
        return await db.delete(name, where: '${columns[0]} = ?', whereArgs: [id]);
    }
    Future<Emotion> update(Emotion emotion) async {
        Map<String, dynamic> f = emotion.toSQL();

        await db.update(name, f,
            where: '${columns[0]} = ?', whereArgs: [emotion.id],);
        return emotion;
    }

    Future close() async => db.close();
}