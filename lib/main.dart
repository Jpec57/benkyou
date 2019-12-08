import 'dart:convert';
import 'package:benkyou/screens/CreateCardPage.dart';
import 'package:benkyou/screens/DeckPage.dart';
import 'package:benkyou/screens/GuessPage.dart';
import 'package:benkyou/widgets/drawer/SideDrawer.dart';
import 'package:flutter/services.dart';
import 'package:benkyou/models/AppState.dart';
import 'package:benkyou/models/Card.dart' as prefix0;
import 'package:benkyou/models/Deck.dart';
import 'package:benkyou/services/database/Database.dart';
import 'package:benkyou/services/notifications/notification.dart';
import 'package:benkyou/widgets/StateContainer.dart';
import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart' as Sqli;

void insertFixtureInDatabase(Sqli.Database database, String tableName, String jsonFile){
  rootBundle.loadString(jsonFile).then((String jsonString) {
    List<dynamic> jsonDeck = jsonDecode(jsonString);
    jsonDeck.forEach((object){
      database.insert(tableName, object);
    });
  });
}

final callback = Callback(
  onCreate: (database, version) {
    try{
      insertFixtureInDatabase(database, 'Deck', 'lib/fixtures/dev/decks.json');
      insertFixtureInDatabase(database, 'Card', 'lib/fixtures/dev/cards.json');
      insertFixtureInDatabase(database, 'Answer', 'lib/fixtures/dev/answers.json');
    }catch(e){
    }
  },
  onOpen: (database){ /* database has been opened */},
  onUpgrade: (database, startVersion, endVersion) { /* database has been upgraded */ },
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database =
      await $FloorAppDatabase.databaseBuilder('flutter_database.db')
          .addCallback(callback).build();
  setOneSignalListeners();
  var cards = await database.cardDao.findAvailableCardsFromDeckId(1, DateTime.now().millisecondsSinceEpoch);
  var deck = await database.deckDao.findDeckById(1);
  WidgetsFlutterBinding.ensureInitialized();
  runApp(AppStateContainer(
      state: AppState(), child: MyApp(database: database, deck: deck, cards: cards)));
}

class BasicContainer extends StatelessWidget{
  final Widget child;

  const BasicContainer({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: child,
        drawer: SideDrawer(),
      ),
    );
  }

}

class MyApp extends StatelessWidget {
  final AppDatabase database;
  final Deck deck;
  final List<prefix0.Card> cards;

  const MyApp({this.database, this.deck, this.cards});

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: MaterialApp(
        title: 'Benkyou',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
          home:
//            LateInitPage(deckId: 1)
//            SynchronizePage()
//            DeckInfoPage(cardDao: database.cardDao, deck: deck,),
//          DeckPage(cardDao: database.cardDao, deckDao: database.deckDao)
//        GuessPage(appDatabase: database, cards: cards, deckId: 1,)
        CreateCardPage(cardDao: database.cardDao, deck: deck,)

//      home: BasicContainer(child:
//      ),

      ),
    );
  }
}
