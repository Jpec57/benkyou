import 'package:benkyou/main.dart';
import 'package:benkyou/models/Answer.dart' as AnswerModel;
import 'package:benkyou/models/Card.dart' as CardModel;
import 'package:benkyou/models/Deck.dart' as DeckModel;
import 'package:benkyou/services/database/CardDao.dart';
import 'package:benkyou/services/database/DBProvider.dart';
import 'package:benkyou/services/database/Database.dart';
import 'package:benkyou/services/database/DeckDao.dart';
import 'package:benkyou/widgets/DeckContainer.dart';
import 'package:benkyou/widgets/dialog/CreateDeckDialog.dart';
import 'package:benkyou/widgets/MyText.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class DeckPage extends StatefulWidget {
  final DeckDao deckDao;
  final CardDao cardDao;

  DeckPage({
    Key key,
    @required this.deckDao,
    @required this.cardDao,
  }) : super(key: key);

  @override
  DeckPageState createState() => DeckPageState();
}

class DeckPageState extends State<DeckPage> {
  List<bool> _deckDeleteButtons = new List();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Future onSelectNotification(String payload) async {
    showDialog(
      context: context,
      builder: (_) {
        return new AlertDialog(
          title: Text("PayLoad"),
          content: Text("Payload : $payload"),
        );
      },
    );
  }

  void printCard() async {}

  @override
  void initState() {
    super.initState();
    var callback = onSelectNotification;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
//      synchroniseFirebase();
      //      scheduleNotification(context, flutterLocalNotificationsPlugin, callback);
    });
  }

  void updateEntity(AppDatabase appDatabase, String path, entity) async {
    switch (path) {
      case DeckModel.FIREBASE_KEY:
        var deck = entity as DeckModel.Deck;
        deck.isSynchronized = true;
        await appDatabase.deckDao.updateDeck(deck);
        break;
      case CardModel.FIREBASE_KEY:
        var card = entity as CardModel.Card;
        await appDatabase.cardDao.setSynchronized(appDatabase, card.id, true);
        break;
      case AnswerModel.FIREBASE_KEY:
        var answer = entity as AnswerModel.Answer;
        await appDatabase.answerDao.updateAnswer(
            {'isSynchronized': true}, 'id = ?',
            whereArgs: [answer.id]);
        break;
      default:
        break;
    }
  }

  void sendEntityToFirebase(AppDatabase localDatabase,
      CollectionReference databaseReference, String path, List entities) {
    if (entities != null && entities.length > 0) {
      Map<String, Map> map = new Map();
      for (var entity in entities) {
        map["${entity.id}"] = entity.toMap();
        updateEntity(localDatabase, path, entity);
      }
      databaseReference.document(path).setData(map);
    }
  }

  void synchroniseFirebase() async {
    final databaseReference =
        Firestore.instance.collection('benkyou/users/jpec').reference();
    AppDatabase database = await DBProvider.db.database;
    List<DeckModel.Deck> decks =
        await database.deckDao.findAllDecksNotSynchronized();
    List<CardModel.Card> cards =
        await database.cardDao.findAllCardsNotSynchronized();
    List<AnswerModel.Answer> answers =
        await database.answerDao.findAllAnswersNotSynchronized();

    sendEntityToFirebase(
        database, databaseReference, DeckModel.FIREBASE_KEY, decks);
    sendEntityToFirebase(
        database, databaseReference, CardModel.FIREBASE_KEY, cards);
    sendEntityToFirebase(
        database, databaseReference, AnswerModel.FIREBASE_KEY, answers);
  }

  @override
  Widget build(BuildContext context) {
    return BasicContainer(
      child: Column(children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.12,
          decoration: BoxDecoration(color: Colors.orange),
          child: Center(
            child: Text(
              'Benkyou',
              style: TextStyle(fontSize: 30, fontFamily: 'Pacifico'),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: FutureBuilder(
                future: widget.deckDao.findAllDecks(),
                builder: (_, AsyncSnapshot<List<DeckModel.Deck>> snapshot) {
                  if (!snapshot.hasData) {
                    return (Center(
                      child: MyText("You should create a deck first."),
                    ));
                  } else if (snapshot.hasData && snapshot.data.length == 0) {
                    return Text('Empty');
                  } else {
                    return (GridView.count(
                        crossAxisCount: 2,
                        children: List.generate(snapshot.data.length, (index) {
                          _deckDeleteButtons.add(false);
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DeckContainer(
                                parent: this,
                                index: index,
                                deck: snapshot.data[index],
                                cardDao: widget.cardDao),
                          );
                        })));
                  }
                }),
          ),
        ),
        GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) =>
                    CreateDeckDialog(deckDao: widget.deckDao));
          },
          child: Container(
            height: MediaQuery.of(context).size.height * 0.12,
            decoration: BoxDecoration(color: Colors.lightBlueAccent),
            child: Center(
              child: Text(
                '+',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
