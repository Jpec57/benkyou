import 'package:floor/floor.dart';

const String FIREBASE_KEY = 'decks';

@Entity(tableName: 'Deck')
class Deck {
  @PrimaryKey()
  final int id;
  final String title;
  bool isPublic = false;
  String publicRef;
  int lastUse = new DateTime.now().millisecondsSinceEpoch;
  String description;
  bool isSynchronized = false;

  Deck(this.id, this.title, this.lastUse, this.description, this.publicRef);

  Deck.fromDatabase({this.id, this.title, this.lastUse, this.description});
  Deck.init(this.id, this.title, this.lastUse, this.isSynchronized, this.description, {this.publicRef});

  factory Deck.fromJSON(Map<String, dynamic> json) {
    return Deck.fromDatabase(
        id: json['id'],
        title: json['title'],
        lastUse: json['lastUse'],
        description: json['description']
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> toReturn = new Map();
    toReturn['id'] = this.id;
    toReturn['title'] = this.title;
    toReturn['lastUse'] = this.lastUse;
    toReturn['description'] = this.description;
    return toReturn;
  }

}


