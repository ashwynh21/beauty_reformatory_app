import 'dart:convert';

import 'package:beautyreformatory/services/helpers/response.dart';
import 'package:beautyreformatory/services/models/task.dart';
import 'package:beautyreformatory/utilities/database.dart';
import 'package:beautyreformatory/utilities/exceptions.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

import 'package:beautyreformatory/utilities/environment.dart' as env;

class TaskMiddleware {

    TaskMiddleware();
    static _TaskProvider _provider = new _TaskProvider();

    static Future<List<Task>> listFromResponse(Response response) async {
        if(!response.result){
            throw ResponseException(response.message);
        } else {
            return (response.payload as Iterable).map((f) {
                Task m = Task.fromJson(f);

                return m;
            }).toList();
        }
    }
    static Future<Task> fromResponse(Response response) async {
        if(!response.result) {
            throw ResponseException(response.message);
        } else {
            return Task.fromJson(response.payload);
        }
    }

    static Future<Task> fromSave(String id) async {
        return _provider.open(env.database).then((_TaskProvider provider) {
            return provider.get(id);
        });
    }
    static Future<void> toSave(Task task) async {
        return _provider.open(env.database).then((_TaskProvider provider) {
            return provider.insert(task);
        }).catchError((error) {
            return _provider.update(task);
        });
    }
    static Future<List<Task>> listFromSave() {
        return _provider.open(env.database).then((_TaskProvider provider) {
            return provider.list();
        }).catchError((error) =>
            debugPrint(error.toString())
        );
    }

    static Future<void> listToSave(List<Task> tasks) {
        return _provider.open(env.database).then((_TaskProvider provider) {
            return provider.put(tasks);
        });
    }

    static Future<void> toTrash(String id) async {
        return _provider.open(env.database).then((_TaskProvider provider) {
            return provider.delete(id);
        });
    }
    static Future<void> clearSave() async {
        return _provider.open(env.database).then((_TaskProvider provider) {

            provider.db.rawDelete('DELETE FROM ${provider.name}').then((value) {
                provider.close();
            });
        });
    }
}
class _TaskProvider {

    String name = 'tasks';
    List<String> columns = [
        'id', 'title', 'description', 'due', 'finish', 'completed', 'date'
    ];

    Database db;

    Future<_TaskProvider> open(String path) async {
        db = await openDatabase(
            await getDatabasesPath() + path,
            version: 1,
            onCreate: (Database db, int version) async {
                await database().bookmarks(db);
            }
        );

        return this;
    }

    Future<Task> insert(Task task) async {
        Map<String, dynamic> m = task.toSQL();
        try {
            await db.insert(name, m);
        } catch(e) {
            await update(task);
        }
        return task;
    }
    Future<List<Task>> put(List<Task> tasks) async {
        for(int i = 0; i < tasks.length; i++) {
            await insert(tasks[i]);
        }
        return tasks;
    }

    Future<Task> get(String id) async {
        List<Map> maps = await db.query(name,
            columns: columns,
            where: '${columns[0]} = ?',
            whereArgs: [id]);
        if (maps.length > 0) {
            return Task.fromJson(maps.first);
        }
        return null;
    }
    Future<List<Task>> list() async {
        List<Map> tasks = await db.query(name);

        return tasks.map((message) {
            Task m = Task(
                id: message[columns[0]],
                title: message[columns[1]],
                description: message[columns[2]],
                due: jsonDecode(message[columns[3]]),
                finish: jsonDecode(message[columns[4]]),
                completed: message[columns[5]],
                date: jsonDecode(message[columns[6]]),
            );

            return m;
        }).toList();

    }

    Future<int> delete(String id) async {
        return await db.delete(name, where: '${columns[0]} = ?', whereArgs: [id]);
    }
    Future<Task> update(Task task) async {
        Map<String, dynamic> f = task.toJson();

        await db.update(name, f,
            where: '${columns[0]} = ?', whereArgs: [task.id]);
        return task;
    }

    Future close() async => db.close();
}