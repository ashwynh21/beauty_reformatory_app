
import 'package:sqflite/sqlite_api.dart';

class database {
  static _database db = new _database();

  Future Function(Database) friendships = (Database data) async {
    return db.open(data);
  };
  Future Function(Database) emotions = (Database data) async {
    return db.open(data);
  };
  Future Function(Database) abuse = (Database data) async {
    return db.open(data);
  };

  database();
}
class _database {
  String friendship_name = 'friendships';
  List<String> friendship_columns = [
    'id', 'subject', 'initiator', 'state', 'date'
  ];

  String emotions_name = 'emotions';
  List<String> emotions_columns = [
    'id', 'user', 'mood', 'date'
  ];

  String abuse_name = 'abuse';
  List<String> abuse_columns = [
    'id', 'user', 'description', 'date'
  ];

  String messages_name = 'messages';
  List<String> messages_columns = [
    'id', 'friendship', 'sender', 'recipient', 'state', 'message', 'date'
  ];

  Future<void> open(Database db) async {
    await db.execute('''
      create table $friendship_name( 
        ${friendship_columns[0]} text primary key,
        ${friendship_columns[1]} text,
        ${friendship_columns[2]} text,
        ${friendship_columns[3]} integer,
        ${friendship_columns[4]} text
        )''');

    await db.execute('''
      create table $emotions_name( 
        ${emotions_columns[0]} text primary key,
        ${emotions_columns[1]} text,
        ${emotions_columns[2]} text,
        ${emotions_columns[3]} text
        )''');

    await db.execute('''
      create table $abuse_name( 
        ${abuse_columns[0]} text primary key,
        ${abuse_columns[1]} text,
        ${abuse_columns[2]} text,
        ${abuse_columns[3]} text
        )''');

    await db.execute('''
      create table $messages_name( 
        ${messages_columns[0]} text primary key,
        ${messages_columns[1]} text,
        ${messages_columns[2]} text,
        ${messages_columns[3]} text,
        ${messages_columns[4]} integer,
        ${messages_columns[5]} text,
        ${messages_columns[6]} text
        )''');
  }
}