import 'package:benkyou/models/Answer.dart';
import 'package:benkyou/models/Card.dart';
import 'package:benkyou/models/DTO/PublicCard.dart';
import 'package:benkyou/models/Deck.dart';
import 'package:benkyou/services/database/DBProvider.dart';
import 'package:benkyou/services/database/Database.dart';

class PublicDeck {
  String author;
  int lastUse;
  String title;
  String description;
  List<PublicCard> cards;

  PublicDeck(
      {this.author, this.lastUse, this.title, this.description, this.cards});

  PublicDeck.fromDatabase(
      {this.author, this.lastUse, this.title, this.description, this.cards});

  factory PublicDeck.fromJSON(
      Map<String, dynamic> json, List<PublicCard> cards) {
    return PublicDeck.fromDatabase(
        author: json['author'],
        title: json['title'],
        lastUse: json['lastUse'],
        description: json['description'],
        cards: cards);
  }

  @override
  String toString() {
    return 'PublicDeck{author: $author, lastUse: $lastUse, title: $title, description: $description, cards: $cards}';
  }


}

Future<List<Map<String, dynamic>>> _getMappingBetweenPublicDeckAndDeck(Deck deck) async{
  AppDatabase appDatabase = await DBProvider.db.database;
  List<Card> cards = await appDatabase.cardDao.findAllCardsFromDeckId(deck.id);
  List<Map<String, dynamic>> parsedCards = new List();

  for (var i = 0; i < cards.length; i++){
    Card card = cards[i];
    List<Answer> answers = await appDatabase.answerDao.findAllAnswersForCard(card.id);
    List<String> answerStrings = [];
    answers.forEach((Answer answer){
      answerStrings.add(answer.content);
    });
    Map<String, dynamic> map = {
      "question": card.question,
      "hint": card.hint,
      "isForeignWord": card.isForeignWord,
      "answers": answerStrings,
    };
    parsedCards.add(map);
  }
  return parsedCards;
}

Future<Map<String, dynamic>> convertDeckToPublic(Deck deck, String author) async {
  List<Map<String, dynamic>> parsedCards = await _getMappingBetweenPublicDeckAndDeck(deck);

  return {
    "author": author,
    "title": deck.title,
    "lastUse": DateTime.now().millisecondsSinceEpoch,
    "description": deck.description,
    "cards": parsedCards
  };
}
