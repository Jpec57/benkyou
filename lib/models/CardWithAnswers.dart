import 'package:benkyou/models/Card.dart' as Model;

class CardWithAnswers extends Model.Card {
  final List<String> answerContents;

  CardWithAnswers(int id, int deckId, String question, String hint,
      String useInContext, bool hasSolution, this.answerContents)
      : super(id, deckId, question, hint, useInContext, hasSolution);

  CardWithAnswers.fromDatabase(int id, int deckId, String question, String hint,
      String useInContext, int lvl, int nbErrors, int nbSuccess, int nextAvailable,
      bool isReversible, bool isSynchronized, bool hasSolution, {
    this.answerContents}) : super.init(id, deckId, question, hint, useInContext,
      lvl, nbErrors, nbSuccess, nextAvailable, isReversible,
      isSynchronized, hasSolution);

  factory CardWithAnswers.fromJSON(Map<String, dynamic> json) {

    return CardWithAnswers.fromDatabase(
        json['id'],
        json['deck_id'],
        json['question'],
        json['hint'],
        json['useInContext'],
        json['lvl'],
        json['nbErrors'],
        json['nbSuccess'],
        json['nextAvailable'],
        (json['isReversible'] == 0),
        (json['isSynchronized'] == 0),
        (json['hasSolution'] == 0)
    ,
        answerContents: json['answers'].split(',')
     );
  }
}
