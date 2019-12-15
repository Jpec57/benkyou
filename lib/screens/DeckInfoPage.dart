import 'package:benkyou/models/Card.dart' as cardModel;
import 'package:benkyou/models/Deck.dart';
import 'package:benkyou/screens/CreateCardPage.dart';
import 'package:benkyou/screens/GuessPage.dart';
import 'package:benkyou/screens/LateInitPage.dart';
import 'package:benkyou/services/database/CardDao.dart';
import 'package:benkyou/services/database/DBProvider.dart';
import 'package:benkyou/services/database/Database.dart';
import 'package:benkyou/widgets/Header.dart';
import 'package:benkyou/widgets/SRSPreview.dart';
import 'package:benkyou/widgets/WallOfShamePreview.dart';
import 'package:benkyou/widgets/app/BasicContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeckInfoPage extends StatefulWidget {
  final CardDao cardDao;
  final Deck deck;

  DeckInfoPage({Key key, @required this.cardDao, @required this.deck})
      : super(key: key);

  @override
  _DeckInfoPageState createState() => _DeckInfoPageState();
}

class _DeckInfoPageState extends State<DeckInfoPage> {
  List<cardModel.Card> availableCards;
  bool _hasNoSolutionCards = false;

  @override
  void initState() {
    super.initState();
    loadAvailableCards();
    checkIfAwaitingCards();
  }

  void checkIfAwaitingCards() async{
    List<cardModel.Card> awaitingCards = await widget.cardDao.findCardsWithoutSolution(deckId: widget.deck.id);
    setState(() {
      _hasNoSolutionCards = (awaitingCards.length > 0);
    });
  }

  void loadAvailableCards() async {
    availableCards = await widget.cardDao.findAvailableCardsFromDeckId(
        widget.deck.id, DateTime.now().millisecondsSinceEpoch);
  }

  @override
  Widget build(BuildContext context) {
    return BasicContainer(
        child: Column(
            children: <Widget>[
              Header(
                  title: this.widget.deck.title,
                  type: HEADER_ICON,
                  icon: Visibility(
                    visible: _hasNoSolutionCards,
                    child: GestureDetector(
                      onTap: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LateInitPage(deckId: widget.deck.id)
                            )
                        );
                      },
                      child: Container(
                        child: Image.asset('resources/imgs/waiting_cards.png'),
                      ),
                    ),
                  )),
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
            SRSPreview(cardDao: widget.cardDao, deckId: widget.deck.id,),
              WallOfShamePreview(cardDao: widget.cardDao, deckId: widget.deck.id),
            ],
          ),
        ),
      ),
      GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateCardPage(
                        cardDao: widget.cardDao,
                        deck: widget.deck,
                      )));
        },
        child: Container(
          height: MediaQuery.of(context).size.height * 0.10,
          decoration: BoxDecoration(color: Colors.orange),
          child: Center(
            child: Text(
              'Add a card'.toUpperCase(),
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
          ),
        ),
      ),
      GestureDetector(
        onTap: () {},
        child: Container(
          height: MediaQuery.of(context).size.height * 0.10,
          decoration: BoxDecoration(color: Colors.lightBlue),
          child: Center(
            child: FutureBuilder(
                future: widget.cardDao.findAvailableCardsFromDeckId(
                    widget.deck.id, DateTime.now().millisecondsSinceEpoch),
                builder: (_, AsyncSnapshot<List<cardModel.Card>> snapshot) {
                  if (snapshot.hasData &&
                      snapshot.data != null &&
                      snapshot.data.length >= 1) {
                    return GestureDetector(
                      onTap: () async {
                        AppDatabase appDatabase = await DBProvider.db.database;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GuessPage(
                                      appDatabase: appDatabase,
                                      cards: snapshot.data,
                                  deckId: widget.deck.id,
                                    )
                            )
                        );
                      },
                      child: Text(
                        '${availableCards != null ? availableCards.length : 0} Review${availableCards != null && availableCards.length > 1 ? 's' : ''}'
                            .toUpperCase(),
                        style: TextStyle(fontSize: 30, color: Colors.white),
                      ),
                    );
                  }
                  return (Text(
                    '0 Review'.toUpperCase(),
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ));
                }),
          ),
        ),
      )
    ]));
  }
}
