import 'package:benkyou/models/Card.dart' as card_model;
import 'package:benkyou/models/CardWithAnswers.dart';
import 'package:benkyou/services/database/Database.dart';
import 'package:benkyou/services/navigator.dart';
import 'package:benkyou/utils/string.dart';
import 'package:benkyou/widgets/app/BasicContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardListPage extends StatefulWidget {
  final AppDatabase database;

  const CardListPage({Key key, @required this.database}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CardListPageState();
}

class CardListPageState extends State<CardListPage> {
  TextEditingController _filter;
  String _searchTerm = '';
  List<CardWithAnswers> _cards = new List();
  List<CardWithAnswers> _filteredCards = new List();
  DragStartDetails startHorizontalDragDetails;
  DragUpdateDetails updateHorizontalDragDetails;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _filter = new TextEditingController();
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchTerm = "";
          _filteredCards = _cards;
        });
      } else {
        setState(() {
          _searchTerm = _filter.text;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _filter.dispose();
  }

  Widget _buildList() {
    return FutureBuilder(
        future: widget.database.cardDao.findAllCardsWithAnswers(),
        builder: (BuildContext context,
            AsyncSnapshot<List<CardWithAnswers>> snapshot) {
          if (snapshot.hasData) {
            if (_searchTerm.isNotEmpty) {
              _filteredCards = new List<CardWithAnswers>();
              String researchTermFormatted = getComparableString(_searchTerm);
              for (CardWithAnswers card in snapshot.data) {
                if (_doesCardContainString(card, researchTermFormatted)) {
                  _filteredCards.add(card);
                }
              }
            } else {
              _filteredCards = snapshot.data;
            }
            return ListView.separated(
              itemCount: _cards == null ? 0 : _filteredCards.length,
              itemBuilder: (BuildContext context, int index) {
                return ExpansionTile(
                  title: Text(_getTitleFormat(_filteredCards[index])),
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        goToCardPage(context, _filteredCards[index]);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount:
                              _filteredCards[index].answerContents.length,
                          itemBuilder: (BuildContext context, int subIndex) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(_filteredCards[index]
                                    .answerContents[subIndex]),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => Divider(),
                        ),
                      ),
                    )
                  ],
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
            );
          }
          return Text("Empty list. Please create a card first.");

        });
  }

  bool _doesCardContainString(
      CardWithAnswers card, String researchTermFormatted) {
    //TODO add romaji from kana
    List<String> cardStrings = [
      card.question,
      card.hint,
      ...card.answerContents
    ];
    for (String string in cardStrings) {
      if (string != null) {
        String comparableString = getComparableString(string);
        if (comparableString.isNotEmpty &&
            comparableString.contains(researchTermFormatted)) {
          return true;
        }
      }
    }
    return false;
  }

  String _getTitleFormat(card_model.Card card) {
    if (card.hint != null && card.hint.trim().isNotEmpty) {
      return '${card.question} - ${card.hint}';
    }
    return '${card.question}';
  }

  Widget _renderSearchBar() {
    if (_isSearching) {
      return Container(
        child: Padding(
          padding: const EdgeInsets.only(
              left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: TextField(
              controller: _filter,
            ),
          ),
        ),
      );
    }
    return Container(
      child: Text(
        "Card List",
        style: TextStyle(fontSize: 30, fontFamily: 'Pacifico'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BasicContainer(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20.0),
            height: MediaQuery.of(context).size.height * 0.12,
            decoration: BoxDecoration(color: Colors.orange),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      goToHomePage(context);
                    },
                    child: Container(
                        child: Image.asset('resources/imgs/arrow_back.png')),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Align(widthFactor: 3, child: _renderSearchBar()),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isSearching = !_isSearching;
                      });
                    },
                    child: Container(
                      child: Image.asset('resources/imgs/search.png'),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Padding(
                padding: const EdgeInsets.all(8.0), child: _buildList()),
          ),
        ],
      ),
    );
  }
}
