import 'package:benkyou/models/Answer.dart';
import 'package:benkyou/services/database/DBProvider.dart';
import 'package:floor/floor.dart';

@dao
abstract class AnswerDao {
  @Insert(onConflict: OnConflictStrategy.REPLACE)
  Future<int> insertAnswer(Answer answer);

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

  //TODO throw err if none
  Future<Answer> findOneAnswerForCard(int id) async{
    return (await findAnswers(
      where: 'card_id = ?',
      whereArgs: [id],
      limit: 1
    ))[0];
  }

  //TODO throw err if none
  Future<Answer> findAnswerById(int id) async{
    return (await findAnswers(
    where: 'id = ?',
    whereArgs: [id],
    ))[0];
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