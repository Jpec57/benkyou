import 'package:benkyou/models/Answer.dart' as answer_model;
import 'package:benkyou/models/Card.dart' as card_model;
import 'package:benkyou/models/Deck.dart' as deck_model;
import 'package:benkyou/models/TimeCard.dart';
import 'package:benkyou/models/TimeSeriesBar.dart';
import 'package:benkyou/services/database/CardDao.dart';
import 'package:benkyou/services/database/DBProvider.dart';
import 'package:benkyou/services/database/Database.dart';
import 'package:benkyou/services/database/DeckDao.dart';
import 'package:benkyou/services/login.dart';
import 'package:benkyou/widgets/DeckContainer.dart';
import 'package:benkyou/widgets/Header.dart';
import 'package:benkyou/widgets/ReviewSchedule.dart';
import 'package:benkyou/widgets/app/BasicContainer.dart';
import 'package:benkyou/widgets/dialog/CreateDeckDialog.dart';
import 'package:benkyou/widgets/MyText.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:charts_flutter/flutter.dart' as charts;

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
    await showDialog(
      context: context,
      builder: (_) {
        return new AlertDialog(
          title: Text("PayLoad"),
          content: Text("Payload : $payload"),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
//    var callback = onSelectNotification;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var uuid = await isUserLoggedIn();
      if (uuid != null) {
        //TODO SHow welcome back 'name'
        synchroniseFirebase(uuid);
      } else {
        //TODO show need to logged in to save online
      }
      //      scheduleNotification(context, flutterLocalNotificationsPlugin, callback);
    });
  }

  void updateEntity(AppDatabase appDatabase, String path, entity) async {
    switch (path) {
      case deck_model.FIREBASE_KEY:
        var deck = entity as deck_model.Deck;
        deck.isSynchronized = true;
        await appDatabase.deckDao.updateDeck(deck);
        break;
      case card_model.FIREBASE_KEY:
        var card = entity as card_model.Card;
        await appDatabase.cardDao.setSynchronized(appDatabase, card.id, true);
        break;
      case answer_model.FIREBASE_KEY:
        var answer = entity as answer_model.Answer;
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
    if (entities != null && entities.isNotEmpty) {
      Map<String, Map> map = new Map();
      for (var entity in entities) {
        map["${entity.id}"] = entity.toMap();
        updateEntity(localDatabase, path, entity);
      }
      databaseReference.document(path).setData(map, merge: true);
    }
  }

  void synchroniseFirebase(String uuid, {onlyNotSynchronised = false}) async {
    Query databaseReference =
        Firestore.instance.collection('benkyou/users/$uuid').reference().where('uid', isEqualTo: "${uuid}");
    AppDatabase database = await DBProvider.db.database;
    List<deck_model.Deck> decks;
    List<card_model.Card> cards;
    List<answer_model.Answer> answers;

    if (onlyNotSynchronised) {
      decks = await database.deckDao.findAllDecksNotSynchronized();
      cards = await database.cardDao.findAllCardsNotSynchronized();
      answers = await database.answerDao.findAllAnswersNotSynchronized();
    } else {
      decks = await database.deckDao.findAllDecks();
      cards = await database.cardDao.findAllCards();
      answers = await database.answerDao.findAllAnswers();
    }

    sendEntityToFirebase(
        database, databaseReference, deck_model.FIREBASE_KEY, decks);
    sendEntityToFirebase(
        database, databaseReference, card_model.FIREBASE_KEY, cards);
    sendEntityToFirebase(
        database, databaseReference, answer_model.FIREBASE_KEY, answers);
  }

  @override
  Widget build(BuildContext context) {
    return BasicContainer(
      child: Column(children: <Widget>[
        Header(
            title: 'Benkyou',
            type: HEADER_ICON,
            hasBackButton: false,
            icon: Builder(
              builder: (BuildContext context) {
                return (GestureDetector(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
//            showLoginDialog(context);
                  },
                  child: Image.asset('resources/imgs/side_drawer_icon.png'),
                ));
              },
            )),
        ReviewSchedule(
          cardDao: widget.cardDao,
          colors: [
            Color(0xff646461),
            Color(0xff248CCB),
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: FutureBuilder(
                future: widget.deckDao.findAllDecks(),
                builder: (_, AsyncSnapshot<List<deck_model.Deck>> snapshot) {
                  if (!snapshot.hasData) {
                    return (Center(
                      child: MyText("You should create a deck first."),
                    ));
                  } else if (snapshot.hasData && snapshot.data.isEmpty) {
                    return Text('Empty');
                  } else {
                    return (GridView.count(
                        crossAxisCount: 2,
                        key: ValueKey('deck-grid'),
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
