
import 'package:sqflite/sqlite_api.dart';

class database {
  static _database db = new _database();

  Future Function(Database) friendships = (Database data) async {
    return db.open(data);
  };
  Future Function(Database) emotions = (Database data) async {
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
  }
}