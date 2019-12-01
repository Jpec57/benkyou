//import 'package:path/path.dart';
//import 'package:sqflite/sqflite.dart';
//
//const String CREATE_TABLE_CATEGORIES = "CREATE TABLE categories(id INTEGER PRIMARY KEY, title VARCHAR(255));";
//const String CREATE_TABLE_DECKS = "CREATE TABLE decks(id INTEGER PRIMARY KEY, title VARCHAR(255), cards );";
//const String CREATE_TABLE_CARDS = "CREATE TABLE cards(id INTEGER PRIMARY KEY, title VARCHAR(255));";
//const String CREATE_TABLE_ANSWERS = "CREATE TABLE answers(id INTEGER PRIMARY KEY, title VARCHAR(255));";
////https://flutter.dev/docs/cookbook/persistence/sqlite
//const String TEST = 'INSERT INTO decks(id, title) VALUES (1, "OK");';
//
//void main() async {
//  final database = openDatabase(
//    // Set the path to the database. Note: Using the `join` function from the
//    // `path` package is best practice to ensure the path is correctly
//    // constructed for each platform.
//    join(await getDatabasesPath(), 'database.db'),
//    // When the database is first created, create a table to store dogs.
//    onCreate: (db, version) {
//      return db.execute(
//          CREATE_TABLE_CATEGORIES +
//          CREATE_TABLE_DECKS +
//          CREATE_TABLE_CARDS +
//          CREATE_TABLE_ANSWERS
//      );
//    },
//    // Set the version. This executes the onCreate function and provides a
//    // path to perform database upgrades and downgrades.
//    version: 1,
//  );
//}
