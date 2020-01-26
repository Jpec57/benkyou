
import 'package:benkyou/constants/utils.dart';
import 'package:benkyou/models/Answer.dart';
import 'package:benkyou/models/Deck.dart';
import 'package:benkyou/services/database/DBProvider.dart';
import 'package:benkyou/services/database/Database.dart';
import 'package:benkyou/services/translator/TextConversion.dart';
import 'package:benkyou/utils/string.dart';
import 'package:floor/floor.dart';
import 'dart:core';

import 'package:sqflite/sql.dart';

const String FIREBASE_KEY = 'cards';

@Entity(
  tableName: 'Card',
  foreignKeys: [
    ForeignKey(
      childColumns: ['deck_id'],
      parentColumns: ['id'],
      entity: Deck,
    )
  ],
)
class Card {
  @PrimaryKey()
  final int id;
  @ColumnInfo(name: 'deck_id')
  int deckId;
  String question;
  String hint;
  String useInContext;
  int lvl = 0;
  int nbErrors = 0;
  int nbSuccess = 0;
  int nextAvailable = DateTime.now().millisecondsSinceEpoch;
  bool isSynchronized = false;
  bool isForeignWord = true;
  //IsInitWithSolution?
  bool hasSolution;

  Card(this.id, this.deckId, this.question, this.hint, this.useInContext, this.hasSolution);
  //Need to modify CardWithAnswer too if we change something here...
  Card.init(
      this.id, this.deckId, this.question, this.hint, this.useInContext,
      this.lvl, this.nbErrors, this.nbSuccess, this.nextAvailable, this.isForeignWord,
      this.isSynchronized, this.hasSolution);

  Card.fromDatabase({this.id,
    this.deckId,
    this.question,
    this.hint,
    this.useInContext,
    this.lvl,
    this.nbErrors,
    this.nbSuccess,
    this.nextAvailable,
    this.isForeignWord,
    this.isSynchronized,
    this.hasSolution,
  });

  factory Card.fromJSON(Map<String, dynamic> json) {
    return Card.fromDatabase(
      id: json['id'],
      deckId: json['deck_id'],
      question: json['question'],
      hint: json['hint'],
      useInContext: json['useInContext'],
      lvl: json['lvl'],
      nbErrors: json['nbErrors'],
      nbSuccess: json['nbSuccess'],
      nextAvailable: json['nextAvailable'],
      isForeignWord: (json['isForeignWord'] == 0),
      isSynchronized: (json['isSynchronized'] == 0),
      hasSolution: (json['hasSolution'] == 0),
    );
  }

  Future<bool> checkIfCorrectAnswer(String proposedAnswer) async {
    AppDatabase database = await DBProvider.db.database;
    List<Answer> answers = await database.answerDao.findAllAnswersForCard(id);
    for (var answer in answers){
      String answerWithoutInfo = getAnswerWithoutInfo(answer.content);
      if (isStringDistanceValid(answerWithoutInfo, proposedAnswer) || getJapaneseTranslation(proposedAnswer) == answerWithoutInfo){
        return true;
      }
    }
    return false;
  }


  @override
  String toString() {
    return ('Card ${this.id}:\n'
        'date : ${DateTime.fromMillisecondsSinceEpoch(this.nextAvailable)}\n'
        'question: ${this.question}\n'
        'synchro: ${this.isSynchronized}\n'
        'level: ${this.lvl}\n'
        'hint: ${this.hint}\n'
        'hasSol: ${this.hasSolution}\n'
        'nbErrors: ${this.nbErrors}\n'
        'nbSuccess: ${this.nbSuccess}\n'
    );
  }

