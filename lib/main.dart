import 'package:benkyou/screens/CardListPage.dart';
import 'package:benkyou/screens/CardShowPage.dart';
import 'package:benkyou/screens/CreateCardPage.dart';
import 'package:benkyou/screens/DeckPage.dart';
import 'package:benkyou/screens/TinderLikePage.dart';
import 'package:benkyou/services/database/DBProvider.dart';
import 'package:benkyou/models/AppState.dart';
import 'package:benkyou/models/Card.dart' as prefix0;
import 'package:benkyou/models/Deck.dart';
import 'package:benkyou/services/database/Database.dart';
import 'package:benkyou/services/notifications/notification.dart';
import 'package:benkyou/widgets/StateContainer.dart';
import 'package:floor/floor.dart';
import 'package:flutter/material.dart';

final callback = Callback(
  onCreate: (database, version) {
    DBProvider.insertAllFixturesInDatabase(database);
  },
  onOpen: (database){ /* database has been opened */},
  onUpgrade: (database, startPVersion, endVersion) { /* database has been upgraded */ },
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database =
      await $FloorAppDatabase.databaseBuilder('flutter_database.db')
          .addCallback(callback).build().catchError((err)=>print(err.toString()));
  setOneSignalListeners();
  var cards = await database.cardDao.findAvailableCardsFromDeckId(1, DateTime.now().millisecondsSinceEpoch);
  var deck = await database.deckDao.findDeckById(1);
  WidgetsFlutterBinding.ensureInitialized();
  runApp(AppStateContainer(
      state: AppState(), child: MyApp(database: database, deck: deck, cards: cards)));
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
              TinderLikePage(cardDao: database.cardDao)
//              CardShowPage(card: cards[0]),
//              CardListPage(database: database,),
//            LateInitPage(deckId: 1)
//            SynchronizePage()
//            DeckInfoPage(cardDao: database.cardDao, deck: deck,),
//          DeckPage(cardDao: database.cardDao, deckDao: database.deckDao)
//        GuessPage(appDatabase: database, cards: cards, deckId: 1,)
//        CreateCardPage(cardDao: database.cardDao, deck: deck,)

//      home: BasicContainer(child:
//      ),

      ),
    );
  }
}
