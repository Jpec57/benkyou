import 'package:benkyou/models/Card.dart';
import 'package:benkyou/models/CardCounter.dart';
import 'package:benkyou/models/CardWithAnswers.dart';
import 'package:benkyou/models/TimeCard.dart';
import 'package:benkyou/services/database/DBProvider.dart';
import 'package:benkyou/services/database/Database.dart';
import 'package:floor/floor.dart';

@dao
abstract class CardDao {
  @Insert(onConflict: OnConflictStrategy.REPLACE)
  Future<int> insertCard(Card card);

  Future<List<Card>> findAvailableCardsFromDeckId(int deckId, int time) async {
    AppDatabase db = await DBProvider.db.database;

    var cards = await db.database.rawQuery(
        'SELECT * FROM Card WHERE deck_id = $deckId AND nextAvailable <= $time AND hasSolution = 1');
    List<Card> parsedRes = [];
    for (var card in cards) {
      parsedRes.add(Card.fromJSON(card));
    }
    return parsedRes;
  }

  Future<List<Card>> findCards(
      {bool distinct,
      List<String> columns,
      String where,
      List<dynamic> whereArgs,
      String groupBy,
      String having,
      String orderBy,
      int limit,
      int offset}) async {
    var cards = await DBProvider.db.find('Card',
        where: where,
        whereArgs: whereArgs,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        limit: limit,
        offset: offset);

    List<Card> parsedRes = [];
    for (var card in cards) {
      parsedRes.add(Card.fromJSON(card));
    }
    return parsedRes;
  }

  Future<List<Card>> findAllCardsNotSynchronized() async {
    return await findCards(where: 'isSynchronized = 0 AND hasSolution = 1');
  }

  Future<List<Card>> findAllCards() async {
    return await findCards();
  }

  Future<List<TimeCard>> findCardsByHour(int startDate, {int endDate}) async {
    AppDatabase db = await DBProvider.db.database;
    List<Map<String, dynamic>> cards = (endDate != null ) ?
    await db.database.rawQuery(
        'SELECT nextAvailable, COUNT(*) AS num FROM Card WHERE $startDate <= nextAvailable AND nextAvailable <= $endDate GROUP BY nextAvailable') :
    await db.database.rawQuery(
        'SELECT nextAvailable, COUNT(*) AS num FROM Card WHERE $startDate <= nextAvailable GROUP BY nextAvailable');
    //Get cards already available
    List<Map<String, dynamic>> availableCards = await db.database.rawQuery(
        'SELECT COUNT(*) AS num FROM Card WHERE nextAvailable <= $startDate');
    List<TimeCard> parsedRes = [];
    for (var card in cards) {
      parsedRes.add(TimeCard.fromJson(card));
    }
    if (availableCards[0]["num"] != 0){
      parsedRes.add(TimeCard.fromJson({"nextAvailable": startDate, "num": availableCards[0]["num"]}));
    }
    return parsedRes;

  }

  Future<List<CardWithAnswers>> findAllCardsWithAnswers() async {
    AppDatabase db = await DBProvider.db.database;
    List<Map<String, dynamic>> cards = await db.database.rawQuery(
        'SELECT *, group_concat(DISTINCT a.content) AS answers FROM Card c INNER JOIN Answer a ON a.card_id = c.id GROUP BY c.id;');
    List<CardWithAnswers> parsedRes = [];
    for (var card in cards) {
      parsedRes.add(CardWithAnswers.fromJSON(card));
    }
    return parsedRes;
  }

  Future<List<Card>> findAllCardsFromDeckId(int id) async {
    return await findCards(
        where: 'deck_id = ? AND hasSolution = 1', whereArgs: [id]);
  }

  Future<List<Card>> findBadCardsFromDeckId(int id) async {
    return await findCards(
        where: 'deck_id = ? AND hasSolution = 1',
        whereArgs: [id],
        limit: 5,
        orderBy: 'nbErrors DESC');
  }

