import 'package:benkyou/services/database/Database.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static AppDatabase _database;

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
}