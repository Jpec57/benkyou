import 'package:floor/floor.dart';

const String FIREBASE_KEY = 'decks';

@Entity(tableName: 'Deck')
class Deck {
  @PrimaryKey()
  final int id;
  final String title;
  int lastUse = new DateTime.now().millisecondsSinceEpoch;
  bool isSynchronized = false;

  Deck(this.id, this.title, this.lastUse);

  Deck.init(this.id, this.title, this.lastUse, this.isSynchronized);

  factory Deck.fromJSON(Map<String, dynamic> json) {
    return Deck(json['id'], json['title'], json['lastUse']);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> toReturn = new Map();
    toReturn['id'] = this.id;
    toReturn['title'] = this.title;
    toReturn['lastUse'] = lastUse;
    return toReturn;
  }

}