  Future<List<Card>> findReversibleAvailableCardsFromDeckId(
      int id, int currentDatetime) async {
    return await findCards(
        where:
            'deck_id = ? AND nextAvailable <= ? AND isReversible = true AND hasSolution = 1',
        whereArgs: [id, currentDatetime]);
  }

  Future<Card> findCardById(int id) async {
    var res = await findCards(where: 'id = ?', whereArgs: [id]);
    if (res.isEmpty) {
      return null;
    }
    return (res)[0];
  }

  Future<Card> findCardByQuestion(String question) async {
    var res = await findCards(where: 'question = ?', whereArgs: [question]);
    if (res.isEmpty) {
      return null;
    }
    return (res)[0];
  }

  Future<List<Card>> findReversibleCards() async {
    return await findCards(where: 'isReversible = true AND hasSolution = 1');
  }

  Future<List<Card>> findAllAvailableReversibleCards(
      int currentDatetime) async {
    return await findCards(
        where: 'isReversible = true AND nextAvailable <= ? AND hasSolution = 1',
        whereArgs: [currentDatetime]);
  }

  Future<List<Card>> findAvailableReversibleCardsForDeckId(
      int deckId, int currentDatetime) async {
    return await findCards(
        where:
            'deck_id = ? AND isReversible = true AND nextAvailable <= ? AND hasSolution = 1',
        whereArgs: [deckId, currentDatetime]);
  }

  Future<List<Card>> findAvailableCards(int currentDatetime) async {
    return await findCards(
        where: 'nextAvailable <= ? AND hasSolution = 1',
        whereArgs: [currentDatetime]);
  }

  Future<List<Card>> findCardsWithoutSolution({int deckId = -1}) async {
    if (deckId != -1) {
      return await findCards(
          where: 'hasSolution = 0 AND deck_id = ?', whereArgs: [deckId]);
    }
    return await findCards(where: 'hasSolution = 0');
  }

  Future<int> updateCardWithoutOverriding(
      Map<String, dynamic> values, String where,
      {List<dynamic> whereArgs}) async {
    int res =
        await DBProvider.db.update('Card', values, where, whereArgs: whereArgs);
    return res;
  }

  Future<int> setSynchronized(
      AppDatabase appDatabase, int cardId, bool isSynchronized) async {
    return await appDatabase.cardDao.updateCardWithoutOverriding(
        {'isSynchronized': isSynchronized}, 'id = ?',
        whereArgs: [cardId]);
  }

  Future<List<Map<String, dynamic>>> getBadCards(int deckId) async {
    var db = await DBProvider.db.database;
    var res = await db.database.rawQuery(
        'SELECT card.* , answer.content as answer FROM Card card LEFT JOIN Answer answer ON answer.id = (SELECT MIN(selected_answer.id) FROM Answer selected_answer WHERE selected_answer.card_id = card.id) WHERE card.hasSolution = 1 AND card.deck_id = $deckId ORDER BY nbErrors DESC LIMIT 5');
    return res;
  }

  Future<List<CardCounter>> getNumberOfCardsPerLvlsForDeckId(int deckId) async {
    var db = await DBProvider.db.database;
    var res = await db.database.rawQuery(
        'SELECT lvl, COUNT(id) AS number FROM Card WHERE deck_id = $deckId AND hasSolution = 1 GROUP BY lvl');
    List<CardCounter> parsedRes = [];
    for (var lvl in res) {
      parsedRes.add(CardCounter.fromJSON(lvl));
    }
    return parsedRes;
  }

  Future<void> deleteCardsFromDeck(int deckId) async {
    AppDatabase db = await DBProvider.db.database;
    var res =
        await db.database.rawQuery('DELETE FROM Card WHERE deck_id = $deckId');
    return res;
  }

  Future<void> deleteCard(int cardId) async {
    AppDatabase db = await DBProvider.db.database;
    var res = await db.database.rawQuery('DELETE FROM Card WHERE id = $cardId');
    return res;
  }
}
