import 'dart:convert';

import 'package:beautyreformatory/services/helpers/response.dart';
import 'package:beautyreformatory/services/middleware/user_middleware.dart';
import 'package:beautyreformatory/services/models/friendship.dart';
import 'package:beautyreformatory/services/models/message.dart';
import 'package:beautyreformatory/services/models/user.dart';
import 'package:beautyreformatory/utilities/cyphers.dart';
import 'package:beautyreformatory/utilities/database.dart';
import 'package:beautyreformatory/utilities/exceptions.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:beautyreformatory/utilities/environment.dart' as env;

class MessageMiddleware {
    static _MessageProvider _provider = new _MessageProvider();

    MessageMiddleware();

    static Future<List<Message>> listFromResponse(Response response) async {
        if(!response.result){
            throw ResponseException(response.message);
        } else {
            return (response.payload as Iterable).map((f) {
                Message m = Message.fromJson(f);

                return m;
            }).toList();
        }
    }
    static Future<Message> fromResponse(Response response) async {
        if(!response.result) {
            throw ResponseException(response.message);
        } else {
            return Message.fromJson(response.payload);
        }
    }

    static Message fromMessageData(Map<String, String> data) {
        return Message(
            id: generateID(),
            friendship: new Friendship() ,
            message: data['message'],
            recipient:  (data.containsKey('friend') && data['friend'] != null) ? User(email: data['friend']) : null,
            sender:  (data.containsKey('email') && data['email'] != null) ? User(email: data['email']) : null,
            state: env.sending,
            date: {'date': DateTime.now().toIso8601String()}
        );
    }
    static Future<Message> fromSave(String id) async {
        return _provider.open(env.database).then((_MessageProvider provider) {
            return provider.get(id);
        });
    }
    static Future<void> toSave(Message message) async {
        return _provider.open(env.database).then((_MessageProvider provider) {
            return provider.insert(message);
        }).catchError((error) {
            return _provider.update(message);
        });
    }
    static Future<List<Message>> listFromSave() {
        return _provider.open(env.database).then((_MessageProvider provider) {
            return provider.list();
        }).catchError((error) =>
            debugPrint(error.toString())
        );
    }
    static Future<List<Message>> listFriendFromSave(String friend) {
        return _provider.open(env.database).then((_MessageProvider provider) {
            return provider.find(friend);
        }).catchError((error) =>
            debugPrint(error.toString())
        );
    }

    static Future<void> listToSave(List<Message> message) {
        return _provider.open(env.database).then((_MessageProvider provider) {
            return provider.put(message);
        });
    }

    static Future<void> toTrash(String id) async {
        return _provider.open(env.database).then((_MessageProvider provider) {
            return provider.delete(id);
        });
    }
    static Future<void> clearSave() async {
        return _provider.open(env.database).then((_MessageProvider provider) {

            provider.db.rawDelete('DELETE FROM ${provider.name}').then((value) {
                provider.close();
            });
        });
    }
}
class _MessageProvider {
    String name = 'messages';
    List<String> columns = [
        'id', 'friendship', 'sender', 'recipient', 'state', 'message', 'date'
    ];

    Database db;

    Future<_MessageProvider> open(String path) async {
        db = await openDatabase(
            await getDatabasesPath() + path,
            version: 1,
            onCreate: (Database db, int version) async {
                await database().friendships(db);
            }
        );

        return this;
    }

    Future<Message> insert(Message message) async {
        message.date['date'] = DateTime.now().toString();
        Map<String, dynamic> m = message.toSQL();
        try {
            await db.insert(name, m);
        } catch(e) {
            await update(message);
        }
        return message;
    }
    Future<List<Message>> put(List<Message> message) async {
        for(int i = 0; i < message.length; i++) {
            await insert(message[i]);
        }
        return message;
    }

    Future<Message> get(String id) async {
        List<Map> maps = await db.query(name,
            columns: columns,
            where: '${columns[0]} = ?',
            whereArgs: [id]);
        if (maps.length > 0) {
            return Message.fromJson(maps.first);
        }
        return null;
    }
    Future<List<Message>> list() async {
        List<Map> messages = await db.query(name);

        return messages.map((message) {
            Message m = Message(
                id: message[columns[0]],
                friendship: Friendship.fromJson(jsonDecode(message[columns[1]])),
                sender: User.fromJson(jsonDecode(message[columns[2]])),
                recipient: User.fromJson(jsonDecode(message[columns[3]])),
                state: message[columns[4]] == 'null' ? 0 : message[columns[4]],
                message: message[columns[5]] == 'null' ? 0 : message[columns[5]],
                date: jsonDecode(message[columns[6]]),
            );

            return m;
        }).toList();

    }
    Future<List<Message>> find(String email) async {
        User user = await UserMiddleware.fromSave();
        List<Map> messages = await db.query(name,
            // where: '(${columns[3]} = ? AND ${columns[2]} = ?) OR (${columns[2]} = ? AND ${columns[3]} = ?)',
            // whereArgs: [jsonEncode(User(email: email)), jsonEncode(User(email: user.email)), jsonEncode(User(email: email)), jsonEncode(User(email: user.email))],
            orderBy: 'date DESC',
        );

        return messages.map((message) {
            Message m = Message(
                id: message[columns[0]],
                friendship: Friendship.fromJson(jsonDecode(message[columns[1]])),
                sender: User.fromJson(jsonDecode(message[columns[2]])),
                recipient: User.fromJson(jsonDecode(message[columns[3]])),
                state: message[columns[4]] == 'null' ? 0 : message[columns[4]],
                message: message[columns[5]] == 'null' ? 0 : message[columns[5]],
                date: jsonDecode(message[columns[6]]),
            );

            return m;
        }).toList()..removeWhere((Message m) {
            return !(m.sender.email == email || m.recipient.email == email);
        });
    }

    Future<int> delete(String id) async {
        return await db.delete(name, where: '${columns[0]} = ?', whereArgs: [id]);
    }
    Future<Message> update(Message message) async {
        Map<String, dynamic> f = message.toSQL();
        f.remove('date');

        await db.update(name, f,
            where: '${columns[0]} = ?', whereArgs: [message.id]);
        return message;
    }

    Future close() async => db.close();
}