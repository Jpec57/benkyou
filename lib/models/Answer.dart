import 'package:benkyou/models/Card.dart';
import 'package:floor/floor.dart';

const String FIREBASE_KEY = 'answers';

@Entity(
  tableName: 'Answer',
  foreignKeys: [
    ForeignKey(
      childColumns: ['card_id'],
      parentColumns: ['id'],
      entity: Card,
    )
  ],
)
class Answer {
  @PrimaryKey()
  final int id;
  @ColumnInfo(name: 'card_id')
  final int cardId;
  final String content;
  bool isSynchronized = false;

  Answer(this.id, this.cardId, this.content);
  Answer.fromDatabase({this.id, this.cardId, this.content, this.isSynchronized});

  Map toMap() {
    Map toReturn = new Map();
    toReturn['id'] = id;
    toReturn['cardId'] = cardId;
    toReturn['content'] = content;
    return toReturn;
  }

  factory Answer.fromJSON(Map<String, dynamic> json) {
    return Answer.fromDatabase(
        id: json['id'],
        cardId: json['cardId'],
        content: json['content'],
        isSynchronized: (json['hasSolution'] == 0)
    );
  }
}