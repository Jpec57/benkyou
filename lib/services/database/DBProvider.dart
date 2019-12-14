import 'dart:convert';

import 'package:benkyou/services/database/Database.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqlite_api.dart' as Sqli;

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static AppDatabase _database;
  static const FIXTURES_PATH = 'lib/fixtures/dev/';

  Future<AppDatabase> get database async {
    if (_database != null)
      return _database;

    _database = await $FloorAppDatabase
        .databaseBuilder('flutter_database.db')
        .build();
    return _database;
  }

  Future<List<Map<String, dynamic>>> find(
      String type,
      {String where,
        List<dynamic> whereArgs,
        String groupBy,
        String having,
        String orderBy,
        int limit,
        int offset}) async {
    AppDatabase database = await DBProvider.db.database;
    return await database.database.query(type,
        where: where,
        whereArgs: whereArgs,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        limit: limit,
        offset: offset);
  }

  Future<int> update(String type,  Map<String, dynamic> values, String where,
      {List<dynamic> whereArgs}) async{
    AppDatabase database = await DBProvider.db.database;
    return await database.database
        .update(type, values, where: where, whereArgs: whereArgs);
  }

  static void insertFixtureInDatabase(Sqli.Database database, String tableName, String jsonFile){
    rootBundle.loadString(jsonFile).then((String jsonString) {
      List<dynamic> jsonDeck = jsonDecode(jsonString);
      jsonDeck.forEach((object){
        database.insert(tableName, object);
      });
    });
  }

  static void insertAllFixturesInDatabase(Sqli.Database database){
    insertFixtureInDatabase(database, 'Deck', '${FIXTURES_PATH}decks.json');
    insertFixtureInDatabase(database, 'Card', '${FIXTURES_PATH}cards.json');
    insertFixtureInDatabase(database, 'Answer', '${FIXTURES_PATH}answers.json');
  }

  static void resetDatabase(Sqli.Database database){
    database.delete('Deck');
    database.delete('Card');
    database.delete('Answer');
  }
}