
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
  Future Function(Database) articles = (Database data) async {
    return db.open(data);
  };
  Future Function(Database) bookmarks = (Database data) async {
    return db.open(data);
  };

  database();
}
class _database {
  String task_name = 'tasks';
  List<String> task_columns = [
    'id', 'title', 'description', 'due', 'finish', 'completed', 'date'
  ];

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

  String articles_name = 'articles';
  List<String> articles_columns = [
    'id', 'user', 'title', 'description', 'date'
  ];

  String bookmarks_name = 'bookmarks';
  List<String> bookmarks_columns = [
    'id', 'article', 'user', 'value', 'date'
  ];

  Future<void> open(Database db) async {
    await db.execute('''
      create table $task_name( 
        ${task_columns[0]} text primary key,
        ${task_columns[1]} text,
        ${task_columns[2]} text,
        ${task_columns[3]} text,
        ${task_columns[4]} text,
        ${task_columns[5]} text,
        ${task_columns[6]} text
        )''');

    await db.execute('''
      create table $bookmarks_name( 
        ${bookmarks_columns[0]} text primary key,
        ${bookmarks_columns[1]} text,
        ${bookmarks_columns[2]} text,
        ${bookmarks_columns[3]} text,
        ${bookmarks_columns[4]} text
        )''');

    await db.execute('''
      create table $articles_name( 
        ${articles_columns[0]} text primary key,
        ${articles_columns[1]} text,
        ${articles_columns[2]} text,
        ${articles_columns[3]} text,
        ${articles_columns[4]} text
        )''');

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