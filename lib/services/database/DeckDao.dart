import 'dart:io';

import 'package:benkyou/models/Deck.dart';
import 'package:floor/floor.dart';
import 'package:path_provider/path_provider.dart';

import 'DBProvider.dart';

@dao
abstract class DeckDao {
  @Insert(onConflict: OnConflictStrategy.FAIL)
  Future<void> insertDeck(Deck deck);

  Future<List<Deck>> findDecks(
      {bool distinct,
        List<String> columns,
        String where,
        List<dynamic> whereArgs,
        String groupBy,
        String having,
        String orderBy,
        int limit,
        int offset}) async {

    List<Map<String, dynamic>> decks = await DBProvider.db.find('Deck',
        where: where,
        whereArgs: whereArgs,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        limit: limit,
        offset: offset);

    List<Deck> parsedRes = [];
    for (var deck in decks) {
      parsedRes.add(Deck.fromJSON(deck));
    }
    return parsedRes;
  }

  Future<List<Deck>> findAllDecks() async{
    return await findDecks();
  }

  Future<Deck> findDeckById(int id) async{
    List<Deck> res = await findDecks(where: 'id = ?', whereArgs: [id]);
    if (res.isEmpty) {
      return null;
    }
    return (res)[0];
  }

  Future<Deck> findDeckByTitle(String title) async{
    List<Deck> res = await findDecks(where: 'title = ?', whereArgs: [title]);
    if (res.isEmpty) {
      return null;
    }
    return (res)[0];
  }

  @Query('SELECT * FROM Deck WHERE isSynchronized = 0')
  Future<List<Deck>> findAllDecksNotSynchronized() async{
    return await findDecks(where: 'isSynchronized = 0');
  }


  @Update(onConflict: OnConflictStrategy.REPLACE)
  Future<void> updateDeck(Deck deck);

  Future<void> deleteDeckImages(int deckId, {bool cover = true}) async{
    var db = await DBProvider.db.database;
    //Delete images associated with deck
    String titleQuery = 'SELECT title FROM Deck WHERE id = $deckId;';
    List<Map<String, dynamic>> titleRes = await db.database.rawQuery(titleQuery);
    String title = titleRes[0]["title"];
    final String path = (await getApplicationDocumentsDirectory()).path;
    if (cover){
      bool fileExists = await File('$path/decks/$title/cover.png').exists();
      if (fileExists){
        File('$path/decks/$title/cover.png').delete();
      }
    }

  }

  Future<void> deleteDeck(int deckId) async{
    var db = await DBProvider.db.database;
    //Delete images associated with decks
    deleteDeckImages(deckId);

    String deleteAnswersQuery = 'DELETE FROM Answer WHERE card_id IN (SELECT id FROM Card WHERE deck_id = $deckId);';
    String deleteCardsQuery = 'DELETE FROM Card WHERE deck_id = $deckId;';
    String deleteDeckQuery = 'DELETE FROM Deck WHERE id = $deckId';

    await db.database.rawQuery(deleteAnswersQuery);
    await db.database.rawQuery(deleteCardsQuery);
    await db.database.rawQuery(deleteDeckQuery);

  }
}