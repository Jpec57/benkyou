import 'package:benkyou/models/Card.dart' as card_model;
import 'package:benkyou/models/DTO/PublicDeck.dart';
import 'package:benkyou/models/Deck.dart';
import 'package:benkyou/screens/CreateCardPage.dart';
import 'package:benkyou/screens/GuessPage.dart';
import 'package:benkyou/screens/LateInitPage.dart';
import 'package:benkyou/services/database/CardDao.dart';
import 'package:benkyou/services/database/DBProvider.dart';
import 'package:benkyou/services/database/Database.dart';
import 'package:benkyou/services/login.dart';
import 'package:benkyou/services/navigator.dart';
import 'package:benkyou/widgets/Header.dart';
import 'package:benkyou/widgets/ReviewSchedule.dart';
import 'package:benkyou/widgets/SRSPreview.dart';
import 'package:benkyou/widgets/WallOfShamePreview.dart';
import 'package:benkyou/widgets/app/BasicContainer.dart';
import 'package:benkyou/widgets/dialog/PublishDeckDialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeckInfoPage extends StatefulWidget {
  final CardDao cardDao;
  final Deck deck;

  DeckInfoPage({Key key, @required this.cardDao, @required this.deck})
      : super(key: key);

  @override
  _DeckInfoPageState createState() => _DeckInfoPageState();
}

class _DeckInfoPageState extends State<DeckInfoPage> {
  List<card_model.Card> availableCards;
  bool _hasNoSolutionCards = false;

  @override
  void initState() {
    super.initState();
    loadAvailableCards();
    checkIfAwaitingCards();
  }

  void checkIfAwaitingCards() async {
    List<card_model.Card> awaitingCards =
        await widget.cardDao.findCardsWithoutSolution(deckId: widget.deck.id);
    setState(() {
      _hasNoSolutionCards = (awaitingCards.isNotEmpty);
    });
  }

  void loadAvailableCards() async {
    availableCards = await widget.cardDao.findAvailableCardsFromDeckId(
        widget.deck.id, DateTime.now().millisecondsSinceEpoch);
  }

  Future<bool> _hasAlreadyPublicRef(String uuid) async {
    if (uuid == null) {
      return false;
    }
    DocumentSnapshot snapshot = await Firestore.instance
        .collection('decks')
        .document('${uuid}:${widget.deck.title}')
        .get();
    return !(snapshot == null || !snapshot.exists);
  }

  @override
  Widget build(BuildContext context) {
    return BasicContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                        builder: (context) =>
                            LateInitPage(deckId: widget.deck.id)));
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
              ReviewSchedule(
                cardDao: widget.cardDao,
                deckId: widget.deck.id,
                colors: [
                  Color(0xff646461),
                  Color(0xff248CCB),
                ],
              ),
              SRSPreview(
                cardDao: widget.cardDao,
                deckId: widget.deck.id,
              ),
              WallOfShamePreview(
                  cardDao: widget.cardDao, deckId: widget.deck.id),
              GestureDetector(
                onTap: (){
                  goToTinderLikePage(context, deckId: widget.deck.id);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2.0),
                  child: Container(
                      color: Colors.orange,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
                        child: Text(
                          "Quick review".toUpperCase(),
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
      FutureBuilder(
          future: getCurrentUsername(),
          builder:
              (BuildContext context, AsyncSnapshot<String> currentUsername) {
            if (!currentUsername.hasData || currentUsername.data == null) {
              return Container();
            }
            return FutureBuilder(
              future: _hasAlreadyPublicRef(currentUsername.data),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                return GestureDetector(
                    onTap: () async {
                      if (snapshot.hasData && snapshot.data) {
                        Map<String, dynamic> data = await convertDeckToPublic(
                            widget.deck, currentUsername.data);
                        await Firestore.instance
                            .collection('decks')
                            .document(
                                '${currentUsername.data}:${widget.deck.title}')
                            .setData(data);
                        goToBrowsingDeckPage(context);
                      } else {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return PublishDeckDialog(
                                author: currentUsername.data,
                                deck: widget.deck);
                          },
                        );
                      }
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: double.infinity,
                      color: Color(0xff646461),
                      child: Center(
                        child: Text(
                          (snapshot.hasData && snapshot.data)
                              ? "Update online".toUpperCase()
                              : "Make public".toUpperCase(),
                          style: TextStyle(fontSize: 30, color: Colors.white),
                        ),
                      ),
                    ));
              },
            );
          }),
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
          height: MediaQuery.of(context).size.height * 0.07,
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
          height: MediaQuery.of(context).size.height * 0.07,
          decoration: BoxDecoration(color: Color(0xff248CCB)),
          child: Center(
            child: FutureBuilder(
                future: widget.cardDao.findAvailableCardsFromDeckId(
                    widget.deck.id, DateTime.now().millisecondsSinceEpoch),
                builder: (_, AsyncSnapshot<List<card_model.Card>> snapshot) {
                  if (snapshot.hasData &&
                      snapshot.data != null &&
                      snapshot.data.isNotEmpty) {
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
                                    )));
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
