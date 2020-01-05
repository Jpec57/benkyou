import 'dart:io';

import 'package:benkyou/models/Card.dart';
import 'package:benkyou/models/DTO/PublicCard.dart';
import 'package:benkyou/models/DTO/PublicDeck.dart';
import 'package:benkyou/models/Deck.dart';
import 'package:benkyou/services/database/Database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:floor/floor.dart';
import 'package:path_provider/path_provider.dart';

import 'DBProvider.dart';

@dao
abstract class DeckDao {
  @Insert(onConflict: OnConflictStrategy.FAIL)
  Future<int> insertDeck(Deck deck);

  Future<void> createDeckFromPublic(PublicDeck deck) async{
    String ref = "${deck.author}:${deck.title}";
    Deck refDeck = await findDeckByPublicRef(ref);
    if (refDeck == null){
      Deck newDeck = new Deck.init(null, deck.title,
          new DateTime.now().millisecondsSinceEpoch, false, deck.description);
      newDeck.publicRef = ref;
      int deckId = await insertDeck(newDeck);
      List<PublicCard> publicCards = deck.cards;

      for (PublicCard card in publicCards){
        await Card.setCardWithBasicAnswers(deckId, card.question, card.answers, hint: card.hint, isForeignWord: card.isForeignWord, isReversible: false);
      }
    } else {
      //Check which cards should be added
      List<PublicCard> publicCards = deck.cards;
      AppDatabase appDatabase = await DBProvider.db.database;
      List<String> existingQuestions = await appDatabase.cardDao.findAllCardQuestionsFromDeckId(refDeck.id);

      for (PublicCard card in publicCards){
        if (existingQuestions.contains(card.question)){
          await Card.setCardWithBasicAnswers(refDeck.id, card.question, card.answers, hint: card.hint, isForeignWord: card.isForeignWord, isReversible: false);
        }
      }
    }

  }

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

  Future<Deck> findDeckByPublicRef(String ref) async{
    List<Deck> res = await findDecks(where: 'publicRef = ?', whereArgs: [ref]);
    if (res.isEmpty) {
      return null;
    }
    return (res)[0];
  }

  Future<List<Deck>> findAllDecksNotSynchronized() async{
    return await findDecks(where: 'isSynchronized = 0');
  }

  @Update(onConflict: OnConflictStrategy.REPLACE)
  Future<void> updateDeck(Deck deck);

  Future<void> deleteDeckImages(int deckId, {bool cover = true}) async{
    AppDatabase db = await DBProvider.db.database;
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
    AppDatabase db = await DBProvider.db.database;
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