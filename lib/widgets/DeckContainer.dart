import 'dart:io';

import 'package:benkyou/models/Deck.dart';
import 'package:benkyou/screens/DeckInfoPage.dart';
import 'package:benkyou/screens/DeckPage.dart';
import 'package:benkyou/services/database/CardDao.dart';
import 'package:benkyou/services/database/DBProvider.dart';
import 'package:benkyou/services/database/Database.dart';
import 'package:flutter/cupertino.dart';
import 'package:benkyou/models/Deck.dart' as deck_model;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class DeckContainer extends StatefulWidget {
  final CardDao cardDao;
  final Deck deck;
  final int index;
  final DeckPageState parent;

  const DeckContainer(
      {Key key,
      @required this.cardDao,
      @required this.deck,
      @required this.index,
        @required this.parent})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => DeckContainerState();
}

class DeckContainerState extends State<DeckContainer> {
  bool _isDeleteVisible = false;
  final List<Color> colorCodes = [
    Color(0xff646461),
    Color(0xff248CCB),
    Color(0xff248CCB),
    Color(0xff646461)
  ];

  void loadDeckCards(deck_model.Deck deck) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DeckInfoPage(
                  cardDao: widget.cardDao,
                  deck: deck,
                )));
  }

  void deleteDeck() async{
    //TODO delete remotely
    AppDatabase database = await DBProvider.db.database;
    database.deckDao.deleteDeck(widget.deck.id);
    widget.parent.setState((){});
  }

  Future<ImageProvider> getImageProvider() async{
    final String path = (await getApplicationDocumentsDirectory()).path;
    File file = File('$path/decks/${widget.deck.title}/cover.png');
    return file.existsSync()
        ? FileImage(file)
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            loadDeckCards(widget.deck);
          },
          onLongPress: () {
            setState(() {
              _isDeleteVisible = !_isDeleteVisible;
            });
          },
          child: FutureBuilder(
            future: getImageProvider(),
            builder: (BuildContext context, AsyncSnapshot<ImageProvider> snapshot) {
              BoxDecoration deco;
              if (snapshot.hasData && snapshot.data != null){
                deco = BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: snapshot.data,
                    ),
                    color: colorCodes[widget.index % colorCodes.length],
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(width: 2.0, color: Colors.black54)
                );
              } else {
                deco = BoxDecoration(
                    color: colorCodes[widget.index % colorCodes.length],
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(width: 2.0, color: Colors.black54)
                );
              }
              return Container(
                decoration: deco,
                child: Center(
                  child: Text(
                    widget.deck.title,
                    key: ValueKey('deck-${widget.index}'),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(1.0, 1.0),
                          blurRadius: 3.0,
                          color: Colors.black,
                        ),
                        Shadow(
                          offset: Offset(1.0, 1.0),
                          blurRadius: 3.0,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          child: Visibility(
            visible: _isDeleteVisible,
            child: GestureDetector(
              onTap: () {
                deleteDeck();
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                child: Image.asset('resources/imgs/delete.png',
                    width: 30, height: 30),
              ),
            ),
          ),
          right: 0,
        )
      ],
    );
  }
}
