import 'package:benkyou/models/Deck.dart';
import 'package:floor/floor.dart';

import 'DBProvider.dart';

@dao
abstract class DeckDao {
  @Insert(onConflict: OnConflictStrategy.REPLACE)
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

    var decks = await DBProvider.db.find('Deck',
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
    var res = await findDecks(where: 'id = ?', whereArgs: [id]);
    if (res.isEmpty) {
      return null;
    }
    return (res)[0];
  }

  Future<Deck> findDeckByTitle(String title) async{
    var res = await findDecks(where: 'title = ?', whereArgs: [title]);
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

  Future<void> deleteDeck(int deckId) async{
    var db = await DBProvider.db.database;
    String deleteAnswersQuery = 'DELETE FROM Answer WHERE card_id IN (SELECT id FROM Card WHERE deck_id = $deckId);';
    String deleteCardsQuery = 'DELETE FROM Card WHERE deck_id = $deckId;';
    String deleteDeckQuery = 'DELETE FROM Deck WHERE id = $deckId';

    await db.database.rawQuery(deleteAnswersQuery);
    await db.database.rawQuery(deleteCardsQuery);
    await db.database.rawQuery(deleteDeckQuery);

  }
}