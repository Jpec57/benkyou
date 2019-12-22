import 'package:floor/floor.dart';

const String FIREBASE_KEY = 'decks';

@Entity(tableName: 'Deck')
class Deck {
  @PrimaryKey()
  final int id;
  final String title;
  int lastUse = new DateTime.now().millisecondsSinceEpoch;
  bool isSynchronized = false;
  bool isPublic = false;

  Deck(this.id, this.title, this.lastUse);

  Deck.fromDatabase({this.id, this.title, this.lastUse, this.isPublic});
  Deck.init(this.id, this.title, this.lastUse, this.isSynchronized, this.isPublic);

  factory Deck.fromJSON(Map<String, dynamic> json) {
    return Deck.fromDatabase(
        id: json['id'],
        title: json['title'],
        lastUse: json['lastUse'],
        isPublic: json['isPublic'] == 0
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> toReturn = new Map();
    toReturn['id'] = this.id;
    toReturn['title'] = this.title;
    toReturn['lastUse'] = lastUse;
    return toReturn;
  }

}


