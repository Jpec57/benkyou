import 'package:benkyou/models/Deck.dart';
import 'package:floor/floor.dart';

import 'DBProvider.dart';

@dao
abstract class DeckDao {
  @Insert(onConflict: OnConflictStrategy.REPLACE)
  Future<void> insertDeck(Deck deck);

  @Query('SELECT * FROM Deck')
  Stream<List<Deck>> findAllDecksAsSteam();

  @Query('SELECT * FROM Deck')
  Future<List<Deck>> findAllDecks();

  @Query('SELECT * FROM Deck WHERE id = :id')
  Future<Deck> findDeckById(int id);

  @Query('SELECT * FROM Deck WHERE title = :title')
  Future<Deck> findDeckByTitle(String title);

  @Query('SELECT * FROM Deck WHERE isSynchronized = 0')
  Future<List<Deck>> findAllDecksNotSynchronized();


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