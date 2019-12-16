import 'package:benkyou/models/Answer.dart';
import 'package:benkyou/services/database/DBProvider.dart';
import 'package:benkyou/utils/utils.dart';
import 'package:floor/floor.dart';

@dao
abstract class AnswerDao {
  @Insert(onConflict: OnConflictStrategy.FAIL)
  Future<int> insertAnswer(Answer answer);

  Future<int> deleteAnswer(int answerId) async{
    var db = await DBProvider.db.database;
    String deleteAnswerQuery = 'DELETE FROM Answer WHERE id = $answerId';
    return await db.database.rawDelete(deleteAnswerQuery);
  }

  Future<int> deleteAnswersFromCard(int cardId) async{
    var db = await DBProvider.db.database;
    String deleteAnswerQuery = 'DELETE FROM Answer WHERE card_id = $cardId';
    return await db.database.rawDelete(deleteAnswerQuery);
  }


  Future<void> updateAnswersFromCard(int cardId, List<String> newAnswers) async{
    var db = await DBProvider.db.database;
    String selectAnswersQuery = 'SELECT content FROM Answer WHERE card_id = $cardId';
    List<Map<String, dynamic>> oldAnswers = await db.database.rawQuery(selectAnswersQuery);
    List<String> oldContents = List<String>();
    for (Map<String, dynamic> oldAnswer in oldAnswers){
      oldContents.add(getComparableString(oldAnswer['content'].toString()));
    }
    for (String newAnswer in newAnswers){
      if (!oldContents.contains(getComparableString(newAnswer))){
        print("new ${newAnswer}");
        insertAnswer(new Answer(null, cardId, newAnswer));
      }
    }
  }

  Future<List<Answer>> findAnswers(
      {bool distinct,
        List<String> columns,
        String where,
        List<dynamic> whereArgs,
        String groupBy,
        String having,
        String orderBy,
        int limit,
        int offset}) async {

    var answers = await DBProvider.db.find('Answer',
        where: where,
        whereArgs: whereArgs,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        limit: limit,
        offset: offset);

    List<Answer> parsedRes = [];
    for (var answer in answers) {
      parsedRes.add(Answer.fromJSON(answer));
    }
    return parsedRes;
  }

  Future<List<Answer>> findAllAnswersForCard(int id){
    return findAnswers(
        where: 'card_id = ?',
        whereArgs: [id],
    );
  }

  Future<Answer> findAnswerForCardWithTitle(int cardId, String content) async{
    var res = await findAnswers(
        where: 'card_id = ? AND content = ?',
        whereArgs: [cardId, content],
        limit: 1
    );
    if (res.isEmpty) {
      return null;
    }
    return (res)[0];
  }

  Future<Answer> findOneAnswerForCard(int id) async{
    var res = await findAnswers(
        where: 'card_id = ?',
        whereArgs: [id],
        limit: 1
    );
    if (res.isEmpty) {
      return null;
    }
    return (res)[0];
  }

  Future<Answer> findAnswerById(int id) async{
    var res = await findAnswers(
    where: 'id = ?',
    whereArgs: [id],
    );
    if (res.isEmpty) {
      return null;
    }
    return (res)[0];
  }

  Future<List<Answer>> findAllAnswers(){
    return findAnswers();
  }

  Future<List<Answer>> findAllAnswersNotSynchronized(){
    return findAnswers(
      where: 'isSynchronized = 0',
    );
  }

  Future<void> updateAnswer(Map<String, dynamic> values, String where,
    {List<dynamic> whereArgs}) async {

    int res = await DBProvider.db
        .update('Answer', values, where, whereArgs: whereArgs);
    return res;
  }

}