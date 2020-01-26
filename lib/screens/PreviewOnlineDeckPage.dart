import 'package:benkyou/constants/colors.dart';
import 'package:benkyou/models/DTO/PublicCard.dart';
import 'package:benkyou/models/DTO/PublicDeck.dart';
import 'package:benkyou/models/Deck.dart';
import 'package:benkyou/services/database/DBProvider.dart';
import 'package:benkyou/services/database/Database.dart';
import 'package:benkyou/services/database/DeckDao.dart';
import 'package:benkyou/services/navigator.dart';
import 'package:benkyou/utils/string.dart';
import 'package:benkyou/widgets/Header.dart';
import 'package:benkyou/widgets/app/BasicContainer.dart';
import 'package:benkyou/widgets/dialog/CreateDeckDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PreviewOnlineDeckPage extends StatefulWidget{
  final PublicDeck deck;
  final DeckDao deckDao;

  const PreviewOnlineDeckPage({Key key, @required this.deck, @required this.deckDao}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PreviewOnlineDeckPageState();

}

class PreviewOnlineDeckPageState extends State<PreviewOnlineDeckPage>{
  List<PublicCard> _visibleCards = [];
  bool _isJapanese = true;

  @override
  void initState() {
    super.initState();
    _visibleCards = widget.deck.cards;
  }


  @override
  void dispose() {
    super.dispose();
  }

  void displayMatchingCards(){
    List<PublicCard> allCards = widget.deck.cards;
    List<PublicCard> tmpList = [];
    for (PublicCard card in allCards){
      if (!card.isForeignWord == _isJapanese){
        tmpList.add(card);
      }
    }
    setState(() {
      _visibleCards = tmpList;
    });
  }

  @override
  Widget build(BuildContext context) {
  displayMatchingCards();
    return BasicContainer(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Header(title: "${widget.deck.title}", backFunction: (){
            goToBrowsingDeckPage(context);
          },),
          Expanded(
            flex: 1,
              child: Container(
                  child: Center(
                    child: Text(widget.deck.description.isEmpty ?
                    "No description available" : widget.deck.description,
                      textAlign: TextAlign.center,
                    ),
                  )
              )
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      _isJapanese = true;
                    });
                  },
                  child: Container(
                      color: COLOR_BLUE,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Japanese".toUpperCase(),
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      )
                  ),
                ),
              ),

              Expanded(
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      _isJapanese = false;
                    });
                  },
                  child: Container(
                      color: COLOR_DARK_GREY,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "English".toUpperCase(),
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      )
                  ),
                ),
              ),

            ],
          ),
          Expanded(
            flex: 4,
            child: ListView.separated(
                shrinkWrap: true,
                itemCount: _visibleCards.length,
                itemBuilder: (BuildContext context, int index){

                  return Card(
                    elevation: 8.0,
                    child: ListTile(
                      title: Text(
                          getReadableMultipleAnswers(_visibleCards[index].question)
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index){
                  return Divider();
                },
            ),
          ),
          FutureBuilder(
            future: widget.deckDao.findDeckByPublicRef('${widget.deck.author}:${widget.deck.title}'),
            builder: (BuildContext context, AsyncSnapshot<Deck> snapshot) {
              return GestureDetector(
                onTap: () async{
                  AppDatabase appDatabase = await DBProvider.db.database;
                  if (snapshot.data != null) {
                    await widget.deckDao.createDeckFromPublic(widget.deck);
                    goToDeckInfoPage(context, snapshot.data.id);
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            CreateDeckDialog(
                              deckDao: appDatabase.deckDao,
                              isFromPublic: true,
                              publicDeck: widget.deck,
                            )
                    );
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.1,
                  color: Colors.blueGrey,
                  child: Center(
                    child: Text(
                      (snapshot.data != null) ? "Update local ref".toUpperCase() : "Import this deck".toUpperCase(),
                      style: TextStyle(fontSize: 26, color: Colors.white),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

}