  static Future<Card> setCardWithBasicAnswers(int deckId, String question,
      List<String> answers, {String useInContext, String hint, Card card,
        bool isReversible = true, bool isForeignWord = true}) async{
    AppDatabase appDatabase = await DBProvider.db.database;
    int cardId;

    if (card == null){
      Card card = new Card(null, deckId, question, hint, useInContext, true);
      cardId = await appDatabase.cardDao.insertCard(card);
    } else {
      cardId = card.id;
      await appDatabase.cardDao.updateCardWithoutOverriding(
          {'hasSolution': true},
          'id = ?', whereArgs: [card.id]);
    }

    for (var answer in answers){
      Answer a = new Answer(null, cardId, answer);
      await appDatabase.answerDao.insertAnswer(a);
    }
    if (isReversible){
      Card oppositeCard = new Card(null, deckId, answers.join('|'), null, useInContext, true);
      oppositeCard.isForeignWord = false;
      oppositeCard.hint = '';
      int oppositeCardId = await appDatabase.cardDao.insertCard(oppositeCard);
      Answer oppositeAnswer = new Answer(null, oppositeCardId, question);
      await appDatabase.answerDao.insertAnswer(oppositeAnswer);
      if (hint != null && hint.isNotEmpty){
        Answer oppositeAnswerHint = new Answer(null, oppositeCardId, hint);
        await appDatabase.answerDao.insertAnswer(oppositeAnswerHint);
      }
    }
    return card;
  }

  Map toMap() {
    Map toReturn = new Map();
    toReturn['id'] = id;
    toReturn['deck_id'] = deckId;
    toReturn['question'] = question;
    toReturn['hint'] = hint;
    toReturn['useInContext'] = useInContext;
    toReturn['lvl'] = lvl;
    toReturn['nbErrors'] = nbErrors;
    toReturn['nbSuccess'] = nbSuccess;
    toReturn['nextAvailable'] = nextAvailable;
    toReturn['isForeignWord'] = isForeignWord;
    return toReturn;
  }
  updateCard(AppDatabase database, bool isRight) async{
    if (isRight){
      this.lvl++;
      this.nbSuccess++;
    } else {
      this.nbErrors++;
      if (this.lvl > 1){
        this.lvl = this.lvl -2;
      } else if (this.lvl > 0){
        this.lvl--;
      }
    }

    if (this.lvl < 0){
      this.lvl = 0;
    }
    final now = new DateTime.now();
    final roundHour = now.subtract(Duration(
      minutes: now.minute,
      seconds: now.second,
      milliseconds: now.millisecond,
      microseconds: now.microsecond,
    )).millisecondsSinceEpoch;


    if (isDev){
      this.nextAvailable = roundHour +  60;
    } else {
      switch (this.lvl){
        case 0:
          this.nextAvailable = roundHour + ((60 * 60 * 1000) * 4);
          break;
        case 1:
          this.nextAvailable = roundHour + ((60 * 60 * 1000) * 9);
          break;
        case 2:
          this.nextAvailable = roundHour +  ((60 * 60 * 1000) * 23);
          break;
        case 3:
          this.nextAvailable = roundHour +  ((60 * 60 * 1000) * 48);
          break;
        case 4:
          this.nextAvailable = roundHour +  ((60 * 60 * 1000  * 24) * 2);
          break;
        case 5:
          this.nextAvailable = roundHour +  ((60 * 60 * 1000 * 24) * 7);
          break;
        case 6:
          this.nextAvailable = roundHour +  ((60 * 60 * 1000  * 24 * 7) * 4);
          break;
        case 7:
          this.nextAvailable = roundHour +  ((60 * 60 * 1000  * 24 * 7 * 4) * 4);
          break;
        case 8:
          this.nextAvailable = roundHour +  ((60 * 60 * 1000  * 24 * 7 * 4) * 8);
          break;
        case 9:
          this.nextAvailable = roundHour +  ((60 * 60 * 1000  * 24 * 7 * 4) * 12);
          break;
        default:
          this.nextAvailable = roundHour +  ((60 * 60 * 1000) * 4);
          break;
      }
    }

    await database.database.update('Card',
        {'lvl': this.lvl, 'nextAvailable': this.nextAvailable,
          'isSynchronized': false, 'nbErrors': this.nbErrors,
          'nbSuccess': this.nbSuccess},
        where: 'id = ?',
        whereArgs: [this.id],
        conflictAlgorithm: ConflictAlgorithm.replace
    );
  }
}


const List<Map<String, String>> CardSRS = [
  {'name': 'Apprentice'},
  {'name': 'Apprentice 2'},
  {'name': 'Guru'},
  {'name': 'Guru 2'},
  {'name': 'Master'},
  {'name': 'Master 2'},
  {'name': 'Enlighted'},
  {'name': 'Enlighted 2'},
  {'name': 'Burned'},
  {'name': 'Burned 2'},
];
